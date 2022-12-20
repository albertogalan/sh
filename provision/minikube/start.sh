#!/bin/bash 
minikube start --kubernetes-version v1.21.0 --memory 8192 --cpus 3 --extra-config=apiserver.v=10 --extra-config=kubelet.max-pods=100
minikube addons enable ingress 
minikube addons enable registry-creds
minikube addons enable metrics-server
#minikube addons enable istio #

