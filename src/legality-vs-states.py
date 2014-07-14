import json

import numpy as np
import matplotlib.pyplot as plt
import graphics as artist

from pprint import pprint
from matplotlib import rcParams

rcParams['text.usetex'] = True

READ = 'rU'
data = json.load(open('./data/marijuana-word-occurences-by-category.json',READ))

def jaccard(one,two):
	print one,two
	return len(set(one) & set(two))/float(len(set(one) | set(two)))

print jaccard([1,2,3],[2,3,4])

categories = ['legal','Medical','decriminalization','Medical-decriminalization','illegal']
similarities = [[jaccard(data[first_category],data[second_category]) for first_category in categories] 
														 for second_category in categories]

np.savetxt('./results/jaccard-similarity-marijuana.tsv',np.array(similarities),fmt ='%.04f', delimiter='\t')

fig = plt.figure()
ax = fig.add_subplot(111)
cax = ax.imshow(similarities,interpolation='nearest',aspect='auto',cmap=plt.cm.binary,
	vmin = 0, vmax=1)
artist.adjust_spines(ax)
ax.set_yticks(range(len(categories)))
ax.set_xticks(range(len(categories)))

ax.set_yticklabels(map(artist.format,categories))
ax.set_xticklabels(map(artist.format,categories), rotation='vertical')
cbar = plt.colorbar(cax)
cbar.set_label(artist.format('Jaccard similarity'))
plt.tight_layout()
plt.savefig('./results/jaccard-similarity-marijuana.png',dpi=300)