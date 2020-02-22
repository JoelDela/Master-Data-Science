#Borramos los datos
rm(list=ls())

#-------------- Pregunta 1: Lectura de datos ----------#

library(MASS)
data(package="MASS")
boston<-Boston
dim(boston)
names(boston)


#-------------- Pregunta 2: datos de train ----------#
set.seed(101)
train = sample(1:nrow(boston), 300)


#-------------- Pregunta 3: Ajuste del modelo ----------#
rf.boston = randomForest(medv~., data = boston, subset = train)
rf.boston



#-------------- Pregunta 4: Arboles vs. error ----------#

plot(rf.boston)

#-------------- Pregunta 5: oob error vs test error ----------#


oob.err = double(13)
test.err = double(13)
for(mtry in 1:13){
  fit = randomForest(medv~., data = boston, subset=train, mtry=mtry, ntree = 350)
  oob.err[mtry] = fit$mse[350]
  pred = predict(fit, boston[-train,])
  test.err[mtry] = with(boston[-train,], mean( (medv-pred)^2 ))
}




#-------------- Pregunta 6: Grafico oob error vs test error ----------#
par(mfcol = c(1,1))

matplot(1:mtry, cbind(test.err, oob.err), pch = 23, col = c("red", "blue"), type = "b", ylab="Mean Squared Error")
legend("topright", legend = c("OOB", "Test"), pch = 23, col = c("red", "blue"))







################ Gradient Boosting No implementar 




boost.boston = gbm(medv~., data = boston[train,], distribution = "gaussian", n.trees = 10000, shrinkage = 0.01, interaction.depth = 4)
summary(boost.boston)



plot(boost.boston,i="lstat")

plot(boost.boston,i="rm")


n.trees = seq(from = 100, to = 10000, by = 100)
predmat = predict(boost.boston, newdata = boston[-train,], n.trees = n.trees)
dim(predmat)



boost.err = with(boston[-train,], apply( (predmat - medv)^2, 2, mean) )
plot(n.trees, boost.err, pch = 23, ylab = "Mean Squared Error", xlab = "# Trees", main = "Boosting Test Error")
abline(h = min(test.err), col = "red")

