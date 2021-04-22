#!/usr/bin/env bash

#Script written to install the pre-requisite resources that are needed

echo -e "Creating open5gs namespace....\n"

echo

oc new-project open5gs

echo -e "Creating the needed certificates....\n"

echo

cd ca-tls-certificates

oc create secret -n open5gs generic mongodb-ca --from-file=rds-combined-ca-bundle.pem

echo
oc get secret -n open5gs

echo "You can now proceed to install the Helm chart"
