#!/bin/bash

image="$1"

docker build -t ${image} .

docker push ${image}
