#!/bin/bash

MODEL_NAME=uncased_L-12_H-768_A-12
NUM_WORKER=1

PROJECT_NAME=$(basename `pwd`)
MODEL_DIR=`pwd`/model
PATH_MODEL=${MODEL_DIR}/${MODEL_NAME}

echo "PATH_MODEL = ${PATH_MODEL}"

mkdir -p ${MODEL_DIR}

if [ ! -e "${PATH_MODEL}" ]; then
  wget "https://storage.googleapis.com/bert_models/2018_10_18/${MODEL_NAME}.zip" \
  && unzip ${MODEL_NAME}.zip -d ${MODEL_DIR} \
  && rm -f ${MODEL_NAME}.zip
fi

docker build -t ${PROJECT_NAME,,} -f ./docker/Dockerfile .
docker run  --rm -it --name=${PROJECT_NAME,,} -p 5555:5555 -p 5556:5556 -v ${PATH_MODEL}:/model -t ${PROJECT_NAME,,} $NUM_WORKER