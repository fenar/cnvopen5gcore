#!/usr/bin/env bash
#Author: fenar
oc new-project open5gran
oc adm policy add-scc-to-user anyuid -z default -n open5gran
oc adm policy add-scc-to-user hostaccess -z default -n open5gran
oc adm policy add-scc-to-user hostmount-anyuid -z default -n open5gran
oc adm policy add-scc-to-user privileged -z default -n open5gran
cd 5gran
## gNB Section
echo "Preparing gNB config"
oc get services -n open5gcore | grep amf-open5gs-sctp | awk '{print $3}' > amf-ip
echo "AMF IP:" && cat amf-ip
cp templates/5gran-gnb-configmap.bak templates/5gran-gnb-configmap.yaml
cp templates/5gran-ue-configmap.bak templates/5gran-ue-configmap.yaml
sed -e "s/<put-your-amf-service-ip-here>/$(<amf-ip sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g" -i templates/5gran-gnb-configmap.yaml
echo "gNB Config:" && cat templates/5gran-gnb-configmap.yaml
helm install -f values.yaml 5gran ./
echo "Enjoy The 5GRAN!"
