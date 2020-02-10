#------------------------------------------------------------------------------#
## API_Google: Este codigo descarga la data de Google maps utilizando
## la API Google Places referente a restaurantes, hospitales, etc. que se encuentran
## alrededor de una cierta coordenada.

#------------------------------------------------------------------------------#
## INPUT: datos geolocalizados. 
## OUTPUT: datos de Google maps (data_google_maps).
#------------------------------------------------------------------------------#



#--------------------------------------------------------------------------------------------------------------------------#
#    ___           _          _                    _      ____    ___      ____                           _        
#   |_ _|  _ __   (_)   ___  (_)   ___    _       / \    |  _ \  |_ _|    / ___|   ___     ___     __ _  | |   ___ 
#    | |  | '_ \  | |  / __| | |  / _ \  (_)     / _ \   | |_) |  | |    | |  _   / _ \   / _ \   / _` | | |  / _ \
#    | |  | | | | | | | (__  | | | (_) |  _     / ___ \  |  __/   | |    | |_| | | (_) | | (_) | | (_| | | | |  __/
#   |___| |_| |_| |_|  \___| |_|  \___/  (_)   /_/   \_\ |_|     |___|    \____|  \___/   \___/   \__, | |_|  \___|
#                                                                                                 |___/            
#--------------------------------------------------------------------------------------------------------------------------#





rm(list=ls())

load("latlon.Rdata")



df_to_download<-latlon


APIkey<-"AIzaSyDMfeTSBhfGRgwdt8LPVfwhAtZTnxOdA44"
idx_api<-1

data_google_maps<-data.frame(dist_health=rep(0,nrow(df_to_download)),dist_school=rep(0,nrow(df_to_download)),total_food=rep(0,nrow(df_to_download)),dist_subway=rep(0,nrow(df_to_download)),university=rep(0,nrow(df_to_download)),dist_park=rep(0,nrow(df_to_download)),dist_market=rep(0,nrow(df_to_download)))
cont_inmueble<-1
cont_salud<-1


for(cont_inmueble in 1:nrow(df_to_download)){
  
  print(cont_inmueble)
  
  latlon<-as.numeric(df_to_download[cont_inmueble,c("lat","lon")])
  
  ############## CENTROS DE SALUD Y HOSPITALES ################ 
  
  
  
  salud<-c("Hospital","Centro de salud")
  for(cont_salud in 1:length(salud)){
    search<-salud[cont_salud]
    
    result<-google_places(search_string =  search,
                          location = latlon,
                          key = APIkey,
                          keyword = unlist(strsplit(search," "))[1],
                          language = "es")
    
    
    df_search<-data.frame(name=result$results$name,result$results$geometry$location)
    nearest_search_temp<-df_search[1,]
    dest<-as.numeric(nearest_search_temp[,c("lat","lng")])
    
    result<-google_distance(origins=list(latlon), destinations=list(dest), mode = "walking",key=APIkey)
    nearest_search_temp$distance<-as.numeric(result$rows$elements[[1]]$distance$value)
    if(cont_salud==1){
      nearest_search<-nearest_search_temp
    }else{nearest_search<-rbind(nearest_search,nearest_search_temp)}
  }
  dist_health<-min(nearest_search$distance)
  
  
  
  
  
  ############## ESTACIONES  DE METRO O RENFE ################
  
  # result<-google_places(location = latlon,
  #                       key = APIkey,
  #                       place_type = "subway_station",
  #                       radius = 1000)
  # 
  # 
  # df_search<-data.frame(name=result$results$name,result$results$geometry$location)
  # nearest_search_temp<-df_search[1,]
  # dest<-as.numeric(nearest_search_temp[,c("lat","lng")])
  # 
  # result<-google_distance(origins=list(latlon), destinations=list(dest), mode = "walking",key=APIkey)
  # nearest_search_temp$distance<-as.numeric(result$rows$elements[[1]]$distance$value)
  # 
  # dist_subway<-min(nearest_search_temp$distance)
  
  
  ############ INFORMACION DE UNIVERSIDAD ###################
  
  
  search<-"Universidad"
  
  result<-google_places(search_string =  search,
                        location = latlon,
                        key = APIkey,
                        radius=1000,
                        language = "es",
                        place_type = "university")
  
  
  df_search<-data.frame(name=result$results$name,result$results$geometry$location)
  nearest_search<-df_search[1,]
  
  
  if(length(nearest_search)!=0){
    dest<-as.numeric(nearest_search[,c("lat","lng")])
    
    result<-google_distance(origins=list(latlon), destinations=list(dest), mode = "walking",key=APIkey)
    nearest_search$distance<-as.numeric(result$rows$elements[[1]]$distance$value)
    university<-ifelse(nearest_search$distance<1500,1,0)}else{
      university<-0
    }
  
  
  
  
  
  
  
  
  ############ INFORMACION DE COLEGIOS ################### 
  
  
  
  colegios<-c("Colegio p\u00FAblico","Colegio privado","Colegio concertado") 
  for(cont_colegios in 1:length(colegios)){
    search<-colegios[cont_colegios]
    
    result<-google_places(search_string =  search,
                          location = latlon,
                          key = APIkey,
                          place_type = "school",
                          radius=1000)
    
    
    df_search<-data.frame(name=result$results$name,result$results$geometry$location)
    nearest_search_temp<-df_search[1,]
    dest<-as.numeric(nearest_search_temp[,c("lat","lng")])
    
    result<-google_distance(origins=list(latlon), destinations=list(dest), mode = "walking",key=APIkey)
    nearest_search_temp$distance<-as.numeric(result$rows$elements[[1]]$distance$value)
    if(cont_colegios==1){
      nearest_search<-nearest_search_temp
    }else{nearest_search<-rbind(nearest_search,nearest_search_temp)}
  }
  
  
  dist_school<-min(nearest_search$distance)
  
  
  ############ INFORMACION DE PARQUES CERCANOS ############### 
  
  
  result<-google_places(location = latlon,
                        key = APIkey,
                        place_type = "park",
                        radius = 1000,
                        language = "es")
  
  
  
  df_search<-data.frame(name=result$results$name,result$results$geometry$location)
  nearest_search<-df_search[1,]
  dest<-as.numeric(nearest_search[,c("lat","lng")])
  
  result<-google_distance(origins=list(latlon), destinations=list(dest), mode = "walking",key=APIkey)
  nearest_search$distance<-as.numeric(result$rows$elements[[1]]$distance$value)
  
  dist_park<-min(nearest_search$distance)
  
  
  
  
  ############ INFORMACION DE LOCALES DE COMIDA ############## 
  
  
  next_page <- NULL
  n_it<-1
  total_rest_found <- 0
  while(n_it == 1 | !is.null(next_page)){
    rest_found<-google_places(location = latlon,
                              place_type = "food",
                              key = APIkey,
                              radius = 150,
                              #rankby = "distance", 
                              page_token = next_page)
    #View(rest_found$results)
    
    next_page <-rest_found$next_page_token
    
    total_rest_found<-total_rest_found + length(rest_found$results$vicinity)
    n_it = n_it + 1 
    Sys.sleep(2)
  }
  total_food<-total_rest_found
  
  ############ INFORMACION DE SUPERMERCADOS ################### 
  
  
  
  search<-"Supermercado"
  
  result<-google_places(search_string=search,
                        location = latlon,
                        key = APIkey)
  
  df_search<-data.frame(name=result$results$name,result$results$geometry$location)
  df_search$name<-tolower(df_search$name)
  
  #NOTA: "\u00E1 \u00E9 \u00ED \u00f3 \u00fa" son las codificaciones en unicode de "a e i o u" tildadas
  df_search$name<-chartr("\u00E1 \u00E9 \u00ED \u00f3 \u00fa","a e i o u",df_search$name)
  
  dest<-paste(df_search$lat,df_search$lng)
  dest<-lapply(dest, function(x) as.numeric(strsplit(x, ' ')[[1]]))
  
  result<-google_distance(origins=list(latlon), destinations=dest, mode = "walking",key=APIkey)
  
  df_search$dist<-result$rows$elements[[1]]$distance$value
  df_search<-df_search[order(df_search$dist),]
  
  # load("./R_Programming/Modelo_V1.0/functions/super_punctuations.Rdata")
  
  # super_punctuations(df_search[,c("name","dist")])
  
  
  dist_market<-min(df_search$dist)
  
  
  
  
  
  
  ############ INFORMACION DE BANCOS ################### 
  
  
  
  result<-google_places(location = latlon,
                        key = APIkey,
                        place_type = "bank",
                        radius = 1000,
                        language = "es")
  
  
  df_search<-data.frame(name=result$results$name,result$results$geometry$location)
  nearest_search<-df_search[1,]
  dest<-as.numeric(nearest_search[,c("lat","lng")])
  
  result<-google_distance(origins=list(latlon), destinations=list(dest), mode = "walking",key=APIkey)
  nearest_search$distance<-as.numeric(result$rows$elements[[1]]$distance$value)
  
  dist_bank<-min(nearest_search$distance)
  
  
  
  
  
  
  
  
  
  ############## SAVING DATA ################### 
  
  data_google_maps$dist_health[cont_inmueble]<-dist_health
  data_google_maps$dist_subway[cont_inmueble]<-dist_subway
  data_google_maps$total_food[cont_inmueble]<-total_food
  data_google_maps$dist_school[cont_inmueble]<-dist_school
  data_google_maps$university[cont_inmueble]<-university
  data_google_maps$dist_market[cont_inmueble]<-dist_market
  data_google_maps$dist_park[cont_inmueble]<-dist_park
  data_google_maps$dist_bank[cont_inmueble]<-dist_bank
  
}


save(data_google_maps,file=paste0(getwd(),"/data_out/data_google.Rdata"))
# load(paste0(getwd(),"/data_out/data_google.Rdata"))





#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#



