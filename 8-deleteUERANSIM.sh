#!/usr/bin/env bash
#Author: fenar
echo -e "Wiping UERANSIM....\n"
echo

cd ueransim-helm
echo "Removing UERANSIM POD"
helm -n open5gs uninstall 5gcore-ue
echo "Bye"
