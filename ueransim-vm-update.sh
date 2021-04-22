#!/usr/bin/env bash
# Setting UERANSIM Sandbox

sudo apt update
sudo apt upgrade -y
sudo apt install make -y
sudo apt install g++ -y
sudo apt install libsctp-dev lksctp-tools -y
sudo apt install iproute2 -y
sudo apt install git -y
sudo snap install cmake --classic
git clone https://github.com/aligungr/UERANSIM
cd ~/UERANSIM
make

