#!/usr/bin/env bash
#Author: fenar
echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 
current_dir=$PWD
oc create secret generic mongodb-ca --from-file=$current_dir/5gcore-helm/ca-tls-certificates/rds-combined-ca-bundle.pem
oc get secret
cd 5gcore-helm
echo "Deploying Open5G Core"
helm install -f values.yaml 5gcore ./
echo "Enjoy The Open 5G Core!"
