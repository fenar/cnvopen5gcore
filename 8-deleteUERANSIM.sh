#!/usr/bin/env bash
#Author: fenar
echo -e "Wiping UERANSIM....\n"
echo
cd ueransim-helm
echo "Removing UERANSIM Deployment"
helm -n open5gs uninstall ueransim
echo "Bye"
