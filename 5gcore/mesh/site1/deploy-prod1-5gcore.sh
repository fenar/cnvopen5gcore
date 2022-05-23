#!/usr/bin/env bash
#Author: fenar
current_dir=$PWD
oc create secret generic mongodb-ca --from-file=$current_dir/5gcore/ca-tls-certificates/rds-combined-ca-bundle.pem
oc get secret
cd ..
cd ..
echo "Deploying Open5G Core Prod1"
helm install -f values.yaml prod1-5gcore ./
echo "Enjoy The Open 5G Core on Production 1!"
