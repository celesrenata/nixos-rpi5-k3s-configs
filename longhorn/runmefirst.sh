#!/usr/bin/env bash
#kubectl create namespace longhorn-system
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace
echo "sometimes this step fails. if it does, run the cleanup-and-retry script"
helmfile apply
kubectl apply -n longhorn-system -f ingress.yaml
