#!/usr/bin/env bash
#Author: fenar
echo -e "World is About to End!....\n"
echo
echo "Creating Istio Ingress Virtual Service"
oc delete -f istio-manifests/open5gsweb.yaml
cd 5gcore-helm
echo "Removing Open5GCore"
helm uninstall 5gcore
echo "The End"
