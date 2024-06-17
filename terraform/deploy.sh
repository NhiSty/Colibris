#!/bin/bash

# Mise à jour des paquets
sudo apt update

# Installation de Docker
sudo apt install -y docker.io

# Ajout de l'utilisateur courant au groupe Docker (pour éviter l'utilisation de sudo)
sudo usermod -aG docker $USER

sudo apt install -y git

# Clonage du référentiel docker-nginx-hello-world
git clone https://github.com/NhiSty/Colibris.git

# Accéder au répertoire cloné
cd Colibris/Back

# Création de l'image Docker
docker compose -f docker-nginx-proxy-compose. up -d
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d




