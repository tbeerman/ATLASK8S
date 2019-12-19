#!/bin/bash

export CLUSTER=atlasrucioint2
mkdir -p ${HOME}/ws/helm_home_${CLUSTER}
export HELM_HOME="${HOME}/ws/helm_home_${CLUSTER}"
export HELM_TLS_ENABLE="true"
export TILLER_NAMESPACE="magnum-tiller"

kubectl -n magnum-tiller get secret helm-client-secret -o jsonpath='{.data.ca\.pem}' | base64 --decode > "${HELM_HOME}/ca.pem"
kubectl -n magnum-tiller get secret helm-client-secret -o jsonpath='{.data.key\.pem}' | base64 --decode > "${HELM_HOME}/key.pem"
kubectl -n magnum-tiller get secret helm-client-secret -o jsonpath='{.data.cert\.pem}' | base64 --decode > "${HELM_HOME}/cert.pem"

helm ls
helm init -c
helm repo update

helm upgrade -f prometheus-pvc-values.yaml prometheus-operator stable/prometheus-operator --namespace=kube-system --version 5.12.3 --recreate-pods
