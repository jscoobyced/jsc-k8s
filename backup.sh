#!/bin/bash

BCKNAME=$(echo ${1} | tr -d . | tr . / | tr -d " ")
BCKFILE="${BCKNAME}"
rm /tmp/${BCKFILE}*

pushd /var/www/
VERSION=$(date '+%Y%m%d-%H%M%S')
FULLBCKFILE="${BCKFILE}-${VERSION}.tgz"
tar -zcf "/tmp/${FULLBCKFILE}" html
popd

echo "Full backup is: ${FULLBCKFILE}."