#!/bin/bash

# Creating Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install home ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

kubectl --namespace default get services -o wide -w home-ingress-nginx-controller
