##########################################
### Customer Segmentation Case Study
#     used for clustering 
##########################################

# Objective: identify groups of customers by their characteristics to better serve their needs or get more customers
# In this example, we do it with e-mail marketing

# delete everything
rm(list=ls()) 

library(readxl)

# We have two data sets (two sheets): 
# First one contains both information on marketing newsletters/e-mail campaigns (e-mail offers sent) 
# Second one contains transaction level data from customers (which offer customers responded to and what they bought)

offers <- read_excel("WineKMC.xlsx", sheet = 1)
colnames(offers) <- c("offer_id", "campaign", "varietal", "min_qty", "discount", "origin", "past_peak")

head(offers)
# The offers sheet includes data on the basic attributes of a series of “offers” (or deals) the wine distributor 
# crafted and marketed to customers via email over the course of one year. 
# For instance, the distributor launched deal 1 on January offering to buy 72 units (or more) of a new (not “past peak”) Malbec varietal at a 56% discount

# there are 32 different offers 

library(ggplot2)

ggplot(offers, aes(campaign, discount)) +   
  geom_bar(aes(fill = past_peak), position = "dodge", stat="identity")

ggplot(offers, aes(campaign, discount)) +   
  geom_bar(aes(fill = origin), position = "dodge", stat="identity")

ggplot(offers, aes(x=as.factor(min_qty), y=discount)) +
  geom_boxplot(fill="blue") + xlab("min qty")

# there are 100 different customers, 324 transactions (purchases)
transactions <- read_excel("WineKMC.xlsx", sheet = 2)
colnames(transactions) <- c("customer_name", "offer_id")
transactions$n <- 1

head(transactions)

# The idea now is to create a data frame containing a 0/1 indicator for each customer 
# (whether or not they responded to each of the 32 offers)

library(dplyr)     
library(tidyr)  

# join the offers and transactions table for each customer
left_join(offers, transactions, by="offer_id") %>% 
  # get the number of times each customer responded to a given offer
  count(customer_name, offer_id, wt=n) %>%
  # change it from long to wide
  spread(offer_id, nn) %>%
  # and fill in the NAs that get generated as a result
  mutate_each(funs(ifelse(is.na(.), 0, .))) -> dat

# this is our data matrix X
dat
# rows represents costumers and columns are different wine brands/types

# Decisions to make:
#  are the 32 offers relevant?
#  are the 100 customers relevant?
#  what is the most convenient distance/metric between customers?
#  which clustering tool seems more reliable?
#  how many segments?

# How many segments?
# Let's try first kmeans with 5
fit <- kmeans(dat[,-1], centers=5, nstart=20)  # first column contains names
fit
table(fit$cluster)

groups = fit$cluster
barplot(table(groups), col="blue")
   
# visualization
library(cluster)

# 2D representation of the segments:
clusplot(dat[,-1], groups, color=TRUE, shade=TRUE,
         labels=2, lines=0, main= 'Customer segments')

# the same using ggplot
library(ggplot2)   
library(ggfortify) 

pca <- prcomp(dat[,-1])
pca_dat <- mutate(fortify(pca), col=groups)
ggplot(pca_dat) +
  geom_point(aes(x=PC1, y=PC2, fill=factor(col)), size=3, shape=21) +
  scale_fill_discrete(name="Cluster", h.start=100) + theme_bw(base_family="Helvetica")

autoplot(fit, data=dat[,-1], frame=TRUE, frame.type='norm')

# Silhouette plot
diss <- daisy(dat[,-1], metric="gower")  
plot(silhouette(groups,diss), main="")

# 5 clusters is too much?

# Screeplot
wss <- (nrow(dat)-1)*sum(apply(dat[,-1],2,var))
for (i in 2:15) wss[i] <- sum(kmeans(dat[,-1],
                                     centers=i,nstart=20)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# not clear

# interpreting clusters

groups

transactions %>% 
  left_join(data_frame(customer_name=dat$customer_name, 
                       cluster=groups)) %>% 
  left_join(offers) -> customer_clusters

customer_clusters # here we can see transactions with cluster joined

# Take a given cluster and compare it to the remaining customers

# For instance, which offers were purchased by members of cluster 1?
# Which offers were not purchased?

# Let's focus on varietal
id.cluster = 1
customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  count(is_c, varietal) -> varietal_c

varietal_c
# any difference?

# Let's focus on origin
customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  count(is_c, origin) -> origin_c

origin_c
# any difference?

# Let's focus on origin and campaign

customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  count(is_c, origin, campaign) -> originANDcampaign_c

originANDcampaign_c
# any difference? more difficult to see...

# We can also segment out numerical features 
# For instance, how the mean of the min_qty field breaks out between a given cluster and the rest? 
# Some clusters like to by in bulk
customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  group_by(is_c) %>% 
  summarise_each(funs(mean), min_qty, discount) -> mean_c

mean_c

# PAM clustering, based on medioids
fit.pam <- pam(dat[,-1], k=2) # 2 cluster solution
fit.pam
fit.pam$clustering

par(mfrow=c(1,3))
plot(pam(dat[,-1], k=3), which=2)
plot(pam(dat[,-1], k=4), which=2)
plot(pam(dat[,-1], k=5), which=2)

par(mfrow=c(2,1))
plot(pam(dat[,-1], k=5, metric = "euclidean"), which=1, lines=0)
plot(pam(dat[,-1], k=5, metric = "manhattan"), which=1 ,lines=0)

plot(silhouette(pam(dat[,-1], k=5, metric = "manhattan"),diss), main="")


# Hierarchical clustering

# Which distance?
# Let's try Gower dissimilarity
D = daisy(dat[,-1], metric='gower')

# Now let's try Ward’s hierarchical clustering:
H.fit <- hclust(D, method="ward.D")
plot(H.fit) 

# make 3 segments
seg=3
groups <- cutree(H.fit, k=seg) # cut tree into 4 clusters
rect.hclust(H.fit, k=seg, border="red") 

# 2D representation of the segments:
clusplot(dat[,-1], groups, color=TRUE, shade=TRUE,
         labels=2, lines=0, main= 'Customer segments')


# interpreting clusters

groups

transactions %>% 
  left_join(data_frame(customer_name=dat$customer_name, 
                       cluster=groups)) %>% 
  left_join(offers) -> customer_clusters

customer_clusters # here we can see transactions with cluster joined

# Take a given cluster and compare it to the remaining customers

# For instance, which offers were purchased by members of cluster 1?
# Which offers were not purchased?

# Let's focus on varietal group 2
id.cluster = 2
customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  count(is_c, varietal) -> varietal_c

varietal_c
# any difference?

# Let's focus on origin
customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  count(is_c, origin) -> origin_c

origin_c
# any difference?

# We can also segment out numerical features 
# For instance, how the mean of the min_qty field breaks out between a given cluster and the rest? 
# Some clusters like to by in bulk
customer_clusters %>% 
  mutate(is_c=(cluster==id.cluster)) %>% 
  group_by(is_c) %>% 
  summarise_each(funs(mean), min_qty, discount) -> mean_c

mean_c

# Easy???

# which is the proper distance? (let's say 3 choices)
# which is the proper linkage? (let's say 3 choices)
# which are the proper attributes/features? (10 choices)
# number of groups? (4 choices)
# most convenient models? (3 choices)
# standardize? (2 choices)
# outliers? (2 choices)

# possible choices around 4000
# in a bigger problem, choices = 10^6
