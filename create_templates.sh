#!/bin/bash
set -x

namespace=Rucio

# list templates
openstack --os-project-name "$namespace" coe cluster template list


tmpl=atlasrucio-191211

openstack --os-project-name "$namespace" coe cluster template delete $tmpl

openstack \
    --os-project-name "$namespace" coe cluster template create $tmpl \
    --labels influx_grafana_dashboard_enabled="false" \
    --labels cephfs_csi_enabled="true" \
    --labels ingress_controller="traefik" \
    --labels kube_csi_version="cern-csi-1.0-2" \
    --labels cloud_provider_tag="v1.15.0" \
    --labels container_infra_prefix="gitlab-registry.cern.ch/cloud/atomic-system-containers/" \
    --labels manila_enabled="true" \
    --labels cgroup_driver="cgroupfs" \
    --labels autoscaler_tag="v1.15.2" \
    --labels kube_csi_enabled="true" \
    --labels cvmfs_csi_version="v1.0.0" \
    --labels admission_control_list="NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,Priority" \
    --labels flannel_backend="vxlan" \
    --labels manila_version="v0.3.0" \
    --labels cvmfs_csi_enabled="true" \
    --labels heat_container_agent_tag="stein-dev-2" \
    --labels kube_tag="v1.15.3" \
    --labels cephfs_csi_version="cern-csi-1.0-2" \
    --labels tiller_enabled="true" \
    --labels monitoring_enabled="true" \
    --labels grafana_admin_passwd="admin" \
    --labels auto_scaling_enabled="true" \
    --labels min_node_count="2" \
    --labels max_node_count="10" \
    --coe kubernetes \
    --image 2886e9bf-7702-4c06-99c1-39a9e7bd5951 \
    --external-network CERN_NETWORK \
    --fixed-network CERN_NETWORK \
    --network-driver flannel \
    --dns-nameserver 137.138.17.5 \
    --flavor m2.large \
    --master-flavor m2.large \
    --docker-storage-driver overlay2 \
    --server-type vm


openstack --os-project-name "$namespace" coe cluster template list


