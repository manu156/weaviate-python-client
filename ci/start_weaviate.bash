#!/bin/bash

echo "Download the Weaviate configuration file"
curl -O https://raw.githubusercontent.com/semi-technologies/weaviate/$WEAVIATE_RELEASE_VERSION/docker-compose/runtime/en/config.yaml
echo "Download the Weaviate docker-compose file"
curl -O https://raw.githubusercontent.com/semi-technologies/weaviate/$WEAVIATE_RELEASE_VERSION/docker-compose/runtime/en/docker-compose.yml
echo "Run Docker compose"
nohup docker-compose up &

echo "Wait until weaviate is up"

i="0"
curl localhost:8080/v1/meta
while [ $? -ne 0 ]; do
  i=$[$i+1]
  echo "Sleep $i"
  sleep 1
  if [ $i -gt 120 ]; then
    echo "Weaviate did not start in time"
    exit 1
  fi
  curl localhost:8080/v1/meta
done
echo "Weaviate is up and running"
