#!/usr/bin/env bash

export DAEMON_NAME=daemonint

echo "Removing existing secrets"

kubectl delete secret ${DAEMON_NAME}-rucio-ca-bundle ${DAEMON_NAME}-rucio-ca-bundle-reaper -n rucio

kubectl create secret generic ${DAEMON_NAME}-rucio-ca-bundle --from-file=/etc/pki/tls/certs/CERN-bundle.pem -n rucio

mkdir /tmp/reaper-certs
cp /etc/grid-security/certificates/*.0 /tmp/reaper-certs/
cp /etc/grid-security/certificates/*.signing_policy /tmp/reaper-certs/

kubectl create secret generic ${DAEMON_NAME}-rucio-ca-bundle-reaper --from-file=/tmp/reaper-certs/ -n rucio
rm -rf /tmp/reaper-certs

kubectl get secrets -n rucio
