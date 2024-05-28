#!/usr/bin/env bash
kubectl create namespace mariadb-service
helm repo add mariadb-operator https://mariadb-operator.github.io/mariadb-operator
helm install mariadb-operator mariadb-operator/mariadb-operator --set metrics.enabled=true --set webhook.cert.certManager.enabled=true
kubectl create secret generic mariadb --from-literal=root-password=acleartextpassword
echo "now we wait...180 seconds"
sleep 180
kubectl apply -n mariadb-service -f .
