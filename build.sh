#!/usr/bin/env bash

IGNITION=kube-master

RUN_CMD=podman
command -v ${RUN_CMD} 2 > /dev/null || RUN_CMD=docker

${RUN_CMD} run -i --rm quay.io/coreos/fcct:release --pretty --strict < ${IGNITION}.yaml > ${IGNITION}.ign
${RUN_CMD} run --rm -i quay.io/coreos/ignition-validate - < ${IGNITION}.ign

# run a webserver to serve the thing
#python -m http.server

