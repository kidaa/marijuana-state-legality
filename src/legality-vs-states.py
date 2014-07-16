import json, random, itertools

import numpy as np
import matplotlib.pyplot as plt
import graphics as artist

from pprint import pprint
from matplotlib import rcParams
from scipy.stats import percentileofscore
rcParams['text.usetex'] = True

READ = 'rU'
data = json.load(open('../data/marijuana-word-occurences-by-category.json',READ))

def jaccard(one,two):
	return len(set(one) & set(two))/float(len(set(one) | set(two)))

def similarity(data, flatten = True):
	ans = [[jaccard(data[first_category],data[second_category]) for first_category in categories] 
															 for second_category in categories]
	return ans if not flatten else [item for sublist in ans for item in sublist]

categories = ['legal','Medical','decriminalization','Medical-decriminalization','illegal']

bootstrap = True
n_resamples = 20000
sizes = [len(data[category]) for category in categories]
flattened = [item for sublist in data.itervalues() for item in sublist]

distances = [similarity({category:random.sample(flattened,size) 
					for size,category in zip(sizes,categories)},flatten=True)
					for _ in range(n_resamples)]
distances = [item for sublist in distances for item in sublist if item < 1]

reference = {label:sim 
	for label,sim in zip(['%s vs %s'%(one,two) 
		for one,two in itertools.product(categories,categories)],similarity(data)) if sim < 1}

np.savetxt('../results/resampled-distribution.tsv',np.array(distances),fmt='%.04f',delimiter='\t')
fig = plt.figure(figsize=(12,6))
ax = fig.add_subplot(111)
linestyles = ['-','--','-.',':']
ax.hist(distances,color='k')
handles = []
ref = []
for i,category in enumerate(itertools.combinations(categories,2)):
	h = ax.axvline(reference['%s vs %s'%category],color='r',linestyle=linestyles[i%len(linestyles)], 
		linewidth=2, label=artist.format('%s vs %s'%category))
	p_value = percentileofscore(distances,reference['%s vs %s'%category])
	print '%s : %.04f'%('%s vs %s'%category,0.01*(100-p_value))
	handles.append(h)
	ref.append('%s vs %s'%category)
artist.adjust_spines(ax)
ax.set_ylabel(artist.format('Count'))
ax.set_xlabel(artist.format('Jaccard similarity'))
ax.yaxis.grid(which='major',color='w',linestyle='-')
#plt.tight_layout()
plt.figlegend(handles,map(artist.format,ref),'upper right')
plt.show()

visualize = False
if visualize:
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

