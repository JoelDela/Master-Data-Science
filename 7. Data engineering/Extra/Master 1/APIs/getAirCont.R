#----------------------------------------------------------------------------------------#
# getAirCont.R: es una funcion que permite obtener el grado de contaminacion de una
# latitud y longitud

# Input:   APIkey        <- clave de la api, se obtiene a partir de aqui: http://aqicn.org/api/es/ 
#          lat
#          long
# Output:  airContIndex  <- Indice de contaminacion del aire. 0-50 Good,
#                           51-100 Moderate, 101-150 Unhealthy for Sensitive Groups,
#                           151-200 Unhealthy, 201-300 Very Unhealthy,300+ Hazardous.
#                           Si no se ha podido realizar la peticion de forma correcta, 
#                           muestra por pantalla un mensaje de error y devuelve NULL
#----------------------------------------------------------------------------------------#




#----------------------------------------------------------------------------------------------------------------------------------------------#
#  ___           _          _                  ____                   _                         _                          _                 
# |_ _|  _ __   (_)   ___  (_)   ___    _     / ___|   ___    _ __   | |_    __ _   _ __ ___   (_)  _ __     __ _    ___  (_)   ___    _ __  
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | |      / _ \  | '_ \  | __|  / _` | | '_ ` _ \  | | | '_ \   / _` |  / __| | |  / _ \  | '_ \ 
#  | |  | | | | | | | (__  | | | (_) |  _    | |___  | (_) | | | | | | |_  | (_| | | | | | | | | | | | | | | (_| | | (__  | | | (_) | | | | |
# |___| |_| |_| |_|  \___| |_|  \___/  (_)    \____|  \___/  |_| |_|  \__|  \__,_| |_| |_| |_| |_| |_| |_|  \__,_|  \___| |_|  \___/  |_| |_|
#----------------------------------------------------------------------------------------------------------------------------------------------#








APIkey <- "d62d189b3d1c1cbb1764e641060c5269ce6502ea"

lat    <-39.8628316
long   <- -4.02732309999999
lat    <- 40.422474
long   <- -3.714206


getAirCont <- function(APIkey, lat, long){ 

  airContIndex <- NULL 
   
  url <- paste("https://api.waqi.info/feed/geo:", lat , ";", long , "/?token=", APIkey , sep = "")  #/feed/geo::lat;:lng/?token=:token
  req <- httr::GET(url)
  
  # Comprobar que status 200
  if(req$status_code == 200){
    airContIndex <- httr::content(req)$data$aqi
  }else{
    cat("ERROR: Something went wrong in the request. Status code:", req$status_cod)
  }
  return(airContIndex)
}

getAirCont(APIkey,lat,long)



#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#