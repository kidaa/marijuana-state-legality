import json

import numpy as np
import matplotlib.pyplot as plt
import graphics as artist

from pprint import pprint
from matplotlib import rcParams

rcParams['text.usetext'] = True

READ = 'rU'
data = json.load(open('./data/word-occurences-by-category.json',READ))

def jaccard(one,two):
	return len(set(one) & set(two))/float(len(one) + len(two))

similarities = [[jaccard(first_category,second_category) for first_category in data] for second_category in data]

