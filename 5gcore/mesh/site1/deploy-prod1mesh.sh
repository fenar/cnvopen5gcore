#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

log "Creating projects for prod1-mesh"
oc new-project prod1-mesh || true
oc new-project prod1-5gcore || true

log "Installing control plane for prod-mesh"
oc apply -f prod1-smcp.yaml
oc apply -f prod1-smmr.yaml

log "Waiting for prod-mesh installation to complete"
oc wait --for condition=Ready -n prod1-mesh smmr/default --timeout 300s

log "Installing 5gcore application in prod-mesh"
./0-deploy5gcore.sh

log "Retrieving Istio CA Root certificates"
PROD_MESH_CERT=$(oc get configmap -n prod1-mesh istio-ca-root-cert -o jsonpath='{.data.root-cert\.pem}' | sed ':a;N;$!ba;s/\n/\\\n    /g')

log "Enabling federation for prod-mesh"
sed "s:{{STAGE_MESH_CERT}}:$STAGE_MESH_CERT:g" prod1-stage-mesh-ca-root-cert.yaml | oc apply -f -
oc apply -f prod1-smp.yaml
oc apply -f prod1-iss.yaml

log "Installing VirtualService for prod-mesh"
oc apply -n prod1-5gcore -f prod-vs-mirror-details.yaml

log "INSTALLATION COMPLETE"
oc -n prod1-mesh get servicemeshpeer prod2-mesh -o json | jq .status
oc -n prod1-mesh get importedservicesets prod2-mesh -o json | jq .status



