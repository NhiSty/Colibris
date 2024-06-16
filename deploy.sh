#!/bin/bash


sudo apt update
sudo apt install -y golang
sudo usermod -aG docker $USER
git clone https://github.com/NhiSty/Colibris.git
cd Colibris
cd Back
go run main.go
