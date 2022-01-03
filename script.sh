#!/bin/bash

#Att sistema
echo "ATUALIZANDO SISTEMA";

 if ! apt-get update 
 then 
    apt update
    echo "Ocorreu um erro!1" 
    exit 1 
 fi
 
 if ! apt-get upgrade
 then 
    echo "Ocorreu um erro!2" 
    exit 1 
 fi
 
 if ! apt-get install
 then 
    echo "Ocorreu um erro!3" 
    exit 1 
 fi

 echo "Atualizacoes concluidas com sucesso!"

 if ! apt install figlet
 then 
    apt update
    echo "Ocorreu um erro!1" 
    exit 1 
 fi

figlet -c Server Script Duett Software

 #BAIXANDO E CONFIGURANDO VNC SERVER;

echo "DIGITE O NOME DE USUARIO:"
read name;
 
 echo "Baixando VNC SERVER"
 
 if ! apt install xfce4 xfce4-goodies
 then 
    echo "Ocorreu um erro!4" 
    exit 1 
 fi
 
 if ! sudo apt install tightvncserver
 then 
    echo "Ocorreu um erro!5" 
    exit 1 
 fi
 
 echo "INFORME UMA SENHA DE ACESSO PARA O SSH GRAPHIC (ENTRE 6 E 8 CARACTERES!)"
 
 if ! vncserver
 then 
    echo "Ocorreu um erro!6" 
    exit 1 
 fi
 
 if ! vncserver -kill :1
 then 
    vncserver -kill :2
    echo "Ocorreu um erro!7" 
    exit 1 
 fi
echo "INSTALANDO JAVASDK'S"

if ! apt-get install default-jre
 then 
    echo "Ocorreu um erro!9" 
    exit 1 
 fi

 if ! apt-get install default-jdk
 then 
    echo "Ocorreu um erro!10" 
    exit 1 
 fi

java -version
javac -version
 
echo "INSTALANDO DOCKER E KUBERNATES"
if ! sudo apt-get install docker.io
 then 
    echo "Ocorreu um erro!11" 
    exit 1 
 fi

 if ! sudo systemctl enable docker
 then 
    echo "Ocorreu um erro!12"
    sudo systemctl start docker 
    exit 1 
 fi

  if ! sudo apt-get install curl
 then 
    echo "Ocorreu um erro!14"
    exit 1 
 fi

if ! sudo apt-get install -y apt-transport-https ca-certificates curl 
 then 
    echo "Ocorreu um erro!15"
    exit 1 
 fi

 if ! sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
 then 
    echo "Ocorreu um erro!16"
    exit 1 
 fi

if ! apt-get install firefox
 then 
    echo "Ocorreu um erro!17"
    exit 1 
 fi

 if ! echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
 then 
    echo "Ocorreu um erro!18"
    exit 1 
 fi

sudo apt-get update

 if ! sudo apt-get install -y kubelet kubeadm kubectl
 then 
    echo "Ocorreu um erro!19"
    exit 1 
 fi

 if ! sudo apt-mark hold kubelet kubeadm kubectl
 then 
    echo "Ocorreu um erro!20"
    exit 1 
 fi

echo "MODIFICANDO ARQUIVOS"
if ! sudo rm /home/$name/.vnc/xstartup.sh
 then 
    echo "ERRO AO APAGAR O ARQUIVO" 
    exit 1 
 fi

git clone https://github.com/ArthurHenriqueDalosto/Server-Config-DuettSoftware.git

if ! sudo cp /home/$name/Server-Config-DuettSoftware/xstartup.sh /home/$name/.vnc
 then 
    echo "ERRO AO COPIAR O ARQUIVO" 
    exit 1 
 fi

echo "ADICIONANDO TAREFA AUTOMATICA"

sudo cat > /etc/systemd/system/vncserver@.service<<EOT
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User=$name
Group=$name
WorkingDirectory=/home/$name

PIDFile=/home/$name/.vnc/%H:%i.pid
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1366x768 -localhost :%i

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1

echo "VERIFICANDO STATUS DO SERVIDOR"
sudo systemctl status vncserver@1
