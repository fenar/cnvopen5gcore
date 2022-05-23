#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

log "Creating projects for prod2-mesh"
oc new-project prod2-mesh || true
oc new-project prod2-5gcore || true

log "Installing control plane for prod-mesh"
oc apply -f prod2-smcp.yaml
oc apply -f prod2-smmr.yaml

log "Waiting for prod-mesh installation to complete"
oc wait --for condition=Ready -n prod2-mesh smmr/default --timeout 300s

log "Installing 5gcore application in prod-mesh"
./0-deploy5gcore.sh

log "Retrieving Istio CA Root certificates"
PROD_MESH_CERT=$(oc get configmap -n prod2-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')

log "Enabling federation for prod-mesh"
sed "s:{{STAGE_MESH_CERT}}:$STAGE_MESH_CERT:g" prod2-stage-mesh-ca-root-cert.yaml | oc apply -f -
oc apply -f prod2-smp.yaml
oc apply -f prod2-iss.yaml

log "Installing VirtualService for prod-mesh"
oc apply -n prod2-5gcore -f prod2-vs-mirror-details.yaml

log "INSTALLATION COMPLETE"
oc -n prod2-mesh get servicemeshpeer prod1-mesh -o json | jq .status
oc -n prod2-mesh get importedservicesets prod1-mesh -o json | jq .status
