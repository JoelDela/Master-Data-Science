##########################################
### Breast Cancer Prediction Case Study
#      used for logistic regression topic
##########################################

# Source: UCI Machine Learning Repository
# https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Original)

# Attribute Information:
#  
# 1. Sample code number: id number 
# 2. Clump Thickness: 1 - 10 
# 3. Uniformity of Cell Size: 1 - 10 
# 4. Uniformity of Cell Shape: 1 - 10 
# 5. Marginal Adhesion: 1 - 10 
# 6. Single Epithelial Cell Size: 1 - 10 
# 7. Bare Nuclei: 1 - 10 
# 8. Bland Chromatin: 1 - 10 
# 9. Normal Nucleoli: 1 - 10 
# 10. Mitoses: 1 - 10 
# 11. Class: (2 for benign, 4 for malignant)

# Objective: develop an analytical model to predict if a given tumor (breast) is 
# benign or malignant using the available information (data)

# UCI Machine Learning reports a 95.9% accuracy for the best model

# delete everything
rm(list=ls()) 

# Load data
cancer <- read.csv('breast-cancer-wisconsin.data.txt', na.strings='?', stringsAsFactors=F, header=F)
head(cancer)
names(cancer) <- c('ID', 'Clump.Thickness', 'Uniformity.of.Cell.Size', 'Uniformity.of.Cell.Shape', 
                   'Marginal.Adhesion', 'Single.Epithelial.Cell.Size', 'Bare.Nuclei', 
                   'Bland.Chromatin', 'Normal.Nucleoli', 'Mitoses', 'Class')

str(cancer)
summary(cancer)

cancer$Class <- as.factor(ifelse(cancer$Class > 3, 'Malignant', 'Benign'))
cancer$ID <- NULL

# All features/predictors are discrite variables scaled between 1 and 10

# 16 NAs in Bare Nuclei


# Split data into training and testing sets
split <- sample(1:nrow(cancer), floor(nrow(cancer)*0.7))  # 70% of the sample for training
train <- cancer[split,]
test<- cancer[-split,]

# NA imputation
table(train$Bare.Nuclei)
i_na <- is.na(train$Bare.Nuclei) # identify
sum(i_na)
train$Bare.Nuclei[i_na] <- 1     # imputation
# other imputation
# imputation_median <- median(train$Bare.Nuclei[!i_na])
# train$Bare.Nuclei[i_na] <- imputation_median

# The same for testing set
i_na <- is.na(test$Bare.Nuclei)  # identify
test$Bare.Nuclei[i_na] <- 1     # imputation

table(train$Class)
n = length(train$Class)
# Naive accuracy if we predict all benign: 
100*table(train$Class)[1]/n
# Naive accuracy if we predict all malignant: 
100*table(train$Class)[2]/n

# Can we do it better?

# Let's analyze a bit the available data

boxplot(train[,1:9], col="blue")

# boxplots with a better scale
par(mfrow=c(3,3))
sapply(seq(1,9),function(j)boxplot(train[,j],main=names(cancer)[j],xlab="",ylab="",col="blue"))
dev.off()

# assymetric predictors, specially Mitoses, where more than 80% of the values are equal to 1
table(train$Mitoses)
# Maybe we can regroup this variable, try later
# train$MitosesFac = as.factor(ifelse(train$Mitoses<=1, 1, 0))
# test$MitosesFac = as.factor(ifelse(test$Mitoses<=1, 1, 0))


# now by Class
par(mfrow=c(3,3))
sapply(seq(1,9),function(j)boxplot(train[,j] ~ train$Class, xlab = "", ylab="", col="blue", main = names(cancer)[j]))

# All the features seem important. Some features, like Uniformity.of.Cell.Size, Uniformity.of.Cell.Shape, etc. 
# could be regrouped as Mitoses because one of their levels is the relevant one
dev.off()

# pairwise relations between features
pairs(train[,1:9],pch=19,col=train$Class)

# with logs
pairs(log(train[,1:9]+1),pch=19,col=train$Class)
# all variables are correlated

# ok, but boxplots more informative

# Let's make some simple models to understand better

reglog.1a <- glm(Class ~ Clump.Thickness, family=binomial(link='logit'), data=train)
summary(reglog.1a)
# interpretation:
#  for every one unit change in Clump.Thickness, the log odds of Class increases by 0.9
confint(reglog.1a)
# difficult to interpret. 
# Better to see odds ratios
exp(coef(reglog.1a))
# for every one unit increase in Clump.Thickness, the odds of having malignant increases by a factor of 2.4

# Perform some simple regressions to understand what is behind
for(j in c(1,2,3,4,5,6,7,8,9)){
  print(colnames(train)[j])
  glm.fit=glm(train$Class ~ train[,j], family=binomial(link='logit'))
  print(summary(glm.fit))
  readline(prompt="Press [enter] to continue ")
}

# All variables are significant. More important are:
#  Uniformity.of.Cell.Size
#  Uniformity.of.Cell.Shape
#  Bare.Nuclei
#  Bland.Chromatin

# Now a complete logistic regression
reglog.full <- glm(Class ~., family=binomial(link='logit'), data=train)
summary(reglog.full)

# These seems the more important:
#  Clump.Thickness
#  Bare.Nuclei

# others are less significant.
# Take care: with other training set, the significance changes...

# alternative models

reglog.sig <- glm(Class ~ Clump.Thickness + Bare.Nuclei, family=binomial(link='logit'), data=train)
summary(reglog.sig)

reglog.siginter <- glm(Class ~ Clump.Thickness + Bare.Nuclei + Clump.Thickness:Bare.Nuclei + I(Bare.Nuclei^2), family=binomial(link='logit'), data=train)
summary(reglog.siginter)

# if we try to include all interactions and second order terms
reglog.fullinter <- glm(Class ~.^2, family=binomial(link='logit'), data=train)
# not reliable, consider regularization (see later)...

# Evaluation

# In-sample:
prob = predict(reglog.full, type="response")
prob

#confusion matrix in-sample for a threshold prob = 0.5
ConfMat = table(train$Class, prob > 0.5)
ConfMat

accuracy <- sum(diag(ConfMat)) / n
accuracy

# Two types of risks are associated with the decision/prediction:
#
#   predict benign when in fact it's malignant: false negative -> dangerous
#   predict malignant when in fact it's bening: false positive -> less serious
100*table(train$Class)/n
# Naive conservative: predict all are malignant
# accuracy = 35% but too expensive...
# we can decrease the 0.5 a bit, but at the cost of increasing false positives
table(train$Class, prob > 0.2) 
# Note how accuracy is globally reduced, although false negatives are also reduced (by increasing false positives)

# But what happens with the testing set?
# Out-of-sample evaluation:

# predicting the testing set
prob.test = predict(reglog.full, newdata=test, type="response")

#ROCR Curve: may help to decide the threshold
library(ROCR)
ROCRpred <- prediction(prob.test, test$Class)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7), lwd=4)

# In terms of global accuracy
NewClass = (test$Class=="Malignant")
cutoffs <- seq(0.0,1.0,0.01)
accuracy <- NULL
for (i in seq(along = cutoffs)){
  pred <- ifelse(prob.test >= cutoffs[i], 1, 0) #Predicting for cut-off
  accuracy <- c(accuracy,length(which(NewClass ==pred))/length(pred)*100)
}

plot(cutoffs, accuracy, pch =19,type='b',col= "steelblue",
     main ="Logistic Regression", xlab="Cutoff Level: threshold", ylab = "Accuracy %", lwd=4)

# Maybe 0.2 is a good threshold taking into account false negatives are more serious than false positives
# In general, the threshold is decided by using a convenient loss function: 
#  a cost for false negatives and another cost for false positives

threshold = 0.2
#confusion matrix
ConfMat = table(test$Class, (prob.test > threshold))
ConfMat

n = dim(test)[1]
accuracy <- sum(diag(ConfMat)) / n
accuracy

# Now we are going to repeat the process many times and see what happens
n.models = 3  # number of models to try
n.replicates = 100  # number of replications
accuracy.out = array(NA, dim=c(n.replicates,n.models)) 
for(i in 1:n.replicates){
  
  cat(i," ")
  
  # Split data into training and testing sets
  split <- sample(1:nrow(cancer), floor(nrow(cancer)*0.7))  # 70% of the sample for training
  train <- cancer[split,]
  test<- cancer[-split,]
  n = dim(test)[1]
  
  # NA imputation
  i_na <- is.na(train$Bare.Nuclei) # identify
  train$Bare.Nuclei[i_na] <- 1     # imputation
  i_na <- is.na(test$Bare.Nuclei)  # identify
  test$Bare.Nuclei[i_na] <- 1     # imputation
  
  # Complete logistic regression
  reglog.full <- glm(Class ~., family=binomial(link='logit'), data=train)
  prob.test = predict(reglog.full, newdata=test, type="response")
  ConfMat = table(test$Class, (prob.test > threshold))
  accuracy.out[i,1] <- sum(diag(ConfMat)) / n

  # Two predictors logistic regression
  reglog.sig <- glm(Class ~ Clump.Thickness + Bare.Nuclei, family=binomial(link='logit'), data=train)
  prob.test = predict(reglog.sig, newdata=test, type="response")
  ConfMat = table(test$Class, (prob.test > threshold))
  accuracy.out[i,2] <- sum(diag(ConfMat)) / n
  
  # Two predictors with second-order terms
  reglog.siginter <- glm(Class ~ Clump.Thickness + Bare.Nuclei + Clump.Thickness:Bare.Nuclei + I(Bare.Nuclei^2), family=binomial(link='logit'), data=train)
  prob.test = predict(reglog.siginter, newdata=test, type="response")
  ConfMat = table(test$Class, (prob.test > threshold))
  accuracy.out[i,3] <- sum(diag(ConfMat)) / n

}

boxplot(accuracy.out,col="blue",xlab="", ylab="accuracy (out-of-sample)", ylim = c(0.9, 1), main="",names=c("full","2","2int"))

