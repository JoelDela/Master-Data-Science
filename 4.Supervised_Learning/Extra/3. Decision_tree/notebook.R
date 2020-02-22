#Borramos los datos
rm(list=ls())

#Lectura de los datos
data(package="ISLR")
carseats<-Carseats
names(carseats)

#---- Pregunta 1: Previsualizacion de los datos ------#
hist(carseats$Sales)

#Clase de cada variable 
sapply(carseats,NULL)


#---- Pregunta 2: Clssification decision tree ------#

High = ifelse(NULL<=NULL, "No", "Yes")
carseats = data.frame(carseats, High)

tree.carseats = tree(NULL, data=carseats)


summary(NULL)



#---- Pregunta 3: Analisis grafico ------#

plot(NULL)
text(tree.carseats, pretty = 0)


tree.carseats



#---- Pregunta 4 y 5: Estimación con decision trees ------#

set.seed(101)
train=sample(1:nrow(NULL), 250)


tree.carseats = tree(High~.-Sales, NULL, subset=train)
plot(NULL)
text(tree.carseats, pretty=0)


tree.pred = predict(tree.carseats, carseats[-NULL,], type="class")


with(carseats[-train,], table(tree.pred, High))

cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass)
cv.carseats



plot(cv.carseats)




prune.carseats = prune.misclass(tree.carseats, best = 12)
plot(prune.carseats)
text(prune.carseats, pretty=0)



tree.pred = predict(prune.carseats, carseats[-train,], type="class")
with(carseats[-train,], table(tree.pred, High))
(74 + 39) / 150

