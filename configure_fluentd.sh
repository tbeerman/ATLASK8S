#!/bin/bash

kubectl patch daemonset --namespace kube-system fluentd -p '{"spec": {"template": {"spec": {"containers": [{"image": "gitlab-registry.cern.ch/tbeerman/fluentd-kubernetes-daemonset:v1.2-alpine-http", "name": "fluentd"}] }}}}'

kubectl delete configmap fluentd -n kube-system
kubectl create configmap fluentd -n kube-system --from-file=fluent.conf --from-file=kubernetes.conf

kubectl delete pods -l k8s-app=fluentd-logging -n kube-system
