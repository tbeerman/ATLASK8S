#! /bin/bash

export NAME=atlasrucioint
export MINIONS=2
export MINIONSIZE=m2.large
export TEMPLATE=atlasrucio-191119
openstack coe cluster create $NAME --keypair lxplus --os-project-name Rucio --node-count $MINIONS --cluster-template $TEMPLATE --master-flavor m2.large --flavor $MINIONSIZE
