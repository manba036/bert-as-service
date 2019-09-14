#!/bin/bash
CKPT_NAME=$1
CONFIG_NAME=$2
NUM_WORKER=$3

MODEL_DIR=${BERT_SERVER_MODEL_DIR}
TMP_DIR=${BERT_SERVER_TMP_DIR}

export ZEROMQ_SOCK_TMP_DIR=${TMP_DIR}

bert-serving-start -model_dir ${MODEL_DIR} -ckpt_name ${CKPT_NAME} -config_name ${CONFIG_NAME} -graph_tmp_dir ${TMP_DIR} -cpu -max_seq_len=NONE -show_tokens_to_client -num_worker=${NUM_WORKER}