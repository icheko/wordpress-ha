#!/bin/bash -e
#
# usage: ./build.sh values.yaml
#
env="${1%.*}"

mkdir -p build/${env}
helm template --output-dir build/${env} -f $1 .