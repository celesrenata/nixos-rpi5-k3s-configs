#!/usr/bin/env bash
helm uninstall longhorn longhorn/longhorn -n longhorn-system
kubectl delete namespace longhorn-system
helmfile apply
kubectl apply -n longhorn-system -f ingress.yaml

