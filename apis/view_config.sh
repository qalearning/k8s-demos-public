#!/bin/bash
. ../demo-magic.sh
clear

pe "cat ~/.kube/config"

pe "kubectl config view"

