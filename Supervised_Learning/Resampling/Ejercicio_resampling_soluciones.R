rm(list = ls())
gc()

library(ISLR)
library(caret)

data(Auto)
str(Auto)

prop_training <- 0.6
n_iter <- 10

set.seed(42)
train_index_list <- createDataPartition(1:nrow(Auto), p = prop_training,
                                        times = n_iter)
str(train_index_list)

# Solo si no funciona caret ----------------------------------------------------------
train_index_list2 <- list(T1 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T2 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T3 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T4 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T5 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T6 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T7 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T8 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T9 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)),
                          T10 = sample(1:nrow(Auto), size = prop_training*nrow(Auto)))
# -------------------------------------------------------------------------------------

mat <- matrix(nrow = 0, ncol = 6)
colnames(mat) <- c('mse_train_1', 'mse_test_1', 'mse_train_2', 'mse_test_2', 'mse_train_3', 'mse_test_3')

# VALIDATION SET
for(train_index in train_index_list){ # Si no funciona caret úsese train_index_list2
    training_data <- Auto[train_index,]
    test_data <- Auto[-train_index,]
    mod_1 <- lm(mpg ~ horsepower, data = training_data)
    mod_2 <- lm(mpg ~ horsepower + I(horsepower^2), data = training_data)
    mod_3 <- lm(mpg ~ horsepower + I(horsepower^2) + I(horsepower^3), data = training_data)
    mse_train_1 <- mean((mod_1$residuals)**2) # mean((training_data$mpg - mod_1$fitted.values)**2)
    mse_train_2 <- mean((mod_2$residuals)**2) # mean((training_data$mpg - mod_2$fitted.values)**2)
    mse_train_3 <- mean((mod_3$residuals)**2) # mean((training_data$mpg - mod_3$fitted.values)**2)
    mse_test_1 <- mean((test_data$mpg - predict(mod_1, test_data))**2)
    mse_test_2 <- mean((test_data$mpg - predict(mod_2, test_data))**2)
    mse_test_3 <- mean((test_data$mpg - predict(mod_3, test_data))**2)
    mat <- rbind(mat, c(mse_train_1,
                        mse_test_1,
                        mse_train_2,
                        mse_test_2,
                        mse_train_3,
                        mse_test_3))
  
}
mat <- as.data.frame(mat)
mat

# LGOCV
colMeans(mat)

apply(mat, 2, sd)


# LOOCV
err_1 <- c()
err_2 <- c()
err_3 <- c()
for(i in 1:nrow(Auto)){
  mod_1 <- lm(mpg ~ horsepower, data = Auto[-i,])
  mod_2 <- lm(mpg ~ horsepower + I(horsepower^2), data = Auto[-i,])
  mod_3 <- lm(mpg ~ horsepower + I(horsepower^2) + I(horsepower^3), data = Auto[-i,])
  err_1 <- c(err_1, (Auto$mpg[i] - predict(mod_1, Auto[i,]))**2)
  err_2 <- c(err_2,  (Auto$mpg[i] - predict(mod_2, Auto[i,]))**2)
  err_3 <- c(err_3,  (Auto$mpg[i] - predict(mod_3, Auto[i,]))**2)
}
mean(err_1)
mean(err_2)
mean(err_3)

# k-fold CV

fold_index_list <- createFolds(Auto$mpg, k = 10)
lapply(fold_index_list, length) # check. Como la longitud del dataset no es divisible por 10 
# los folds no tienen todos exactamente el mismo número de elementos

# Auto$fold <- 1 + sample(1:nrow(Auto))%%10 # si caret no funciona
mat <- matrix(nrow = 0, ncol = 6)
colnames(mat) <- c('mse_train_1', 'mse_test_1', 'mse_train_2', 'mse_test_2', 'mse_train_3', 'mse_test_3')
for(fold in fold_index_list){  # for(i in 1:10) { # si caret no funciona
  training_data <- Auto[-fold, ] # Auto[Auto$fold != i, ] # si caret no funciona
  test_data <- Auto[fold, ] # Auto[Auto$fold == i,] # si caret no funciona
  mod_1 <- lm(mpg ~ horsepower, data = training_data)
  mod_2 <- lm(mpg ~ horsepower + I(horsepower^2), data = training_data)
  mod_3 <- lm(mpg ~ horsepower + I(horsepower^2) + I(horsepower^3), data = training_data)
  mse_train_1 <- mean((mod_1$residuals)**2) # mean((training_data$mpg - mod_1$fitted.values)**2)
  mse_train_2 <- mean((mod_2$residuals)**2) # mean((training_data$mpg - mod_2$fitted.values)**2)
  mse_train_3 <- mean((mod_3$residuals)**2) # mean((training_data$mpg - mod_3$fitted.values)**2)
  mse_test_1 <- mean((test_data$mpg - predict(mod_1, test_data))**2)
  mse_test_2 <- mean((test_data$mpg - predict(mod_2, test_data))**2)
  mse_test_3 <- mean((test_data$mpg - predict(mod_3, test_data))**2)
  mat <- rbind(mat, c(mse_train_1,
                      mse_test_1,
                      mse_train_2,
                      mse_test_2,
                      mse_train_3,
                      mse_test_3))
}
mat <- as.data.frame(mat)
mat
colMeans(mat)

apply(mat, 2, sd)
