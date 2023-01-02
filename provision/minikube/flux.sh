#!/bin/bash


set -euo pipefail
set -x
flux bootstrap github --owner=albertogalan --repository=infra-minikube --branch=develop --path=./kustomize/dev

if [ -f gpg.key ]
then
cat gpg.key | kubectl create secret generic sops-gpg --namespace=flux-system --from-file=sops.asc=/dev/stdin
else
  echo lack of gpg.key , plese add and run again
fi
