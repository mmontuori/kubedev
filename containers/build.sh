#!/bin/bash

export image="$1"
export directory="$2"

if [ "$directory" == "" ]; then
  export directory="html"
fi

docker build -t ${image} --build-arg ${directory} .

if echo $image | grep "^mmontuori">/dev/null; then
    docker push ${image}
fi
