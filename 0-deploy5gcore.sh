#!/usr/bin/env bash
#Author: fenar
echo -e "Configuring privileged access - Sorry it is what is....\n"
echo
oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 
current_dir=$PWD
cd 5gcore-helm
echo "Deploying Open5G Core"
helm install -f values.yaml 5gcorenew ./
cd $current_dir
echo "Creating Istio Ingress Virtual Service"
oc create -f istio-manifests/open5gsweb.yaml
echo "Enjoy The Open 5G Core!"
