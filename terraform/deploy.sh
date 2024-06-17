#cloud-boothook
#!/bin/bash

chmod +x "$0"
if ! [ -x "$(command -v docker)" ]; then
    sudo apt update
    sudo apt-get -y install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo apt install -y git
    sudo usermod -aG docker "$USER"
 
  exit 1
fi

if [ -d "Colibris" ]; then
  echo "Le dossier Colibris existe déjà"
else
  git clone https://github.com/NhiSty/Colibris.git
fi

cd Colibris/Back
cp .env.example .env
git checkout feat/cd
sudo docker compose -f docker-nginx-proxy-compose.yml up -d --build
sudo docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build



