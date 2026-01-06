#!/bin/bash

K_ACTION="$1"
K_SECRET_NAME="$2"
K_NAMESPACE="$3"
K_CLUSTERNAME="$4"

kubectl config use-context default

create_context() {

    echo "Creating service account ${K_SECRET_NAME} in namespace ${K_NAMESPACE} and cluster ${K_CLUSTERNAME}"
    kubectl create sa ${K_SECRET_NAME} --namespace ${K_NAMESPACE} --cluster ${K_CLUSTERNAME}

    echo "Creating secret for service account ${K_SECRET_NAME} in namespace ${K_NAMESPACE}"
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
    name: ${K_SECRET_NAME}-secret
    namespace: ${K_NAMESPACE}
    annotations:
        kubernetes.io/service-account.name: ${K_SECRET_NAME}
type: kubernetes.io/service-account-token
EOF

    UTOK=$(kubectl get secret --namespace ${K_NAMESPACE} ${K_SECRET_NAME}-secret -o jsonpath='{.data.token}' | base64 -d)

    echo "Setting up credentials for service account ${K_SECRET_NAME}"
    kubectl config set-credentials ${K_SECRET_NAME} --token=${UTOK}

    echo "Creating cluster role binding for service account ${K_SECRET_NAME}"
    kubectl create clusterrolebinding ${K_SECRET_NAME} --namespace ${K_NAMESPACE} --clusterrole cluster-admin --serviceaccount ${K_NAMESPACE}:${K_SECRET_NAME}

    echo "Setting up context for service account ${K_SECRET_NAME}"
    kubectl config set-context ${K_SECRET_NAME} --namespace ${K_NAMESPACE} --cluster ${K_CLUSTERNAME} --user ${K_SECRET_NAME}

    echo "Using context for service account ${K_SECRET_NAME}"
    kubectl config use-context ${K_SECRET_NAME}

    kubectl get pods

    echo "Service account created successfully."
}

delete_context() {
    echo "Deleting cluster role binding for service account ${K_SECRET_NAME}"
    kubectl delete clusterrolebinding ${K_SECRET_NAME}

    echo "Deleting user for service account ${K_SECRET_NAME}"
    kubectl config delete-user ${K_SECRET_NAME}

    echo "Deleting context for service account ${K_SECRET_NAME}"
    kubectl config delete-context ${K_SECRET_NAME}

    echo "Deleting service account ${K_SECRET_NAME}"
    kubectl delete serviceaccount ${K_SECRET_NAME} --namespace ${K_NAMESPACE}

    echo "Service account deleted successfully."
}

case "${K_ACTION}" in
    create)
       create_context
        ;;
    delete)
        delete_context
        ;;
    *)
        echo "Invalid action. Please specify 'create' or 'delete'."
        exit 1
        ;;
esac