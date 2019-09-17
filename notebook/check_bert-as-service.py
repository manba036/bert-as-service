#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
from bert_serving.client import BertClient


TEXT_LIST = [
    '「富士〜」で有名な動物園は？',
    '「富士サファリパーク」です。',
    ]

bc = BertClient()

for text in TEXT_LIST:
    result = bc.encode([text], show_tokens=True)
    embeddings = result[0][0]
    tokens = result[1][0]

    print('########################################')
    print('text        :', text)
    print('tokens      :', tokens)
    print('len(tokens) :', len(tokens))
    print('shape       :', embeddings.shape)
    print('norm        :', np.linalg.norm(embeddings))
    print('embeddings  :', '[', embeddings[0], embeddings[1], '...', embeddings[-2], embeddings[-1], ']')
    print()

bc.close()