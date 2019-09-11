#!/bin/bash

MODEL_NAME=uncased_L-12_H-768_A-12
NUM_WORKER=1

MODEL_DIR=`pwd`/model
PATH_MODEL=${MODEL_DIR}/${MODEL_NAME}

echo "MODEL = ${PATH_MODEL}"

mkdir -p ${MODEL_DIR}
sudo rm -Rf logs
sudo rm -Rf tmp
mkdir -p logs
mkdir -p tmp

if [ ! -e "${PATH_MODEL}" ]; then
  wget "https://storage.googleapis.com/bert_models/2018_10_18/${MODEL_NAME}.zip" \
  && unzip ${MODEL_NAME}.zip -d ${MODEL_DIR} \
  && rm -f ${MODEL_NAME}.zip
fi

cd server
sudo python3 setup.py install
cd ..

bert-serving-start -model_dir ${PATH_MODEL} -graph_tmp_dir ./tmp -num_worker=${NUM_WORKER}