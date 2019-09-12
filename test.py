#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
sys.path.append("./server/bert_serving/server/bert")


import numpy as np
from bert_serving.client import BertClient
import tokenization_sentencepiece as tokenization


TEXT_LIST = [
    'First do it',
    'then do it right',
    'then do it better',
    'すべての人間は、生れながらにして自由であり、かつ、尊厳と権利とについて平等である。',
    '人間は、理性と良心とを授けられており、互いに同胞の精神をもって行動しなければならない。',
    '「富士〜」で有名な動物園は？',
    '「富士サファリパーク」です。',
    ]

tokenizer = tokenization.FullTokenizer(
    model_file='./model/bert-wiki-ja/wiki-ja.model',
    vocab_file='./model/bert-wiki-ja/wiki-ja.vocab',
    do_lower_case=True
    )

bc = BertClient()

for text in TEXT_LIST:
    tokens = tokenizer.tokenize(text)
    result = bc.encode([text])
    print('########################################')
    print('text        :', text)
    print('tokens      :', tokens)
    print('len(tokens) :', len(tokens))
    print('shape       :', result.shape)
    print('norm        :', np.linalg.norm(result[0]))
    print('embeddings  :', '[', result[0][0], result[0][1], '...', result[0][-2], result[0][-1], ']')