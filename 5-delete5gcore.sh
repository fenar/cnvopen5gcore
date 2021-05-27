#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo
oc delete secret mongodb-ca
cd 5gcore
echo "Removing Open5GCore"
helm uninstall 5gcore
echo "The End"
