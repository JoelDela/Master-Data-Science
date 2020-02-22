############################################################################
################ INICIO DEL SCRIPT: CHOOSING BEST MODEL #################### 
#### EN ESTE SCRIPT INTENTAMOS M?TODOS CL?SICOS PARA FORECASTING OF TIME ### 
######## SERIES. SELECCIONAMOS EL MEJOR MODELO CON EL INDICADOR MSAE #######
############################################################################



rm(list = ls())



#Cargamos los datos del script download
data_price<-fread("./data_in/energy.csv",sep=",")
data_price<-as.data.frame(data_price)
data_price$V1<-NULL

#####################################################################
######################### EXPLORING DATA ##########################
#####################################################################

#Realizamos una exploracion previa de la serie

y<-ts(data_price$price_spain,frequency = 24) #Serie hist?rica de precios
summary(y)
plot(y)
plot(decompose(y))

par(mfrow=c(2,1))

hist(y,probability = T)
lines(density(y),col="red",lwd=2)
qqnorm(y)
qqline(y)

#Explorando acf
acf(y)


#Originalmente la serie no es estacionaria, procedemos a realizar
#ciertas transformaciones
acf(log(y))


par(mfrow=c(3,1))
for(i in 1:3){
  acf(diff(log(y),differences = i),main=paste0("ACF para la serie de diferencias con i=",i ))
}



#No ha sido posible mediante transformaciones clasicas lograr que la serie
# sea estacionaria. Por lo que, no deberíamos utilizar ARMA.




#####################################################################
######################### CROSS-VALIDATION ##########################
#####################################################################

#Vamos a realizar una "validacion cruzada" que para series de tiempo
#se llama "Rolling forecasting origin"

y<-ts(data_price$price_spain,frequency = 24) #Serie hist?rica de precios

errordf<-data.frame(err1=0,err2=0,err3=0,err4=0,err5=0,err6=0,err7=0) #Inicializaci?n de los 
npred<-24

print(paste0(Sys.time(),": Inicio"))
for(i in 1:20){
  print(i)
  train<-window(y,end=c(end(y)[1]-(20-i+1),24))
  test<-window(y,start=c(end(y)[1]-(20-i),1),end=c(end(y)[1]-(20-i),24))
  
  
  print("model 1")
  fit1<-tslm(train ~ trend + season) #Modelo de regresion lineal
  fcast1 <- forecast(fit1,h=npred ,level = 0)
  
  print("model 2")
  fit2<-ets(train,ic="aic") #Modelo de exponencial smoothing sin transformaci?n de Box-Cox
  fcast2 <- forecast(fit2,h=npred ,level = 0)
  
  print("model 3")
  fit3<-HoltWinters(train) #Modelo de clasico de Holtwinter (similar exponencial smoothing) aditivo
  fcast3 <-forecast(fit3,h=npred ,level = 0)
  
  print("model 4")
  fit4<-HoltWinters(train,seasonal = "mult") #Modelo de clasico de Holtwinter multiplicativo
  fcast4 <-forecast(fit4,h=npred ,level = 0)
  
  print("model 5")
  fit5 <- tbats(train) #Modelo TBATS, suele usarse cuando hay multiples patrones ciclicos, podria detectar algunos patrones dificiles en nuestra serie
  fcast5 <- forecast(fit5, h=npred ,level = 0)
  
  print("model 6")
  lam <- BoxCox.lambda(train)
  fit6 <- ets(train, additive=TRUE, lambda=lam) #Modelo exponencial smoothing con transformacion de Box.Cox
  fcast6 <-forecast(fit6,h=npred,level = 0)
  
  print("model 7")
  fit7 <- auto.arima(train) #ARIMA
  fcast7 <-forecast(fit7,h=npred,level = 0)
  
  pred<-data.frame(fcast1$mean,fcast2$mean,fcast3$mean,fcast4$mean,fcast5$mean,fcast6$mean,fcast7$mean)
  
  for(j in 1:length(pred)){
    errordf[i,j]<-mean(abs(pred[,j]-test))
  }
}
print(paste0(Sys.time(),": Fin"))


#Debido al coste que genera la CV, guardamos el resultado por si en alg?n caso por error lo borramos
save(errordf,file= paste0(getwd(),"./data_out/errordf.Rdata"))






#####################################################################
####################### DATA VISUALIZATION ##########################
#####################################################################


rm(list = ls())

load(paste0(getwd(),"./data_out/errordf.Rdata"))


#Analizamos la evoluci?n de MAE de cada modelo tras cada iteracion de la CV
par(mfrow=c(1,1))
for(i in 1:7){
  if(i==1){
  plot(errordf[,1],type="l",lwd=2,col=(i+1),
       ylab="MAE",xlab = "Iteration",
       main="Evoluci\u00f3n de CV para cada modelo")
  }else{
  lines(errordf[,i],col=(i+1),lwd=2)}
}

legend('topleft' ,
       lty=1, col=2:8, cex=0.75,
legend=c("Linear regression","ETS no Box.Cox",
"HoltWinters Add","HoltWinters Mult","TBATS","ETS Box.Cox","ARIMA"))


#Barplot para visualizar media de MAE

m<-colMeans(errordf)
names(m)<-c("Linear regression","ETS no Box.Cox",
            "HoltWinters Add","HoltWinters Mult","TBATS","ETS Box.Cox","ARIMA")

barplot(m,ylab = "Mean of MAE", xlab = "Models",col="blue",
        main="Media de MAE para cada modelo utilizado en CV",ylim=c(0,5))


save(m,file=paste0(getwd(),"./data_out/matrixbarplot.Rdata"))

#El modelo con la media m?s baja en MAE es TBATS


############################################################################
################## FIN DEL SCRIPT: CHOOSING BEST MODEL ##################### 
############################################################################
