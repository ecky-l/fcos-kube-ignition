#!/usr/bin/env bash

errorExit() {
    for s in "$@"; do
        echo "$s"
    done
    exit 1
}

test -z "$@" && errorExit "Usage: ./build.sh <name> [VARIABLE1_OVERWRITE=value ...]." \
                          "   <name> - A name for which the ./env-<name> file exists with variables like in env.sample" \
                          "            It will result in a corresponding <name>.ign file"
TYPE=$1
shift

. ./env-"${TYPE}" >/dev/null 2>&1 || errorExit "./env-${TYPE}: No such file. Copy ./env.sample to ./env-${TYPE} and edit it to your needs"

for a in "$@"; do
    export $a
done

if test -f ./network-config.yaml; then
    export FCOS_NETWORK_CONFIG="$(cat network-config.yaml | envsubst)"
else
    echo "[W] network-config.yaml not found. No static network configuration will be performed."
    echo "[W] If that is not your intention, copy ./network-config-sample.yaml to ./network-config.yaml and edit it to your needs."
fi


echo "Building ${TYPE}.ign ..."
RUN_CMD=podman
command -v ${RUN_CMD} 2 > /dev/null || RUN_CMD=docker

cat kube.yaml | envsubst | ${RUN_CMD} run -i --rm quay.io/coreos/fcct:release --strict > ${TYPE}.ign
${RUN_CMD} run --rm -i quay.io/coreos/ignition-validate - < ${TYPE}.ign

echo "Done. You can now expose ${TYPE}.ign for download (consider 'python -m http.server') or use it otherwise to bootstrap a Fedora CoreOS instance"

# run a webserver to serve the thing
#python -m http.server

