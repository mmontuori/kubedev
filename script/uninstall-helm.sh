#!/bin/bash

if [ "$1" == "" ]; then
    echo "specify the port as CLI argument"
    echo "Usage: $0 <appname> <namespace>"
    exit 1
fi

appname="$1"
namespace="$2"
helmdir="$3"

helm uninstall ${appname} --namespace ${namespace} ${helmdir}