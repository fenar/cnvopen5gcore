#!/usr/bin/env bash
#Author: fenar
oc project open5gs
oc adm policy add-scc-to-user anyuid -z default -n open5gs
oc adm policy add-scc-to-user hostaccess -z default -n open5gs
oc adm policy add-scc-to-user hostmount-anyuid -z default -n open5gs
oc adm policy add-scc-to-user privileged -z default -n open5gs
cd ueransim
## gNB Section
echo "Preparing gNB config"
oc get services | grep amf-open5gs-sctp | awk '{print $3}' > amf-ip
echo "AMF IP:" && cat amf-ip
sed -e "s/<put-your-amf-service-ip-here>/$(<amf-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i ueransim-gnb-configmap.yaml
echo "gNB Config:" && cat ueransim-gnb-configmap.yaml
oc create -f ueransim-gnb-configmap.yaml
oc create -f ueransim-gnb-deploy.yaml
## UE Section
echo "Preparing UE config"
oc get services | grep ueransim-gnb | awk '{print $3}' > gnb-ip
echo "gNB IP:" && cat gnb-ip
sed -e "s/<put-your-gnb-service-ip-here>/$(<gnb-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i ueransim-ue-configmap.yaml
echo "UE Config:" && cat ueransim-ue-configmap.yaml
oc create -f ueransim-ue-configmap.yaml
oc create -f ueransim-ue-deploy.yaml
echo "Enjoy The UERANSIM!"
