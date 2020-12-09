#!/usr/bin/env bash

set -ev

SCRIPT_DIR=$(dirname "$0")
GROUP=codelab
COMMIT=latest

DOCKER_CMD=docker
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR
$DOCKER_CMD run --rm -v $HOME/.m2:/root/.m2 -v $CODE_DIR:/usr/src/mymaven -w /usr/src/mymaven  paperinik/rpi-maven install -DskipTests package

cp $CODE_DIR/target/*.jar $CODE_DIR/docker/$(basename $CODE_DIR)

for m in ./docker/*/; do
    REPO=${GROUP}/$(basename $m)
    $DOCKER_CMD build -t ${REPO}:${COMMIT} $CODE_DIR/$m;
done;
