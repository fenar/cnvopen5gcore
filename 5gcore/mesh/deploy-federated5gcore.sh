#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

log "Creating projects for prod-mesh"
oc new-project prod1-mesh || true
oc new-project prod1-5gcore || true
oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 

log "Installing control plane for prod-mesh"
oc apply -f site1/smcp.yaml
oc apply -f site1/smmr.yaml

log "Creating projects for prod2-mesh"
oc new-project prod2-mesh || true
oc new-project prod2-5gcore|| true

oc adm policy add-scc-to-user anyuid -z default 
oc adm policy add-scc-to-user hostaccess -z default 
oc adm policy add-scc-to-user hostmount-anyuid -z default 
oc adm policy add-scc-to-user privileged -z default 

log "Installing control plane for prod2-mesh"
oc apply -f site2/smcp.yaml
oc apply -f site2/smmr.yaml

log "Waiting for prod1-mesh installation to complete"
oc wait --for condition=Ready -n prod1-mesh smmr/default --timeout 300s

log "Waiting for prod2-mesh installation to complete"
oc wait --for condition=Ready -n prod2-mesh smmr/default --timeout 300s

log "Installing AMF CNF service in prod2-mesh"
oc apply -n prod2-5gcore -f site2/prod2-amf-v2.yaml

log "Installing Full 5gcore in prod1-mesh"
./site1/deploy-prod1-5gcore.sh

log "Retrieving Istio CA Root certificates"
PROD1_MESH_CERT=$(oc get configmap -n prod1-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')
PROD2_MESH_CERT=$(oc get configmap -n prod2-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')

log "Enabling federation for prod-mesh"
sed "s:{{PROD2_MESH_CERT}}:$PROD2_MESH_CERT:g" prod1-mesh/prod2-mesh-ca-root-cert.yaml | oc apply -f -
oc apply -f site1/prod1-smp.yaml
oc apply -f site1/prod1-iss.yaml

log "Enabling federation for prod2-mesh"
sed "s:{{PROD1_MESH_CERT}}:$PROD1_MESH_CERT:g" prod2-mesh/prod1-mesh-ca-root-cert.yaml | oc apply -f -
oc apply -f site2/prod2-smp.yaml
oc apply -f site2/prod2-ess.yaml

log "Installing VirtualService for prod-mesh"
oc apply -n prod1-5gcore -f site1/prod1-vs-mirror-details.yaml

log "INSTALLATION COMPLETE
#Run the following command in the prod-mesh to check the connection status:
  oc -n prod1-mesh get servicemeshpeer prod2-mesh -o json | jq .status
#Run the following command to check the connection status in prod2-mesh:
  oc -n prod2-mesh get servicemeshpeer prod1-mesh -o json | jq .status
#Check if services from prod2-mesh are imported into prod-mesh:
  oc -n prod1-mesh get importedservicesets prod2-mesh -o json | jq .status
#Check if services from prod2-mesh are exported:
  oc -n prod2-mesh get exportedservicesets prod1-mesh -o json | jq .status
"
