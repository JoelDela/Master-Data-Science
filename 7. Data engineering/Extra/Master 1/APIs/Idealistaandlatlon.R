#-------------------------------------------------------------------------------#

# IDEALISTA + LATLON: Este algoritmo devuelve informacion de inmuebles que se
# se encuentren alrededor de unas coordenadas.

# INPUT:
# 1) token obtenido con el codigo authidealista.R
# 2) latitud y longitud de la direccion a localizar

# OUTPUT:
# 50 viviendas alrededor de la vivienda


#-------------------------------------------------------------------------------



#------------------------------------------------------------------------------------------------------------------------------#
#  ___           _          _                    _      ____    ___     _       _                  _   _         _           
# |_ _|  _ __   (_)   ___  (_)   ___    _       / \    |  _ \  |_ _|   (_)   __| |   ___    __ _  | | (_)  ___  | |_    __ _ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)     / _ \   | |_) |  | |    | |  / _` |  / _ \  / _` | | | | | / __| | __|  / _` |
#  | |  | | | | | | | (__  | | | (_) |  _     / ___ \  |  __/   | |    | | | (_| | |  __/ | (_| | | | | | \__ \ | |_  | (_| |
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   /_/   \_\ |_|     |___|   |_|  \__,_|  \___|  \__,_| |_| |_| |___/  \__|  \__,_|
#------------------------------------------------------------------------------------------------------------------------------#





rm(list=ls())



APIkey<-"AIzaSyDMfeTSBhfGRgwdt8LPVfwhAtZTnxOdA44"

#geolocalizamos la direccion de la cual queremos extraer la informacion de inmuebles
address<-"paseo delicias 81, madrid"
result<-google_geocode(address,key=APIkey)
latlon<-as.numeric(result$results$geometry$location)
latlon<-data.frame(lat=latlon[1],lon=latlon[2])


df_activo<-data.frame(address=address,latlon)





source("./APIs/authidealista.R")

url<-paste0("http://api.idealista.com/3.5/es/search?center=",latlon$lat,",",latlon$lon,"&country=es&maxItems=100&numPage=1&distance=500&propertyType=homes&operation=sale")

req <- httr::POST(url, httr::add_headers("Authorization" = token))


json <- httr::content(req)
# json


x<-json$elementList[[1]]
y<-json$elementList[[2]]


df_idealista<-data.frame(propertyCode=0,price=0,size=0,floor=0,
                         lat=0,lon=0,address=0,neighborhood=0,district=0,
                         municipality=0,province=0,
                         country=0)


for(i in 1:length(json$elementList)){
home<-json$elementList[[i]]

df_idealista[i,"propertyCode"]<-home$propertyCode
df_idealista[i,"price"]<-home$price
df_idealista[i,"size"]<-home$size
df_idealista[i,"floor"]<-ifelse(length(home$floor)!=0,home$floor,NA)
df_idealista[i,"lat"]<-home$latitude
df_idealista[i,"lon"]<-home$longitude
df_idealista[i,"address"]<-home$address
df_idealista[i,"neighborhood"]<-home$neighborhood
df_idealista[i,"district"]<-home$district
df_idealista[i,"municipality"]<-home$municipality
df_idealista[i,"province"]<-home$province
df_idealista[i,"country"]<-home$country
}
df_idealista

# save(df_activo,file = paste0(getwd(),"/data_out/df_activo.Rdata"))
# save(df_idealista,file = paste0(getwd(),"/data_out/df_idealista.Rdata"))



#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#