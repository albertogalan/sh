#!/bin/bash 


set -euo pipefail
set -x
flux bootstrap github --owner=albertogalan --repository=infra-minikube --branch=develop --path=./kustomize/dev



