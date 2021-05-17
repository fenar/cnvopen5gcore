#!/usr/bin/env bash
#Author: fenar
cd ueransim
## gNB Section
echo "Preparing gNB config"
oc get services | grep amf-open5gs-sctp | awk '{print $3}' > amf-ip
echo "AMF IP:" && cat amf-ip
cp ueransim-gnb-configmap.yaml.bak ueransim-gnb-configmap.yaml
sed -e "s/<put-your-amf-service-ip-here>/$(<amf-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i ueransim-gnb-configmap.yaml
echo "gNB Config:" && cat ueransim-gnb-configmap.yaml
oc create -f ueransim-gnb-configmap.yaml
oc create -f ueransim-ue-configmap.yaml
oc create -f ueransim-deploy.yaml
echo "Enjoy The UERANSIM!"
