#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bert_serving.client import BertClient

TEXT_LIST = [
    'First do it',
    'then do it right',
    'then do it better'
    ]

bc = BertClient()
result = bc.encode(TEXT_LIST)

print(TEXT_LIST)
print(result)
print(result.shape)