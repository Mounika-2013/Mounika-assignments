'''Write a python program (not a Jupyter notebook, but a py 
file you run from the command line) that accepts the cats_txt.txt 
file as input and counts the frequency of all words and 
punctuation in that text file, ordered by frequency. 
Make sure to handle capital and lowercase versions of words and 
count them together.'''
import sys
import nltk
from nltk.tokenize import sent_tokenize
from nltk.tokenize import word_tokenize
from collections import Counter
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
from matplotlib import pyplot as plt

with open('cats_txt.txt', 'r') as cats:
    lines = [line.strip() for line in cats]
    words_tokenize = [word.split() for word in lines]

    tokens = [word_tokenize(words) for words in words_tokenize]
    lower_tokens = [l.lower() for l in tokens]
    alpha_words = [t for t in lower_tokens if t.isalpha()]
    
    #Removing stop words
    stop_words = set(nltk.corpus.stopwords.words('english'))
    no_stops = [t for t in alpha_words if t not in stop_words]
    
    lw = WordNetLemmatizer()
    lemmatized =(lw.lemmatizer(t) for t in no_stops)

    punctuations = r['\.\?\,\!']
    counts = Counter(lower_tokens)
