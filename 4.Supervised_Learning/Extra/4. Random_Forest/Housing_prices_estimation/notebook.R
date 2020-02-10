#Borramos los datos
rm(list=ls())

#-------------- Pregunta 1: Lectura de datos ----------#

library(NULL)
data(package="MASS")
boston<-Boston
dim(boston)
names(boston)


#-------------- Pregunta 2: datos de train ----------#
set.seed(101)
train = sample(1:nrow(NULL), NULL)


#-------------- Pregunta 3: Ajuste del modelo ----------#
rf.boston = randomForest(NULL, data = NULL, subset = NULL)
rf.boston



#-------------- Pregunta 4: Arboles vs. error ----------#

plot(NULL)



#-------------- Pregunta 5: oob error vs test error ----------#


oob.err = double(13)
test.err = double(13)
for(mtry in 1:13){
  fit = randomForest(NULL, data = NULL, subset=NULL, mtry=NULL, ntree = 350)
  oob.err[mtry] = fit$mse[350]
  pred = predict(fit, boston[-NULL,])
  test.err[mtry] = with(boston[-NULL,], mean( (medv-pred)^2 ))
}




#-------------- Pregunta 6: Grafico oob error vs test error ----------#

matplot(1:mtry, cbind(test.err, oob.err), pch = 23, col = c("red", "blue"), type = "b", ylab="Mean Squared Error")
legend("topright", legend = c("OOB", "Test"), pch = 23, col = c("red", "blue"))





