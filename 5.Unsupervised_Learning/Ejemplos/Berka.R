rm(list=ls())
# 0. PACKAGES

# Data Manipulation packages
library(data.table) 
library(dplyr)
library(ggplot2)


# http://lisp.vse.cz/pkdd99/Challenge/

# 1. LOADING DATA

account <- fread('data_berka/account.asc')
str(account)
summary(account)

card <- fread('data_berka/card.asc') 
str(card)
colnames(card)[3] <- 'card_type' # Disambiguation
summary(card)

client <- fread('data_berka/client.asc')
str(client)
summary(client)

disp <- fread('data_berka/disp.asc') ## Exercise
str(disp)
colnames(disp)[4] <- 'disposal_type'


district <- fread('data_berka/district.asc') ## Exercise
str(district)
colnames(district)

colnames(district) <- c('district_id', # Instead of 'AX' names
                        'dist',
                        'region', 
                        'inhabitants',
                        'municipalities_inh_lt_499',
                        'municipalities_inh_500_1999',
                        'municipalities_inh_2000_9999',
                        'municipalities_inh_gt_10000',
                        'cities', 
                        'ratio_urban',
                        'avg_sal',
                        'unemp_rate_ly', 
                        'unemp_rate',
                        'entrepeneur_no',
                        'crimes_ly',
                        'crimes')


loan <- fread('data_berka/loan.asc') 
str(loan)
colnames(loan)[4] <- 'loan_amount' # Disambiguation
colnames(loan)[7] <- 'loan_status'
length(unique(loan$account_id))
length(unique(loan$loan_id)) # Equivalent, only one loan per account. 
#  Possible explanation: The loans are aggregated.


order <- fread('data_berka/order.asc') ## Exercise
str(order)
colnames(order)[5] <- 'order_amount' # Disambiguation
 

trans <- fread('data_berka/trans.asc') ## Exercise
str(trans)
colnames(trans)[6] <- 'trans_amount' # Disambiguation


# 2. JOINING TABLES (REMEMBER THE OBJECTIVE)

# Join account, trans & disp on ac_id as ac_id_join

ac_id_join <- account %>%
  inner_join(trans, by = 'account_id') %>% ## Exercise
  inner_join(disp, by = 'account_id') %>%
  filter(disposal_type == 'OWNER')






ac_id_join_sum <- ac_id_join %>%
  group_by(account_id) %>%
  summarise(trans_sum = sum(trans_amount))

# join ac_id_join_sum & loan on account_id as ac_trans_loan
ac_trans_loan  <- ac_id_join_sum %>% ## Exercise
  left_join(loan, by = 'account_id') 

ac_trans_loan_disp <- ac_trans_loan %>% # Gathering client info
  left_join(disp, by = 'account_id') %>%
  filter(disposal_type == 'OWNER') # One account <--> One Owner

ac_trans_loan_disp_client <- ac_trans_loan_disp %>% # Gathering client info
  left_join(client, by = 'client_id')

# join ac_id_join,district_info,client on district_id as ac_client_district
ac_client_district <- ac_trans_loan_disp_client %>% ## Exercise
  left_join(district, by= 'district_id')

ac_client_district <- ac_client_district %>% 
  select(account_id, birth_number, trans_sum, loan_amount,
         loan_status, dist, avg_sal, unemp_rate, entrepeneur_no)

str(ac_client_district)
summary(ac_client_district)

# 3. DATA MANIPULATION

ac_client_district$birth_number

# the number is in the form YYMMDD for men,
# the number is in the form YYMM+50DD for women,
# where YYMMDD is the date of birth

# the number is in the form YYMMDD for men,
ac_client_district$birth_date <- as.Date(as.character(ac_client_district$birth_number), "%y%m%d")
ac_client_district$birth_date

women <- is.na(ac_client_district$birth_date) # Stores the indices of women <--- TO REMEMBER

# the number is in the form YYMM+50DD for women,
ac_client_district$birth_date[women] <- 
  as.Date(as.character(as.numeric(ac_client_district$birth_number[women]) - 5000),
          "%y%m%d")

ac_client_district$birth_date <- format(ac_client_district$birth_date, "19%y-%m-%d")

ac_client_district$age <- floor(difftime("1999-09-15",ac_client_district$birth_date, units = "weeks")/52)
ac_client_district$age <- as.numeric(ac_client_district$age)

ac_client_district$sex <- 'Male'
ac_client_district$sex[women] <- 'Female'


str(ac_client_district)
summary(ac_client_district)

ac_client_district <- as.data.frame(ac_client_district[,c(1,3:9,11:12)])

summary(ac_client_district)

# 4. EXPLORATORY ANALYSIS

ac_cl_d_num <- ac_client_district[,c(2:3, 6:8, 9)]

boxplot(ac_cl_d_num)

dfmelt<-melt(ac_client_district, measure.vars = c(2:3, 6:8, 9))

ggplot(dfmelt, aes(x = sex, y = value, fill = sex)) +
  geom_jitter(alpha = 0.1) +
  geom_boxplot() + 
  facet_wrap(~variable, scales = 'free') # By Sex

colSums(is.na(ac_client_district)) # Checking NAs

ggplot(ac_client_district, aes(x= age, group = age, y= trans_sum)) + 
  geom_boxplot() +
  scale_y_continuous(limits = c(0, 4e6)) # By Age

ggplot(ac_client_district, aes(x= dist, y= trans_sum)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # By District


## FOCUS ON LOANED CLIENTS
ac_client_district_loaned <- na.omit(ac_client_district,na.action=TRUE)

ac_cl_d_loaned_num <- ac_client_district_loaned[,c(2:3, 6:8, 9)]

boxplot(ac_cl_d_loaned_num)

dfmelt<-melt(ac_client_district_loaned, measure.vars = c(2:3, 6:8, 9))

ggplot(dfmelt, aes(x = sex, y = value, fill = sex)) +
  geom_jitter(alpha = 0.1) +
  geom_boxplot() + 
  facet_wrap(~variable, scales = 'free') # By Sex

# Transfers
ggplot(ac_client_district_loaned, aes(x= age, group = age, y= trans_sum, fill = age)) + 
  geom_boxplot() +
  scale_y_continuous(limits = c(0, 4e6)) +
  theme(legend.position = "none")  # By Age

ggplot(ac_client_district_loaned, aes(x= dist, y= trans_sum, fill = dist)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(legend.position = "none") # By District


# Loans
ggplot(ac_client_district_loaned, aes(x= age, group = age, y= loan_amount, fill = age)) + 
  geom_boxplot() +
  theme(legend.position = "none") # By Age

ggplot(ac_client_district_loaned, aes(x= dist, y= loan_amount, fill = dist)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(legend.position = "none")# By District

# District Statistics ----> https://marcusbrodie.carto.com/builder/59e2b6ce-6a3b-11e7-808a-0e8c56e2ffdb/embed

# 5. MODELIZATION

ac_cl_d_loaned_num <- ac_client_district_loaned[,c(2:3, 6:8, 9)]

mydata <- scale(ac_cl_d_loaned_num) # Statistical Scaling: (x-mu)/sigma

wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) # One cluster Sum of Squares equals total variance

for(i in 2:15) wss[i]<- sum(fit=kmeans(mydata, centers=i,  100)$withinss) # More than one cluster SS

plot(1:15, wss,type="b", main="15 clusters",
     xlab="no. of cluster", ylab="within cluster sum of squares")

fit <- kmeans(mydata, centers = 6) # With six clusters more than 60% of the Within SS is reduced

fit$withinss

fit$size

library(cluster)
library(fpc)

clusplot(mydata, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
# Creates a bivariate plot visualizing a partition (clustering) of the data. 
# All observation are represented by points in the plot, using principal components or multidimensional scaling

mydata_clust <- data.frame(mydata,fit$cluster)
cluster_mean <- aggregate(mydata_clust[,1:6],by = list(fit$cluster),FUN = mean)
cluster_mean # Scaled

library(DMwR)
unscale(cluster_mean[,2:7], mydata) # Unscaled


ggplot(melt(mydata_clust, measure.vars = 1:6),
       aes(x= fit.cluster, group = fit.cluster, y= value, fill = as.factor(fit.cluster))) + 
  geom_boxplot() +
  facet_wrap(~variable, scales = 'free')

install.packages('d3heatmap')
library(d3heatmap)

d3heatmap(mydata[mydata_clust$fit.cluster == 1, 1:6],
          dendrogram = 'none')
d3heatmap(mydata[mydata_clust$fit.cluster == 2, 1:6],
          dendrogram = 'none')
d3heatmap(mydata[mydata_clust$fit.cluster == 3, 1:6],
          dendrogram = 'none')
d3heatmap(mydata[mydata_clust$fit.cluster == 4, 1:6],
          dendrogram = 'none')
d3heatmap(mydata[mydata_clust$fit.cluster == 5, 1:6],
          dendrogram = 'none')
d3heatmap(mydata[mydata_clust$fit.cluster == 6, 1:6],
          dendrogram = 'none')

## Exercise: Try to find the cluster 1 in the Carto map

# k-medioids

par(mfrow=c(1,3))
plot(pam(mydata, k=2), which=2)
plot(pam(mydata, k=3), which=2)
plot(pam(mydata, k=4), which=2)
plot(pam(mydata, k=5), which=2)
plot(pam(mydata, k=6), which=2)
plot(pam(mydata, k=9), which=2)

# Check factoextra
library(factoextra)
fviz_nbclust(mydata, pam, method = "wss", k.max = 15)
# fviz_nbclust(mydata, kmeans, method = "wss", k.max = 9)


# Gaussian mixtures

library(mclust)
fit.m <- Mclust(mydata)
summary(fit.m)
# under this criterion, the optimal number of clusters is 9
plot(fit.m, what = "classification", main="")
fviz_mclust(fit.m)

# Now with hierarchical methods

# Use euclidean distance (default)
# Use complete linkage (default)
hc <- hclust(dist(mydata), method="complete")

plot(hc, main="")

rect.hclust(hc, k=2, border="red")
# seems like 2 clusters

hc.2 = cutree(hc, 2)
pairs(mydata, col=hc.2, main="euclidean+complete")

clusplot(mydata, hc.2, color=TRUE,shade=TRUE,lines=0)

# try 6 clusters
plot(hc, main="")

rect.hclust(hc, k=6, border="red")

hc.6 = cutree(hc, 6)
pairs(mydata, col=hc.6, main="euclidean+complete")

clusplot(mydata, hc.6, color=TRUE,shade=TRUE,lines=0)


# Silhouette plots for a cut of 2 clusters and 3 clusters
plot(silhouette(cutree(hc, 2),dist(mydata)), main="")
plot(silhouette(cutree(hc, 3),dist(mydata)), main="")
plot(silhouette(cutree(hc, 4),dist(mydata)), main="")
plot(silhouette(cutree(hc, 5),dist(mydata)), main="")
plot(silhouette(cutree(hc, 6),dist(mydata)), main="")
plot(silhouette(cutree(hc, 9),dist(mydata)), main="")


# Now Manhattan distance (L1) + single linkage
hc <- hclust(dist(mydata, method = "manhattan"), method="complete")
clusplot(mydata, cutree(hc, 2), color=TRUE,shade=TRUE,lines=0)

# Silhouette plots for a cut of 2 clusters and 3 clusters
plot(silhouette(cutree(hc, 2),dist(mydata)), main="")
plot(silhouette(cutree(hc, 3),dist(mydata)), main="")

# It seems 2 clusters are enough

clusplot(mydata, cutree(hc, 2), color=TRUE,shade=TRUE,lines=0, main="Manhattan")

fviz_dend(hc.cut, show_labels = FALSE, rect = TRUE)
# Visualize cluster

# Use hcut() which compute hclust and cut the tree
hc.cut <- hcut(mydata, k = 3, hc_method = "complete")

fviz_cluster(hc.cut, ellipse.type = "convex")
