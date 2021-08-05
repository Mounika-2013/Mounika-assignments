#!/usr/bin/env python 
import sys
from nltk.tokenize import wordpunct_tokenize
from collections import Counter

with open('cats_txt.txt', 'r') as cats:
    #cats.lower()
    cats_tokens = wordpunct_tokenize(cats)
    cats_freq = Counter(cats_tokens)
    print(cats_freq)
