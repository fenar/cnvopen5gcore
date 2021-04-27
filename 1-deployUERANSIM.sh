#!/usr/bin/env bash
#Author: fenar
oc project open5gs
cd ueransim-helm
echo "Deploying UERANSIM"
sed -e "s/<put-your-amf-service-ip-here>/$(<amf-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i ueransim-gnb-configmap.yaml
helm -n open5gs install -f values.yaml 5gcore-ue ./
echo "Enjoy The UERANSIM!"
