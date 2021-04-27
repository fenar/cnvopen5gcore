#!/usr/bin/env bash
#Author: fenar
# Ref: https://github.com/aligungr/UERANSIM/wiki/Installation
sudo apt update
sudo apt upgrade -y
sudo apt install make -y
sudo apt install g++ -y
sudo apt install libsctp-dev lksctp-tools -y
sudo apt install iproute2 -y
sudo snap install cmake --classic 
cd ~
git clone https://github.com/aligungr/UERANSIM
cd ~/UERANSIM
make
