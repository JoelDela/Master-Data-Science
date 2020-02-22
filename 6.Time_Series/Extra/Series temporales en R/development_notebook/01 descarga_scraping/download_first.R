############################################################################
############## INICIO DEL SCRIPT: DOWNLOAD DATA FIRST TIME ################# 
### ESTE ES EL PRIMER SCRIPT DEL ALGORITMO, SE UTILIZA PARA DESCARGAR EN ### 
### PRIMERA INSTANCIA UN ANYO DE DATOS. LOS DATOS SON GUARDADOS EN UN CSV ###
############################################################################


rm(list=ls())



from<-NULL-366 #Selecciono la fecha de inicio, un anyo menos a la fecha actual en este caso
to<-NULL #Fecha del dia de hoy



for(i in 1:(to-from)){
  print(i)
  date<-from+(i-1)
 
  source(paste0(getwd(),NULL))
  
  #El siguiente if, actualiza los datos
  if(i==1){
    mydat<-mydat_temp
  }else{
    mydat<-rbind(mydat,mydat_temp)}
}

#Eliminamos las variables nulas que provienen de la descarga
mydat$V7<-NULL
mydat$V5<-NULL #precio de portugal

#Arreglamos los datos y anadimos una columna con el datetime del precio
names(mydat)<-c("year","month","day","hour","price_spain")
mydat$datetime<-as.POSIXct(paste0(NULL,"-",NULL,"-",NULL," ",NULL,":00:00"),format="%Y-%m-%d %H:%M:%S",tz="UTC")

mydat<-mydat[which(!is.na(mydat$datetime)),]

#Guardamos los datos en un CSV
write.csv(mydat,file = paste0(getwd(),"./data_in/energy.csv"))



############################################################################
################ FIN DEL SCRIPT: DOWNLOAD DATA FIRST TIME ################## 
############################################################################