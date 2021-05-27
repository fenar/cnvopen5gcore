#!/usr/bin/env bash
#Author: fenar
echo -e "Creating Project: open5gcore\n"
oc new-project open5gcore
echo -e "Adding project to service mesh member-roll\n"
oc -n istio-system patch --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"open5gcore"'"]}]'
echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 
current_dir=$PWD
oc create secret generic mongodb-ca --from-file=$current_dir/5gcore/ca-tls-certificates/rds-combined-ca-bundle.pem
oc get secret
cd 5gcore
echo "Deploying Open5G Core"
helm install -f values.yaml 5gcore ./
echo "Enjoy The Open 5G Core!"
