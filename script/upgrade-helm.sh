#!/bin/bash

if [ "$1" == "" ]; then
    echo "specify the port as CLI argument"
    echo "Usage: $0 <appname> <namespace> <helm directory>"
    exit 1
fi

appname="$1"
namespace="$2"
helmdir="$3"

helm upgrade ${appname} --namespace ${namespace} ${helmdir}