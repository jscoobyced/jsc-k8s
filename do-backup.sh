#!/bin/bash

if [ $# -eq 0 ];
then
    echo "You must provide a pod name."
    exit -1
fi

POD=$(echo ${1} | tr -d . | tr . /)

echo "Starting backup for ${POD}"

PODNAME=$(kubectl -n jsc-ns get pods -l app=${POD},tier=frontend --output jsonpath='{.items[0].metadata.name}')

echo "Pod name: ${PODNAME}."

echo "Updating backup script."
kubectl -n jsc-ns cp backup.sh ${PODNAME}:/usr/local/bin/ -c ${POD}

echo "Running backup."
kubectl exec --stdin --tty --namespace jsc-ns ${PODNAME} -- /usr/local/bin/backup.sh ${POD} | tee ${POD}.log

FULLBCKFILE=$(cat ${POD}.log | grep "Full" | cut -d":" -f2 | tr -d ". \r\n" | sed 's/tgz/\.tgz/')
REMOTEFULLBCKFILE="${PODNAME}:/tmp/${FULLBCKFILE}"

echo "Remote backup file is on: ${REMOTEFULLBCKFILE}."
kubectl -n jsc-ns cp ${PODNAME}:/tmp/${FULLBCKFILE} /tmp/${FULLBCKFILE} -c ${POD}