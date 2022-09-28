#!/bin/bash

. ../demo-magic.sh
clear

pe "kubectl auth can-i create pod"
pe "kubectl auth can-i create pod --as alice"
pe "kubectl auth can-i create pod --as system:serviceaccount:default:default"
pe "kubectl auth can-i create pod --as system:serviceaccount:default:invisible-sa"
