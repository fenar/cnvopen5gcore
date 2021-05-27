#!/usr/bin/env bash
#Author: fenar
cd ueransim-helm
## gNB Section
echo "Preparing gNB config"
oc get services | grep amf-open5gs-sctp | awk '{print $3}' > amf-ip
echo "AMF IP:" && cat amf-ip
cp templates/ueransim-gnb-configmap.yaml.bak templates/ueransim-gnb-configmap.yaml
sed -e "s/<put-your-amf-service-ip-here>/$(<amf-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i templates/ueransim-gnb-configmap.yaml
echo "gNB Config:" && cat templates/ueransim-gnb-configmap.yaml
helm install -f values.yaml ueransim ./
echo "Enjoy The UERANSIM!"
