#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo

cd helm-chart
echo "Removing Open5Gs"
helm -n open5gs uninstall 5gcore ./
#oc delete -f upfhd1-pvc.yaml
echo "The End"
