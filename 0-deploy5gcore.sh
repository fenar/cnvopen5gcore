#!/usr/bin/env bash
#Author: fenar
echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc adm policy add-scc-to-user anyuid -z default
oc adm policy add-scc-to-user hostaccess -z default
oc adm policy add-scc-to-user hostmount-anyuid -z default
cd helm-chart
oc create -f upfhd1-pvc.yaml
echo "Deploying Open5Gs"
helm -n open5gs install -f values.yaml 5gcore ./
echo "Enjoy!"
