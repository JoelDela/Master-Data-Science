# 1. Clustering
Applications:
* Segmentation
* Social NetworkAnalysis
* Outlier detection
* Association Rules

```python
def plot_clustering(data, clusters, centroids):
    
    K_ = len(set(clusters))
    
    plt.figure(figsize=(8,4))
    plt.scatter(data[:,0], data[:,1], c=clusters, cmap="plasma", linewidths=0)

    for k in range(K_):
        plt.scatter(centroids[k,0], centroids[k, 1], s=100, marker='D', color='red')
        
    plt.show()
```

__1.1. K-means__
```python
from sklearn.cluster import KMeans
model = KMeans(n_clusters = 3)
model = model.fit(data)
model.cluster_centers_  # centroids of each cluster
model.labels_           # cluster assigned to each point
    clusters_sk = model.predict(data)
    all(model.labels_ == clusters_sk) == TRUE
model.inertia_          # sse = Sum of squared distances of samples to their closest cluster center.
```

__1.2. Hierarchical clustering__
- `linkage` function computes the distance matrix between the points
  * _Single_ minimum of distances of all points in 2 clusters
  * _Average_ average of distances of all points in 2 clusters
  * _Complete_ maximum of distances of all points in 2 clusters
  * _Ward_ minimize the variance of the clusters being merged
  ![](/images/HierarchicalClusterLinkage.png)
- `dendrogram` function plots the dendrogram using the distances
- `fcluster` function performs a clustering assignment according to different parameters
```python
from scipy.cluster.hierarchy import linkage, dendrogram, fcluster
# Dinstancias
Z = linkage(data, 'ward')
# Plot
plt.figure(figsize=(14, 7))
dendrogram(Z)
plt.show()
```
Cluster Partition
```python
# Option 1
cut_distance = 25
clusters_hc = fcluster(Z, t = cut_distance, criterion='distance')
np.unique(clusters_hc, return_counts = True) # clusters and elements per cluster

# Option 2 if we know the number of clusters
from sklearn.cluster import AgglomerativeClustering
# define the model
cluster = AgglomerativeClustering(n_clusters=3, affinity='euclidean', linkage='average')  
# fit data and predict 
clusters = cluster.fit_predict(data)
```

__1.3. DBScan & OPTICS__

# 2. Dimmensionality Reduction
__2.1. PCA__

__2.2. Matrix Factorization__

__2.3. SVD__

__2.4. NMF__

__2.5. Autoencoders__
