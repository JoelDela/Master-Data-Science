
require(stats)
cars
cohes <- cars
?lm

lm(speed~dist,data =cars)  
lmcars <-lm(speed~dist,data =cars)
require(ggplot2)
#esto hayq ue chequearlo
plot(x=speed, y = dist)

#esto es para poner en la consola
lmcars$residuals
lmcars$fitted.values
cars$speed

# para relacionarlo todo, pensarlo

#usando  los coeficioentes se saca la a y la b

mtcars

lmmcars <- lm(qsec~cyl+hp, data = mtcars)
mean(mtcars$qsec)
summary(lmmcars)
#mientras mas cerca este la probalibidad mas cercana a cero, mejor
summary(mtcars$hp)#por ejemplo, el caso de 

mtcars$azar <- rnorm(32)

lmmcars2 <- lm(qsec~cyl+hp+azar, data = mtcars)
lm(qsec~cyl+hp+azar, data = mtcars)

#•veamos 2 colineales
mtcars$wt2<- mtcars$wt *10+5 +rnorm(32)

lmmcars3 <- lm(qsec~cyl+hp+azar+wt2, data = mtcars)
summary(lmmcars3)

lmmcars0 <- lm(qsec~cyl, data = mtcars)
#se han generado 3 modelos con qsec
#de forma que qsec ~cyl + wt+hp+azar+wt2
#y son modelos anidados
#son selecciones por pasos de los anidados

#para comparar dos modemlos anindados
#y sirve para compara 2 modelos
#y se llama step wise
anova(lmmcars2, lmmcars)
anova(lmmcars, lmmcars0)


#lo de anova es similar al ttest

#otra forma de hacerlo automatico_

#AIC: para ver que modelo es mejor
# AIC se puede usar tanto para modelos anidados, como que no lo sean
#aunque si no lo son se recoienda no hacerlo
?step

step(lmmcars3, direction = "both")
#y da un resultado
#hay que mirar AIC, cuanto mas pequeño, mej


step(lmmcars, direction = "both")

step(lmmcars0, direction = "both")
names(lmcars)
AIC(lmcars)
logLik(lmcars)
plot(lmmcars3)

#ojo, los errores deberian distribuirse aleatoriamente
#la siguiente grafica es quantilQQ: si los residuos siguen la linea es que tienen una distribucion normal

plot(lmmcars)

library(caret)
install.packages("caret")
install.packages(c("ROCR","Amelia"))
install.packages("titanic")
#se fuerza a hacer lineales añadiendo vables

?mtcars
lmmtcars4 <- lm(qsec~hp+cyl+wt+am, data = mtcars)
summary(lmmtcars4)
#por lo que, si tenemos  una vable booleana, vale pq la relacion siempre es lineal
#como es el ejemplo de am
#al ser negativo, lo unico que tiene sentido es si esta ordenada
summary(mtcars$mpg)

mtcars$mpg_cualitativa <- (mtcars$mpg<15)+(mtcars$mpg<22)
#por encima de 22, 0, menos de 15,2, entre ambos, 1.
as.factor(mtcars$mpg_cualitativa)
lmmtcars_cualitativa <- lm(qsec~mpg_cualitativa+hp, data = mtcars)
summary(lmmtcars_cualitativa)
mtcars$mpg_cualitativa<-as.factor((mtcars$mpg<15)+(mtcars$mpg<22))
lmmtcars_cualitativa <- lm(qsec~mpg_cualitativa+hp, data = mtcars)
summary(lmmtcars_cualitativa)

library(titanic)


View(Titanic)
titanic0 <- glm(Survived~Age, data = titanic_train)
titanic0
summary(titanic0)

titanic0$family
?glm

titanic1 <- glm(Survived~Age, data = titanic_train, family=gaussian(link ="identity"))
titanic1$family
#con esto se hace lo mismo
titanic1 <- glm(Survived~Age, data = titanic_train, family="gaussian")
titanic1$family

titanic1 <- glm(Survived~Age, data = titanic_train, family=binomial(link="identity"))
titanic1$family
summary(titanic1)

titanic2 <- glm(Survived~Age, data = titanic_train, family=binomial(link="logit"))
summary(titanic2)

titanic3 <- glm(Survived~Age+Pclass+Sex, data = titanic_train, family=binomial(link="logit"))
summary(titanic3)

#para este caso, lo que se hace es hacer la comprativa de la clase, de la segund calse con la priera
#y de la clase 3 a primera clase.
titanic3 <- glm(Survived~Age+as.factor(Pclass)+Sex, data = titanic_train, family=binomial(link="logit"))

summary(titanic3)

#esto es g del sumatorio (aplicar la logistica al valor de la persona):
titanic3$fitted.values

#combinador lineal: enseña pesos q es una combinacion lineal
#se pasa por la funcion denen lace y se reduce el error
#es decir, pasar de lineas a "S""
#y spr es un sumador



#1 sobrevive, 0 muere
mis_predicciones <- titanic3$fitted.values>0.5
#estos son  los punto de corte sabiendo que tenemos un error
summary(titanic_train$Survived)

#como mis predicciones son true o false, lo cambio multiplicando por 1, y luego comparo con la realidad

mean((mis_predicciones*1) == titanic_train$Survived)

p <- titanic3$fitted.values

p <- predict(titanic3, type = "response", newdata = titanic_train)

p <- predict(titanic3, type = "response", newdata = titanic_test)
library(ROCR)
titanic_train$Age[is.na(titanic_train$Age)]
titanic_train$Age[is.na(titanic_train$Age)]<-30
titanic_train$Age[is.na(titanic_train$Age)]<- mean(titanic_train$Age,na.rm = TRUE)
#la idea es haberlo entrenado, asi que o bien ponemos los datos donde lo hemos probado, o los nuevos
titanic_prediction <- prediction(p,titanic_train$Survived)

#probabilidad de ratio positivo
#esta es la curva rocr
plot(performance(titanic_prediction, measure = "tpr", x.measure = "fpr"))
performance(titanic_prediction, measure = "tpr", x.measure = "fpr")

plot(performance(titanic_prediction, measure = "tpr", x.measure = "fpr"))
performance(titanic_prediction, measure = "tpr", x.measure = "fpr")


k <- performance(titanic_prediction, measure = "tpr", x.measure = "fpr")
str(k@x.values)
k@x.values[[1]]
?str
max(which(1<0.20))
k@alpha.values[[1]][285]
plot(titanic3)

