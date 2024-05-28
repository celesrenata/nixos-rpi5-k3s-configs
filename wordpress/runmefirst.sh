#!/usr/bin/env bash
helm install wordpress-dev oci://registry-1.docker.io/bitnamicharts/wordpress --namespace wordpress-dev --create-namespace --set wordpressUsername=celes --set wordpressPassword=renata --set persistence.size=30Gi
kubectl apply -n wordpress-dev -f ../wordpress-dev
