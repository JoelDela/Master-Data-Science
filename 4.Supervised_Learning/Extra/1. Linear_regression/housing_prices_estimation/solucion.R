rm(list=ls())

#load dataset, you can use choose file also
my_data<-as.data.frame(fread("./data_in/housing_dataset.txt"))
#my_data<-as.data.frame(fread(choose.files()))


#verify type of variable for each column
sapply(my_data,function(x) class(x))

#Calculo de las correlaciones entre las variables 
View(cor(my_data))


M <- cor(my_data)
col1 <- colorRampPalette(c("blue", "yellow"))
cex.before <- par("cex")
par(cex = 0.7)
corrplot(M, method = "color",
         col=col1(100), #eliges el color
         addCoef.col = "black", #color de los coeficientes
         tl.col="black", #color de las letras de los ejes
         tl.cex=1, #Tamaño de la letra de los ejes
         tl.srt=45, #Rotación eje x
         is.corr=T, #es una correlación? sí
         cl.offset=1, #Separación de label con el corrplot
         cl.cex=1/par("cex")
)




#Definimos las variables

y<-my_data$MEDV     # valor mediano de las casas en miles de dólares
x1<-my_data$CRIM    # tasa de crimen
x2<-my_data$ZN     # proporción terreno residencial
x3<-my_data$INDUS    # proporción de terreno industrial
x4<-my_data$CHAS      # variable dicotomica (=1 zona con rio; 0 sin rio)
x5<-my_data$NOX      # concentración de oxido nitroso
x6<-my_data$RM       # número medio de habitaciones
x7<-my_data$AGE      # proporción de casa contruidas antes de 1940
x8<-my_data$DIS      # distancia a oficinas de empleo
x9<-my_data$RAD      # indice de acceso a carreteras de circunvalación
x10<-my_data$TAX      # tasa de impuestos sobre el precio de la casa por cada $10,000
x11<-my_data$PTRATIO  # ratio estudiante/maestro en las escuelas
x12<-my_data$B        # 1000*(Bk-0.63)^2 donde Bk es la proporción de inmigrantes
x13<-my_data$LSTAT    # porcentaje de población de clase baja



# Analisis de la hipotesis de distribucion gaussiana de la variable MEDV
par( mfcol = c( 1, 2))
y<-my_data$MEDV
hist(y,prob=T,main="Histograma de Frecuencias Relativas, variable MEDV",ylab=
       "Densidad", xlab="MEDV")
lines(density(y),col="blue")
qqnorm(y,main="Normal Q-Q Plot, variable MEDV",ylab="Cuantiles de Muestra",
       xlab="Cuantiles Teóricos")
qqline(y,col="blue")
lillie.test(y)


# Análisis de normalidad de la variable log(MEDV)
y<-log(y)
hist(y,prob=T,main="Histograma de Frecuencias Relativas, variable log(MEDV)",ylab=
       "Densidad", xlab="MEDV")
lines(density(y),col="blue")
qqnorm(y,main="Normal Q-Q Plot, variable log(MEDV)",ylab="Cuantiles de Muestra",
       xlab="Cuantiles Teóricos")
qqline(y,col="blue")
lillie.test(y)



par(mfcol=c(3,4))


plot(x1,y)
abline(lm(y~x1))
plot(x2,y)
abline(lm(y~x2))
plot(x3,y)
abline(lm(y~x3))
plot(x4,y)
abline(lm(y~x4))
plot(x5,y)
abline(lm(y~x5))
plot(x6,y)
abline(lm(y~x6))
plot(x7,y)
abline(lm(y~x7))
plot(x9,y)
abline(lm(y~x9))
plot(x10,y)
abline(lm(y~x10))
plot(x11,y)
abline(lm(y~x11))
plot(x12,y)
abline(lm(y~x12))
plot(x13,y)
abline(lm(y~x13))
par(mfcol=c(1,2))
plot(x8,y)
abline(lm(y~x8))
plot(log(x8),y)
abline(lm(y~log(x8)))



########Analisis de los modelos simples con la variable log(MEDV)##############

par( mfcol = c( 2, 2 ))

summary(lm(y~x1))
plot(lm(y~x1))

summary(lm(y~x2))
plot(lm(y~x2))

summary(lm(y~x3))
plot(lm(y~x3))

summary(lm(y~x4))
plot(lm(y~x4))

summary(lm(y~x5))
plot(lm(y~x5))

summary(lm(y~x6))
plot(lm(y~log(x6)))

summary(lm(y~x7))
plot(lm(y~x7))

summary(lm(y~x8))
plot(lm(y~x8))

summary(lm(y~log(x8)))
plot(lm(y~log(x8)))

summary(lm(y~x9))
plot(lm(y~x9))

summary(lm(y~x10))
plot(lm(y~x10))

summary(lm(y~x11))
plot(lm(y~x11))

summary(lm(y~x12))
plot(lm(y~x12))

summary(lm(y~x13))
plot(lm(y~x13))

x8<-log(x8)

##############Modelo con todas las variables########################

model<-lm(y~x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13)
summary(model)

###################Akaike Information Criteria###########################
step(model,trace=F)$anova

##Eliminamos las veriables CRIM(x1), ZN(x2), INDUS(x3), AGE(x7)###########

model<-lm(y~x4+x5+x6+x8+x9+x10+x11+x12+x13)
summary(model)

###Factor de Inflación de la Varianza (VIF)######
vif(model)

######Modelo eliminando la variable TAX(x10)###########
model<-lm(y~x4+x5+x6+x8+x9+x11+x12+x13)
summary(model)

######Aplicamos nuevamente AIC#########
step(model,trace=F)$anova

#########Eliminamos la variable RAD(x9)##################
model<-lm(y~x4+x5+x6+x8+x11+x12+x13)
summary(model)

#############Calculamos nuevamente el VIF##################
vif(model)

##########Análisis de datos atípicos######################

par(mfrow=c(1,1))
plot(cooks.distance(model))
abline(h=2*8/nrow(my_data))
identify(cooks.distance(model))

###################Eliminamos los datos atipicos#############

my_data<-my_data[c(-200,-345,-346,-348,-349,-352,-353,-355,-379,-393),]



##############Creacion del modelo final###################


y<-log(my_data$MEDV)     #logaritmo del valor mediano de las casas en miles de dólares
x4<-my_data$CHAS      # variable dicotomica (=1 zona con rio; 0 sin rio)
x5<-my_data$NOX      # concentración de oxido nitroso
x6<-my_data$RM       # número medio de habitaciones
x8<-log(my_data$DIS) # logaritmo de distancia a oficinas de empleo
x11<-my_data$PTRATIO  # ratio estudiante/maestro en las escuelas
x12<-my_data$B        # 1000*(Bk-0.63)^2 donde Bk es la proporción de inmigrantes
x13<-my_data$LSTAT    # porcentaje de población de clase baja


model<-lm(y~x4+x5+x6+x8+x11+x12+x13)
summary(model)
par(mfcol=c(2,2))
plot(model)

####Hacemos AIC y VIF para confirmar que no haya multicolinealidad#####

vif(model)
step(model,trace=F)$anova


#####Prediccion de los datos#####

pred0<-data.frame(x4=0,x5=0.508,x6=5.575,x8=4.19,
                  x11=16.3, x12=321.9, x13=2.98)
wor<-exp(predict.lm(model,pred0,interval="confidence"))

pred1<-data.frame(x4=1,x5=0.508,x6=5.575,x8=4.19,
                  x11=16.3, x12=321.9, x13=2.98)
wr<-exp(predict.lm(model,pred1,interval="confidence"))

wr/wor




######## ¿Se puede construir una matriz de confusión? #######


my_pred<-as.data.frame(exp(predict.lm(model,newdata=my_data,interval="confidence",level = 0.9999)))

result_conf<-ifelse( my_pred$lwr < my_data$MEDV & my_data$MEDV < my_pred$upr,1,0)

table(result_conf)


