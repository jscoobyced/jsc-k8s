#!/bin/bash

set -e

ESNAMESPACE="jsc-ns"
ESINSTANCE="jsc-elasticsearch"
KBINSTANCE="jsc-kibana"
ESPASS=""

prepare_es_config() {
    # Create the necessary ElasticSearch components configuration files
    kubectl create -f 01-crds.yaml
    kubectl apply -f 02-operator.yaml
}

create_es_cluster() {
    # Create the ElasticSearch cluster
    kubectl apply -f 03-deployment.yaml
}

create_kibana_instance() {
    # Create Kibana instance
    kubectl apply -f 04-kibana.yaml
}

get_es_password() {
    # Get the ElasticSearch password from the Kubernetes secret
    ESPASS=$(kubectl get -n ${ESNAMESPACE} secret ${ESINSTANCE}-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
}

connect_es() {
    get_es_password
    echo "https://elastic:${ESPASS}@localhost:9200"
    # Port forward to ElasticSearch 
    kubectl port-forward -n ${ESNAMESPACE} service/${ESINSTANCE}-es-http 9200
}

connect_kb() {
    get_es_password
    echo "URL: https://localhost:5601"
    echo "Password: ${ESPASS}"
    kubectl port-forward -n ${ESNAMESPACE} service/${KBINSTANCE}-kb-http 5601
}

case "$1" in
    setup)
        prepare_es_config
        ;;
    create_es)
        create_es_cluster
        ;;
    es)
        connect_es
        ;;
    create_kb)
        create_kibana_instance
        ;;
    kb)
        connect_kb
        ;;
    *)
        echo "Usage: $0 {setup|create_es|es|create_kb|kb}"  
        exit 1
        ;;       
esac