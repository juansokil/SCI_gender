# -*- coding: utf-8 -*-
"""
Created on Wed Oct  3 10:57:11 2018

@author: Observatorio
"""



import pandas as pd
import numpy as np
import nltk
from pprint import pprint
from sklearn.utils import shuffle



gender = pd.read_csv("C:/Users/observatorio/Documents/gender_article.txt", sep='\t', encoding='UTF-8')
address = pd.read_csv("C:/Users/observatorio/Documents/author_address.txt", sep='\t', encoding='UTF-8')




###Levanta datos
base_total = pd.read_csv("../resultados/tabla_total.csv", sep=',', encoding='latin1')
base_total=base_total.set_index('Word')

base_total_transpose=base_total.T
from sklearn.metrics.pairwise import cosine_similarity
import networkx as nx

array=cosine_similarity(base_total_transpose[0:104],base_total_transpose[0:104])

dd = pd.DataFrame(array)
dd.to_csv("../resultados/relaciones.csv")

import matplotlib.pyplot as plt
import seaborn as sns; sns.set()


array = pd.read_csv('./relaciones.csv', sep=',', encoding='latin1')
###Elimino la primer columna
array= array.drop(array.columns[[0]], axis=1)
array=np.array(array)

# Get the lower triangle without the diagonal 
corr_mat = np.tril(array, k=-1)

corr_mat[corr_mat < 0.05] = 0
#plt.figure(figsize=(30,30))
cmap = sns.cm.rocket_r
ax = sns.heatmap(corr_mat, vmin=0, vmax=1,cmap = cmap, square=True)
plt.show()





G = nx.DiGraph(array)
nx.transitivity(G)

G.edges.data()


pos2 =nx.fruchterman_reingold_layout(G, iterations=5, weight='weight', scale=10)
edges = G.edges()
weights = [G[u][v]['weight'] for u,v in edges]


nx.draw(G, pos2, edges=edges, width=weights, with_labels = True)
nx.draw_spring(G, width=weights, with_labels = True, node_size=100)

nx.average_shortest_path_length(G)  
nx.average_degree_connectivity(G)


nx.write_gml(G, "./grafo.gml")



a = np.reshape(np.random.random_integers(0,1,size=100),(10,10))
D = nx.DiGraph(bagofwords)
nx.draw(D)




from sklearn.cluster import KMeans
from sklearn.cluster import AgglomerativeClustering


kmeans = KMeans(n_clusters=4, random_state=0).fit(array)



array2=array.tolist()





ward = AgglomerativeClustering(n_clusters=6, linkage='ward').fit(array)
from scipy.cluster.hierarchy import dendrogram, linkage
dendrogram(ward)



data = [[0., 0.], [0.1, -0.1], [1., 1.], [1.1, 1.1]]

Z = linkage(array2, 'ward', metric='euclidean')
plt.figure(figsize=(10,10))
dendrogram(Z, leaf_rotation=90, leaf_font_size=6,show_contracted=True)  
plt.show()

from scipy.cluster import hierarchy
hierarchy.to_tree(Z)
rootnode, nodelist = hierarchy.to_tree(Z, rd=True)

rootnode