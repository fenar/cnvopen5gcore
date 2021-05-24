#!/usr/bin/env bash
#Author: fenar
echo -e "Wiping UERANSIM....\n"
echo
cd ueransim
echo "Removing UERANSIM Deployment"
oc delete -f ueransim-gnb-configmap.yaml
oc delete -f ueransim-ue-configmap.yaml
oc delete -f ueransim-deploy.yaml
echo "Bye"
