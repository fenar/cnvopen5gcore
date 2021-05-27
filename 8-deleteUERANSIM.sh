#!/usr/bin/env bash
#Author: fenar
echo -e "Wiping UERANSIM....\n"
echo
cd ueransim-helm
rm amf-ip
echo "Removing UERANSIM Deployment"
rm templates/ueransim-gnb-configmap.yaml
helm uninstall ueransim
echo "Bye"
