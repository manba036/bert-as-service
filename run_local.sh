#!/bin/sh

MODEL_NAME=bert-wiki-ja
CKPT_NAME=model.ckpt-1400000
CONFIG_NAME=bert-wiki-ja_config.json
NUM_WORKER=1

MODEL_DIR=`pwd`/model
LOGS_DIR=`pwd`/logs
TMP_DIR=`pwd`/tmp
PATH_MODEL=${MODEL_DIR}/${MODEL_NAME}

echo "MODEL = ${PATH_MODEL}"

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

cd server
sudo python3 setup.py install
cd ..

cd client
sudo python3 setup.py install
cd ..

bert-serving-start -model_dir ${PATH_MODEL} -ckpt_name ${CKPT_NAME} -config_name ${CONFIG_NAME} -graph_tmp_dir ${TMP_DIR} -cpu -max_seq_len=NONE -show_tokens_to_client -num_worker=${NUM_WORKER}