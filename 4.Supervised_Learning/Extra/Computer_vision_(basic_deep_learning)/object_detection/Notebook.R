#-------------------------------------------------------------------------------------------#
#  ___    _         _                 _       ____           _                   _     _                 
# / _ \  | |__     (_)   ___    ___  | |_    |  _ \    ___  | |_    ___    ___  | |_  (_)   ___    _ __  
#| | | | | '_ \    | |  / _ \  / __| | __|   | | | |  / _ \ | __|  / _ \  / __| | __| | |  / _ \  | '_ \ 
#| |_| | | |_) |   | | |  __/ | (__  | |_    | |_| | |  __/ | |_  |  __/ | (__  | |_  | | | (_) | | | | |
# \___/  |_.__/   _/ |  \___|  \___|  \__|   |____/   \___|  \__|  \___|  \___|  \__| |_|  \___/  |_| |_|
#                |__/                                                                                    
#-------------------------------------------------------------------------------------------#


rm(list=ls())

#-------------------------------- Load packages --------------------------------------------#


if (!require("grid")){install.packages("grid",verbose = F) ; library("grid")}
if (!require("stringi")){install.packages("stringi",verbose = F) ; library("stringi")}
if (!require("caret")){install.packages("caret",verbose = F) ; library("caret")}
if (!require("RSNNS")){install.packages("RSNNS",verbose = F) ; library("RSNNS")}
if (!require("imager")){install.packages("imager",verbose = F) ; library("imager")}



source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
a
library(rhdf5)


#----------------------------------- End --------------------------------------------#





#-------------------------------- Load data  --------------------------------------------#

h5ls(NULL)

my_data_train_x <- h5read(NULL)
my_data_train_y <- h5read(NULL)



h5ls("./data_in/test_catvnoncat.h5")

my_data_test_x <- h5read(NULL)
my_data_test_y <- h5read(NULL)


#----------------------------------- End --------------------------------------------#




#-------------------------------- How to plot an image --------------------------------------#

n<-3

r <- matrix(NULL[1,,,n]/255,ncol=64)
g <- matrix(NULL[2,,,n]/255,ncol=64)
b <- matrix(NULL[3,,,n]/255,ncol=64)

col <- rgb(r, g, b)
dim(col) <- dim(r)
col<-t(col)


grid.raster(NULL, interpolate=FALSE)

#----------------------------------- End --------------------------------------------#




#-------------------------------- Pre process data --------------------------------------#


#Train data

my_data_train<-data.frame(matrix(NULL))


for(i in 1:NULL){
  
  print(i)
  
  r <- matrix(NULL[1,,,i],ncol=64)
  g <- matrix(NULL[2,,,i],ncol=64)
  b <- matrix(NULL[3,,,i],ncol=64)
  
  NULL[i,]<-c(as.vector(r),as.vector(g),as.vector(b))

  
}

my_data_train<-cbind(Y=NULL,my_data_train)


#Test data

my_data_test<-data.frame(matrix(NULL))

for(i in 1:50){
  
  print(i)
  
  r <- matrix(NULL[1,,,i],ncol=64)
  g <- matrix(NULL[2,,,i],ncol=64)
  b <- matrix(NULL[3,,,i],ncol=64)
  
  NULL[i,]<-c(as.vector(r),as.vector(g),as.vector(b))
  
  
}


my_data_test<-cbind(Y=NULL,my_data_test)




#----------------------------------- End --------------------------------------------#



#------------------------- Train Logistic Regression ---------------------------------#

#Classic logistic regression Newton-Rhapson coefficients
my_model<-glm(factor(Y)~ ., binomial(link = "logit"), data = NULL)


#Logistic regression with boosting algorithm (run next 3 lines)
print(paste(Sys.time(),"Training..."))
my_logistic_model <- caret::train(factor(Y) ~ .,  data=NULL, method="LogitBoost")
print(paste(Sys.time(),"Done!"))

print(paste(Sys.time(),"Predict..."))
yhat_train_logistic<-predict(NULL,NULL)
print(paste(Sys.time(),"Done!"))


print(paste(Sys.time(),"Predict..."))
yhat_test_logistic<-predict(NULL,NULL)
print(paste(Sys.time(),"Done!"))

#----------------------------------- End --------------------------------------------#





#------------------------- How good is your model ---------------------------------#


conf_matrix_train<-table(NULL,my_data_train$Y)
conf_matrix_train

conf_matrix_test<-table(NULL,my_data_test$Y)
conf_matrix_test
#----------------------------------- End --------------------------------------------#




#------------------------- Let's check the results ---------------------------------#

idx_tp<-which(yhat_test_logistic==NULL & my_data_test$Y==NULL)

idx_tn<-which(yhat_test_logistic==NULL & my_data_test$Y==NULL)

idx_fp<-which(yhat_test_logistic==NULL & my_data_test$Y==NULL)

idx_fn<-which(yhat_test_logistic==NULL & my_data_test$Y==NULL)


n<-14

r <- matrix(NULL[1,,,n]/255,ncol=64)
g <- matrix(NULL[2,,,n]/255,ncol=64)
b <- matrix(NULL[3,,,n]/255,ncol=64)

col <- rgb(r, g, b)
dim(col) <- dim(r)
col<-t(col)


grid.raster(NULL, interpolate=FALSE)

#----------------------------------- End --------------------------------------------#






#------------------------- Enjoy with machine learning ---------------------------------#

my_image<-load.image("NULL")
my_image<-resize(my_image,64,64)

my_image_array<-as.array(my_image)



image_test_data<-data.frame(matrix(ncol=64*64*3))


r <- matrix(NULL[1,,,1]*255,ncol=64)
g <- matrix(NULL[2,,,1]*255,ncol=64)
b <- matrix(NULL[3,,,1]*255,ncol=64)

NULL[1,]<-c(as.vector(r),as.vector(g),as.vector(b))


ypred_image_test<-predict(my_logistic_model,NULL)
ypred_image_test



col <- rgb(r, g, b)
dim(col) <- dim(r)
col<-t(col)


grid.raster(NULL, interpolate=FALSE)





#----------------------------------- End --------------------------------------------#



