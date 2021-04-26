#!/usr/bin/env bash
#Author: fenar
echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc project open5gs
cd ueransim-helm
echo "Deploying UERANSIM"
helm -n open5gs install -f values.yaml 5gcore-ue ./
echo "Enjoy The UERANSIM!"
