# ATLASK8S

This repository contains a set of instructions and scripts to setup a Kubernetes cluster to run Rucio for ATLAS.

## First time setup for CERN Openstack

Follow the steps from the CERN cloud docs to initialize your environment on lxplus-cloud:
https://clouddocs.web.cern.ch/tutorial/create_your_openstack_profile.html

## Install a new cluster

If not already done create a new cluster template. A cluster template with all necessary settings is provided and can be adapted as needed:

    <editor> create_template.sh
    ./create_template.sh
   
Now a new cluster can be started with the new template using a script. But before you might want to adapt the number of nodes, the cluster name and the keypair:

    <editor> create_cluster.sh
    ./create_cluster.sh
    
You can check the current status of the cluster using the openstack commands:

    openstack coe cluster list
    
If the cluster is in state CREATE_COMPLETE you can get the configuration, initialize kubectl and check if the nodes are running fine:

    openstack coe cluster config mykubcluster > env.sh
    . env.sh
    kubeget get nodes

## Install helm in the cluster

Helm is needed to install Rucio and some some other services in the cluster. No changes are needed, just run:

    ./install_helm.sh
    
## Install secrets

Some of the daemons need CAs to work that have to installed as secrets in the cluster. Before running the script adapt the DAEMON_NAME variable to match the name of the daemons release you will install in the cluster:

    <editor> create_secrets.sh
    ./create_secrets.sh
    
Furthermore the longproxy has to be installed in the cluster. To do so go to rucio-nagios-prod-03.cern.ch and adapt and run `/usr/local/bin/update-k8s-longproxy`.

## Setup logging

A CERN Monit logging producer is available and configured in the template. Without doing anything it will start to send out all the logs from the cluster to monit-timber and they can be accessed at https://monit-timber-atlasruciok8s.cern.ch.
To make the most use of the logs you should configure fluentd to extract some of the fields from the server and daemon logs. These include things like the http status code, rucio account name, request duration, etc. and they can then be used in visulizations in Kibana:
    
    ./configure_fluentd.sh
    
 ## Use logstash for monitoring
 
If you have problems with the fluentd pods not sending all the logs there is also a configuration provided to use Filebeat and Logstash instead. Just create the cluster without the monitoring enabled:
 
    helm install --values=logstash.yaml --name=logstash --namespace=monitoring stable/logstash
    helm install --values=filebeat.yaml --name=filebeat --namespace=monitoring stable/filebeat

## Setup ingress

The ingress is needed for the servers and the prometheus dashboard. Some nodes have to be dedicated to run the ingress by setting a label:

    kubectl label node <minion name> role=ingress
    
You can also easily setup a DNS entry for loadbalancing:

    openstack server set --property landb-alias=myclusterdns--load-1- <minion name>
    
## Add ingress for the Prometheus Grafana dashboard
 
To get easy access to the Grafana dashboard just use the provided ingress configuration. Just set the hostname or DNS name first:

    <editor> prometheus_ingress.yaml
    kubectl apply -f prometheus_ingress.yaml
    
The password is configured in the cluster template. To change is first run base64 on the new password and then change it in the secret:

    echo "<password>" | base64
    kubectl edit secret prometheus-operator-grafana -n kube-system
    kubectl get pods -l app=grafana,release=prometheus-operator -n kube-system
