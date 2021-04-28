#!/usr/bin/env bash
#Author: fenar
echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc project open5gcore
oc adm policy add-scc-to-user anyuid -z default -n open5gs
oc adm policy add-scc-to-user hostaccess -z default -n open5gs
oc adm policy add-scc-to-user hostmount-anyuid -z default -n open5gs
oc adm policy add-scc-to-user privileged -z default -n open5gs
cd 5gcore-helm
echo "Deploying Open5Gs"
helm -n open5gcore install -f values.yaml 5gcore ./
echo "Enjoy The Open 5G Core!"
