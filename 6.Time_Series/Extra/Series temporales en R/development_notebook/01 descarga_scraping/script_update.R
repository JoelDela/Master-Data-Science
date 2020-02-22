############################################################################
################ INICIO DEL SCRIPT: UPDATE DATA EVERY DAY ##################
#### ESTE SCRIPT ES PARA QUE SE EJECUTE AUTOM?TICAMENTE A LAS 00:00 PARA ### 
###### ACTUALIZAR EL CSV energy.csv CON LOS PRECIOS DE LA ENERGIA ##########
###### ES NECESARIO USAR EL "Addins" DEL PAQUETE "taskscheduleR" ###########
####### O UTILIZAR UN PROGRAMADOR DE TAREAS SI USTED USA WINDOWS ###########
############ M?S INFORMACI?N, EN LEEME_SCHEDULER.TXT  ######################
############################################################################



#if (!require("taskscheduleR")){install.packages("taskscheduleR")} #(Ejecutar solo la primera vez al ejecutar este script si desea actualizar los datos periodicamente)

rm(list = ls())

setwd("C:/Users/henavarr/Downloads")

date<-Sys.Date()

source(paste0(getwd(),"./download_ftp_omie.R"))

mydat_temp$V7<-NULL
mydat_temp$V5<-NULL
mydat_temp$date<-as.Date(paste0(mydat_temp[,1],"-",mydat_temp[,2],"-",mydat_temp[,3]))

#Actualizaci?n del dataset
write.table(mydat_temp, file=paste0(getwd(),"./data_in/energyfirst.csv"), append=T, row.names=F, col.names=F,sep=",")


############################################################################
################ FIN DEL SCRIPT: UPDATE DATA EVERY DAY #####################
############################################################################
