###################################
##### CLUSTERING METHODS          #
###################################

rm(list = ls()) 

### Partition methods

install.packages("cluster")
library(cluster)
library(ggplot2)
library(ggfortify)
library(factoextra)

# easy data set, just for slides
ruspini <- ruspini[sample(1:nrow(ruspini)),]
 
ggplot(ruspini, aes(x=x, y=y)) + geom_point(size = 4) +
  theme(text = element_text(size=16))


# Prepare Data
Ruspini <- scale(ruspini) # standardize variables
# This may prevent one attribute with a large range to dominate 
# the others for the distance calculation

ggplot(Ruspini, aes(x=x, y=y)) + geom_point(size = 4) +
  theme(text = element_text(size=16))


### K-Means Cluster Analysis-------------------------------------------------------------------------------------

# Assume first k=2 clusters and Euclidean distances 
# Run the algorithm 20 times with random initialized centroids 
# The best result is returned
fit.kmeans <- kmeans(Ruspini, centers=2, nstart=20) # 2 cluster solution
fit.kmeans

# Check:
# fviz_cluster(fit.kmeans, data = Ruspini)

Ruspini <- as.data.frame(Ruspini)
Ruspini$cluster <- factor(fit.kmeans$cluster)
centers <- as.data.frame(fit.kmeans$centers)


autoplot(fit.kmeans, Ruspini, size = 3) + theme(text = element_text(size=16))



ggplot(Ruspini, aes(x=x, y=y, color=cluster )) + 
  geom_point(size = 3) + 
  geom_point(data=centers, aes(x=x,y=y, color='Center')) + # this adds the centroids
  theme(text = element_text(size=16)) + 
  stat_ellipse() # this adds the ellipsoids



# Check and compare with clusplot --------------|||

Ruspini <- scale(ruspini)
# plot the points using the first principal components (useful in dimension>2)
clusplot(Ruspini, fit.kmeans$cluster,color=TRUE,shade=TRUE,lines=0)

# Silhouette plot
# Compute all the pairwise dissimilarities (distances) between observations in the data set
diss <- daisy(Ruspini)  # by default D_{ij} = euclidean distance
d2   <- diss^2  # to work better with D_{ij}^2

# Plot the silhouette given the cluster information and desired distance
plot(silhouette(fit.kmeans$cluster,d2), main="")

# Check:
# fviz_silhouette(silhouette(fit.kmeans$cluster,d2), label = T, print.summary = T)

# Assume now k=5 clusters and Euclidean distances
fit.kmeans <- kmeans(Ruspini, centers=5, nstart=20) # 5 cluster solution
fit.kmeans

Ruspini <- as.data.frame(Ruspini)
Ruspini$cluster <- factor(fit.kmeans$cluster)
centers <- as.data.frame(fit.kmeans$centers)


autoplot(fit.kmeans, Ruspini, size = 3) + theme(text = element_text(size=16))


ggplot(Ruspini, aes(x=x, y=y, color=cluster )) + 
  geom_point(size = 3) + 
  geom_point(data=centers, aes(x=x,y=y, color='Center')) + # this adds the centroids
  theme(text = element_text(size=16)) + 
  stat_ellipse() # this adds the ellipsoids

# Check and compare with clusplot --------------|||

Ruspini <- scale(ruspini)

# plot the points using the first principal components (useful in dimension>2)
clusplot(Ruspini, fit.kmeans$cluster,color=TRUE,shade=TRUE,lines=0)

# Silhouette plot
diss <- daisy(Ruspini)  # Compute all the pairwise dissimilarities (distances) between observations in the data set
d2   <- diss^2  # to work better with D_{ij}^2

plot(silhouette(fit.kmeans$cluster,d2), main="")


# Silhouette plot for k=4
fit.kmeans <- kmeans(Ruspini, centers=4, nstart=20) # 5 cluster solution

plot(silhouette(fit.kmeans$cluster,d2), main="")

# Determine number of clusters, using a screeplot
wss <- (nrow(Ruspini)-1)*sum(apply(Ruspini,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(Ruspini,
                                     centers=i,nstart=20)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")


# PAM clustering, based on medioids------------------------------------------------------------------------------
fit.pam <- pam(Ruspini, k=2) # 2 cluster solution
fit.pam
fit.pam$clustering

par(mfrow=c(1,3))
plot(pam(Ruspini, k=3), which=2)
plot(pam(Ruspini, k=4), which=2)
plot(pam(Ruspini, k=5), which=2)

par(mfrow=c(2,1))
plot(pam(Ruspini, k=3, metric = "euclidean"), which=1, lines=0)
plot(pam(Ruspini, k=3, metric = "manhattan"), which=1 ,lines=0)


### Model-based clustering--------------------------------------------------------------------------------------

install.packages("mclust")
library(mclust)

# Mclust uses BIC to find the number of clusters

fit.m <- Mclust(ruspini)
summary(fit.m)
# under this criterion, the optimal number of clusters is 5 

plot(fit.m, what = "classification", main="")

plot(fit.m, what = "BIC", main="")
# By default, the models considered are:
# "EII": spherical, equal volume 
# "VII": spherical, unequal volume 
# "EEI": diagonal, equal volume and shape
# "VEI": diagonal, varying volume, equal shape
# "EVI": diagonal, equal volume, varying shape 
# "VVI": diagonal, varying volume and shape 
# "EEE": ellipsoidal, equal volume, shape, and orientation 
# "EEV": ellipsoidal, equal volume and equal shape
# "VEV": ellipsoidal, equal shape 
# "VVV": ellipsoidal, varying volume, shape, and orientation  

# Rerun with a fixed number of 4 clusters
fit.m <- Mclust(Ruspini, G=4)
summary(fit.m)
plot(fit.m, what = "classification")


### Hierarchical Methods------------------------------------------------------------------------------------

ruspini <- ruspini[sample(1:nrow(ruspini)),]
d <- dist(ruspini, method = "euclidean") # distance matrix using euclidean distance
# Note we need distances for observations and linkages for the cluster joining
fit.h <- hclust(d, method="complete") # cluster using complete link
plot(fit.h) # display dendogram

# seems 4 clusters

# the same but with red borders around k clusters
# I.e. cut the dendogram for 3 clusters
plot(fit.h, main="")
rect.hclust(fit.h, k=3, border="red")

plot(fit.h, main="")
rect.hclust(fit.h, k=4, border="red")

# Idem for 5 clusters
plot(fit.h, main="")
rect.hclust(fit.h, k=5, border="red")

# change the linkage
par(mfrow=c(2,3))
fit.h <- hclust(d, method="single") 

# In this case, instead of plotting the dendogram, plot the clusters
# First, we need to indicate how many clusters to consider
groups.h <- cutree(fit.h, k=5) 
plot(ruspini, col=groups.h, main="euclidean+single")

# Now with complete linkage
fit.h <- hclust(d, method="complete") 
groups.h <- cutree(fit.h, k=5) 
plot(ruspini, col=groups.h, main="euclidean+complete")

# Now with average linkage
fit.h <- hclust(d, method="average") 
groups.h <- cutree(fit.h, k=5) 
plot(ruspini, col=groups.h, main="euclidean+average")

# Now changing the distance
d <- dist(ruspini, method = "manhattan") 
fit.h <- hclust(d, method="single") 
groups.h <- cutree(fit.h, k=5) 
plot(ruspini, col=groups.h, main="manhattan+single")

fit.h <- hclust(d, method="complete") 
groups.h <- cutree(fit.h, k=5) 
plot(ruspini, col=groups.h, main="manhattan+complete")

fit.h <- hclust(d, method="average") 
groups.h <- cutree(fit.h, k=5) 
plot(ruspini, col=groups.h, main="manhattan+average")
