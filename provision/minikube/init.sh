#!/bin/bash
#!/bin/bash

# install dependencies
# flux
brew install fluxcd/tap/flux
# minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
