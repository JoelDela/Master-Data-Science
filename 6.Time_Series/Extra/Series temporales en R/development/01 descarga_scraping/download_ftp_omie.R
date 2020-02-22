############################################################################
################ INICIO DEL PROC: DOWNLOAD FROM FTP OMIE ###################
##### ESTE ES SOLO UN PROC QUE DESCARGA LOS FTP DE OMIE DADA UNA FECHA #####
############################################################################



date<-gsub("-","",date)
res<-0
class(res)<-"try-error"
idx<-1

#Hemos notado que en algunos casos, la "extensi?n" de la URL varia en el n?mero final (.1, .2, .3, etc)
#Creemos que es debido a versiones de los precios que actualiza la OMIE y para diferenciarlos coloca .1 (version 1 por ejemplo)
#Por tanto, el siguiente bucle no termina hasta que la URL no devuelva un valor que no sea "try-error"

while(class(res)=="try-error"){
  name_of_file<-paste0("marginalpdbc_",date,".",idx)
  res<-try(mydat_temp<-data.table::fread(paste0('http://www.omie.es/datosPub/marginalpdbc/',name_of_file),showProgress = F),silent = T)
  idx<-idx+1
}
mydat_temp<-as.data.frame(mydat_temp)
mydat_temp<-mydat_temp[,1:7]


############################################################################
################## FIN DEL PROC: DOWNLOAD FROM FTP OMIE ####################
############################################################################