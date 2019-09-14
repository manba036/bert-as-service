#!/bin/bash
JUPYTER_PORT=$1
if [ -z "${JUPYTER_PORT}" ]; then
  JUPYTER_PORT=8888
fi
echo "JUPYTER_PORT = ${JUPYTER_PORT}"

MODEL_NAME=bert-wiki-ja
CKPT_NAME=model.ckpt-1400000
CONFIG_NAME=bert-wiki-ja_config.json
NUM_WORKER=1

PROJECT_NAME=$(basename `pwd`)
CONTAINER_NAME=${PROJECT_NAME}_jupyter
MODEL_DIR=`pwd`/model
LOGS_DIR=`pwd`/logs
TMP_DIR=`pwd`/tmp
NOTEBOOK_DIR=`pwd`/notebook
PATH_MODEL=${MODEL_DIR}/${MODEL_NAME}

mkdir -p ${PATH_MODEL}
sudo rm -Rf ${LOGS_DIR}
sudo rm -Rf ${TMP_DIR}
mkdir -p ${LOGS_DIR}
mkdir -p ${TMP_DIR}

if [ ! -e "${PATH_MODEL}/graph.pbtxt" ]; then
  wget "https://drive.google.com/uc?export=download&id=11V3dT_xJUXsZRuDK1kXiXJRBSEHGl3In" -O ${PATH_MODEL}/graph.pbtxt
fi

if [ ! -e "${PATH_MODEL}/model.ckpt-1400000.data-00000-of-00001" ]; then
  curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=1F4b_u-5zzqabA6OfLxDkLh0lzqVIEZuN" > /dev/null
  CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"
  curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${CODE}&id=1F4b_u-5zzqabA6OfLxDkLh0lzqVIEZuN" -o ${PATH_MODEL}/model.ckpt-1400000.data-00000-of-00001
fi

if [ ! -e "${PATH_MODEL}/model.ckpt-1400000.index" ]; then
  wget "https://drive.google.com/uc?export=download&id=1LB00MDQJjb-xLmgBMhdQE3wKDOLjgum-" -O ${PATH_MODEL}/model.ckpt-1400000.index
fi

if [ ! -e "${PATH_MODEL}/model.ckpt-1400000.meta" ]; then
  wget "https://drive.google.com/uc?export=download&id=1V9TIUn5wc-mB_wabYiz9ikvLsscONOKB" -O ${PATH_MODEL}/model.ckpt-1400000.meta
fi

if [ ! -e "${PATH_MODEL}/wiki-ja.model" ]; then
  wget "https://drive.google.com/uc?export=download&id=1jjZmgSo8C9xMIos8cUMhqJfNbyyqR0MY" -O ${PATH_MODEL}/wiki-ja.model
fi

if [ ! -e "${PATH_MODEL}/wiki-ja.vocab" ]; then
  wget "https://drive.google.com/uc?export=download&id=1uzPpW38LcS4YS431GgdG0Hsj4gNgE5X1" -O ${PATH_MODEL}/wiki-ja.vocab
fi

if [ ! -e "${PATH_MODEL}/${CONFIG_NAME}" ]; then
  cp ${CONFIG_NAME} ${PATH_MODEL}
fi

docker build \
  -t ${CONTAINER_NAME} \
  --build-arg JUPYTER_PORT=${JUPYTER_PORT} \
  -f ./docker/Dockerfile.jupyter \
  .

docker run \
  --rm -it \
  --name=${CONTAINER_NAME} \
  -p 5555:5555 \
  -p 5556:5556 \
  -p 6006:6006 \
  -p ${JUPYTER_PORT}:${JUPYTER_PORT} \
  -v ${PATH_MODEL}:/app/model \
  -v ${LOGS_DIR}:/app/logs \
  -v ${TMP_DIR}:/app/tmp \
  -v ${NOTEBOOK_DIR}:/app/notebook \
  ${CONTAINER_NAME}
