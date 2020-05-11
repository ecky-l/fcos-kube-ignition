#!/usr/bin/env bash

errorExit() {
    echo "$1"
    exit 1
}

. ./env || errorExit "env file not found. Copy from env.sample and modify to your needs"

IGNITION=kube-master

RUN_CMD=podman
command -v ${RUN_CMD} 2 > /dev/null || RUN_CMD=docker

cat ${IGNITION}.yaml | envsubst | ${RUN_CMD} run -i --rm quay.io/coreos/fcct:release --strict > ${IGNITION}.ign
${RUN_CMD} run --rm -i quay.io/coreos/ignition-validate - < ${IGNITION}.ign

# run a webserver to serve the thing
#python -m http.server

