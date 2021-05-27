#!/usr/bin/env bash
#Author: fenar
echo -e "Wiping UERANSIM....\n"
echo
cd 5gran
rm amf-ip
echo "Removing UERANSIM Deployment"
rm templates/5gran-gnb-configmap.yaml
helm uninstall 5gran
echo "Bye"
