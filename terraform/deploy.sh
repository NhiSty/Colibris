#!/bin/bash

# Mise à jour des paquets
sudo apt update

# Installation de Docker
sudo apt install -y docker.io

# Ajout de l'utilisateur courant au groupe Docker (pour éviter l'utilisation de sudo)
sudo usermod -aG docker $USER

sudo apt install -y git

# Clonage du référentiel docker-nginx-hello-world
git clone https://github.com/Einsteinish/docker-nginx-hello-world.git

# Accéder au répertoire cloné
cd docker-nginx-hello-world

# Construction de l'image Docker à partir du Dockerfile
docker build -t my-nginx-app .

# Exécution de l'image Docker dans un conteneur, en mappant le port 80 du conteneur au port 80 de l'hôte
docker run -d -p 80:80 my-nginx-app