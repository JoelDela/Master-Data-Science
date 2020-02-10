#--------------------------------------------------------------------------------------------------#
# google_geocode.R: Este codigo ejecuta la limpieza de la direccion que proviene del web scraping
# y la geolocalizacion de la direccion
# Realiza una llamada a las funciones del codigo  "./Web_scraping/clean_data_scrap.R" que se utilizan
# para extraer la direccion mas limpia

#INPUT: dataset con direccion a limpiar y geolocalizar

#OUTPUT: dataset con columna address_format

#--------------------------------------------------------------------------------------------------#




#--------------------------------------------------------------------------------------------------#
#  ___           _          _                  ____                                     _        
# |_ _|  _ __   (_)   ___  (_)   ___    _     / ___|   ___    ___     ___    ___     __| |   ___ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | |  _   / _ \  / _ \   / __|  / _ \   / _` |  / _ \
#  | |  | | | | | | | (__  | | | (_) |  _    | |_| | |  __/ | (_) | | (__  | (_) | | (_| | |  __/
# |___| |_| |_| |_|  \___| |_|  \___/  (_)    \____|  \___|  \___/   \___|  \___/   \__,_|  \___|
#--------------------------------------------------------------------------------------------------#




rm(list=ls())

#Mi apikey
APIkey<-NULL

#cargamos las funciones auxiliares
source("./Web_scraping/clean_data_scrap.R")

#leemos el fichero en output
load(list.files("./data_out",full.names = T,pattern=".Rdata"))


#extraemos la direccion a limpiar y geolocalizar
address <- data_scrap$address


#---------------- Limpieza de la direccion address ----------------------#
address <- tolower(NULL)
address <- chartr(NULL,NULL,address) #quitamos tildes

#obtenemos el tipo de vivienda
Tipo <- getTipo(NULL)

DirClean_DirCompleta <- Get_DirClean_DirCompleta(NULL)

DirClean <- DirClean_DirCompleta[[1]]

address_complete <- paste0(DirClean, ", ",data_scrap$localidad)

#---------------- Fin Limpieza de la direccion address ----------------------#


#Se realiza el sigueinte while para que realice al menos tres intentos
result<-google_geocode(NULL,key=NULL)
status<-result$status



#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#


