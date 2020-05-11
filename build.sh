#!/usr/bin/env bash

errorExit() {
    echo "$1"
    exit 1
}

TYPE=$1
shift

. ./env-"${TYPE}" || errorExit "env-${TYPE} file not found. Copy from env.sample and modify to your needs"

for a in "$@"; do
    export $a
done

RUN_CMD=podman
command -v ${RUN_CMD} 2 > /dev/null || RUN_CMD=docker

cat kube.yaml | envsubst | ${RUN_CMD} run -i --rm quay.io/coreos/fcct:release --strict > ${TYPE}.ign
${RUN_CMD} run --rm -i quay.io/coreos/ignition-validate - < ${TYPE}.ign

# run a webserver to serve the thing
#python -m http.server

