################################
## 18 Máster Data Science Madrid
## Data Engineering con R
################################
## Ejercicio 5
################################

## Usaremos la API de Amadeus for Developers https://developers.amadeus.com/ 
## Flight Insspiration Search https://developers.amadeus.com/self-service/category/air/api-doc/flight-inspiration-search
## para obtener una lista de vuelos baratos propuestos por Amadeus con salida en Madrid (MAD)
## 
## Seguiremos los pasos descritos en https://developers.amadeus.com/get-started/category?id=80&durl=335&parentId=NaN
## Nos apoyaremos en la documentación de Postman como referencia: https://documenter.getpostman.com/view/2672636/RWEcPfuJ?version=latest
## Usaremos el paquete httr para gestionar las llamadas POST y GET
## Usaremos jsonlite para procesar el contenido en formato JSON
##
## Prerrequisitos: 
##   Registrarnos de manera gratuita: https://developers.amadeus.com/register
##   Una vez registrados, crearemos un anueva app en nuestro workspace: https://developers.amadeus.com/my-apps
##
## Collection de POstman: https://documenter.getpostman.com/view/2672636/RWEcPfuJ?version=latest

## Limpieza del entorno

rm(list=ls())

## Instalamos y cargamos las librerías necesarias

if(! "httr" %in% installed.packages()) install.packages("httr", depend = TRUE)
if(! "jsonlite" %in% installed.packages()) install.packages("jsonlite", depend = TRUE)

library(httr)
library(jsonlite)

## Obtenemos el authorization token enviando nuestras claves de cliente mediante llamada POST
## IMPORTANTE: cambiarlos por vuestro propios valores

client_id <- "G30BtJINATBPdYYFWpc4bFOr4l8awjYV"
client_secret <- "sj2WESVhxiupdaM6"

body_params <- paste0("grant_type=client_credentials&client_id=",
                      client_id,
                      "&client_secret=",
                      client_secret)

url_params <- "https://test.api.amadeus.com/v1/security/oauth2/token"

parameter_response <- POST(url = url_params,
                           body = body_params,
                           content_type("application/x-www-form-urlencoded"))

## Comprobamos el formato del objeto devuelto por la API

http_type(parameter_response)

httr::content(parameter_response)

## Salvamos el access token para usarlo en las llamadas posteriores

token_params <- httr::content(parameter_response)$access_token

## Usando la API Flight Inspiration Search, obtenemos inspiración para vuelos baratos desde Madrid
## https://developers.amadeus.com/self-service/category/air/api-doc/flight-inspiration-search/api-reference

## Primer parámetro: origin

query_params <- "origin=MAD"

## Segundo parámetro: nuestro access token

headers_params <- paste0("Bearer ",
                         token_params)

## URL de la API

inspirationURL <- "https://test.api.amadeus.com/v1/shopping/flight-destinations"

## Llamada GET a la API

flights <- GET(url = inspirationURL,
               query = query_params,
               add_headers(Authorization = headers_params))

## Comprobamos el formato del objeto devuelto por la API

http_type(flights)

## Nos da error el parsearlo automáticamente

httr::content(flights, as = "parsed")

## Extraemos el texto plano del contenido

httr::content(flights, as = "text")

getwd()
write(httr::content(flights, as = "text"), "flights.txt")

## Función auxiliar para convertir el objeto vnd.amadeus+json en JSON estándar

f_amadeus_json_parser <- function(amadeusJSON, destfile = NULL) {
  
  library(httr)
  library(jsonlite)
  library(stringr)

  amadeusJSONtext <- httr::content(amadeusJSON, as = "text")
  output <- fromJSON(str_match(amadeusJSONtext, "\\[.*?\\]")[1,])
  
  return(output)
  
}

## Convertimos el objeto y lo guardamos en un fichero JSON

flightsJSON <- f_amadeus_json_parser(flights)
head(flightsJSON)
str(flightsJSON)

write_json(flightsJSON, "flights.json",  pretty = TRUE)


