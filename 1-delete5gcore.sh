#!/usr/bin/env bash

echo -e "World is About to End!....\n"
echo
cd helm-chart
oc delete -f upfhd1-pvc.yaml
echo "Removing Open5Gs"
helm -n open5gs uninstall 5gcore ./
echo "The End"
