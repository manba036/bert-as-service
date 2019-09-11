#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bert_serving.client import BertClient

bc = BertClient()
result = bc.encode(['First do it', 'then do it right', 'then do it better'])

print(result)
print(result.shape)