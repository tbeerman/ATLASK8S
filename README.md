# ATLASK8S

This repository contains a set of instructions and scripts to setup a Kubernetes cluster to run Rucio for ATLAS.

# First time setup for CERN Openstack

Follow the steps from the CERN cloud docs to initialize your environment on lxplus-cloud:
https://clouddocs.web.cern.ch/tutorial/create_your_openstack_profile.html

# Install a new cluster

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
