#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
from bert_serving.client import BertClient


TEXT_LIST = [
    'First do it',
    'then do it right',
    'then do it better',
    'すべての人間は、生れながらにして自由であり、かつ、尊厳と権利とについて平等である。',
    '人間は、理性と良心とを授けられており、互いに同胞の精神をもって行動しなければならない。',
    '「富士〜」で有名な動物園は？',
    '「富士サファリパーク」です。',
    ]

bc = BertClient()

for text in TEXT_LIST:
    result = bc.encode([text], show_tokens=True)
    print('########################################')
    print('text        :', text)
    print('tokens      :', result[1][0])
    print('len(tokens) :', len(result[1][0]))
    print('shape       :', result[0].shape)
    print('norm        :', np.linalg.norm(result[0][0]))
    print('embeddings  :', '[', result[0][0][0], result[0][0][1], '...', result[0][0][-2], result[0][0][-1], ']')
    print()