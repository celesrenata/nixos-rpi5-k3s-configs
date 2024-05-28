#!/usr/bin/env bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 2>&1 > /dev/null &
echo "https://127.0.0.1:8443"
