#!/bin/bash

kuchg k3s
APPLI=config/applications
K3S=config/k3s

# Delete previous applications versions
kubectl delete -k ${APPLI}/jsc-cloudflare
kubectl delete -k ${APPLI}/jsc-k3s-dashboard
kubectl delete -k ${APPLI}/sawan
kubectl delete -f ${APPLI}/jsc-torrent/03-service.yaml
kubectl delete -f ${APPLI}/jsc-torrent/02-deployment.yaml

# Apply new applications versions
kubectl apply -k ${APPLI}/sawan
kubectl apply -k ${APPLI}/rochefolle
kubectl apply -k ${APPLI}/jsc-k3s-dashboard
kubectl apply -k ${APPLI}/jsc-torrent
kubectl apply -k ${APPLI}/jsc-cloudflare

# Delete ingress
kubectl delete -f ${K3S}/02-ingress.yaml

# Update ingress
kubectl apply -f ${K3S}/02-ingress.yaml

