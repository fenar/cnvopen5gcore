#!/usr/bin/env bash

echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc adm policy add-scc-to-user anyuid -z default
oc adm policy add-scc-to-user hostaccess -z default
oc adm policy add-scc-to-user hostmount-anyuid -z default
#echo -e "Creating the needed certificates....\n"
#echo
#cd ca-tls-certificates
#oc create secret -n open5gs generic mongodb-ca --from-file=rds-combined-ca-bundle.pem
#echo
#oc get secret -n open5gs
#pwd
cd helm-chart
oc create -f upfhd1-pvc.yaml
echo "Deploying Open5Gs"
helm -n open5gs install -f values.yaml 5gcore ./
echo "Enjoy!"
