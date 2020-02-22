################################
## 18 Máster Data Science Madrid
## Data Engineering con R
################################
## Ejercicio 3
################################

## Obtener la información de nuestra IP mediante la API de https://ip-api.com/
## A su vez, obtendremos nuestra IP mediante la API de https://api.ipify.org

## Limpieza del entorno

rm(list=ls())

## Instalamos y cargamos el paquete httr
if(! "httr" %in% installed.packages()) install.packages("httr", depend = TRUE)

library(httr)

## Optenemos nuestra IP con una llamada GET a la api ipfy

ipJSON <- GET(url = "https://api.ipify.org/?format=json")

## Comprobamos el formato del objeto devuelto por la API

http_type(ipJSON)

## Comprobamos su contenido

content(ipJSON, format = "text")

## Guardamos nuestra IP en una variable local

ip <- content(ipJSON)$ip

## Mediante la API de ip-api, obtenemos nuestra geolocalización con una llamada GET

## Generamos la URL

ipURL <- paste0("http://ip-api.com/json/", ip)

## Realizamos la llamada GET a la API

ipApiJSON <- GET(url = ipURL)

## Comprobamos el formato del objeto devuelto por la API

http_type(ipApiJSON)

## Comprobamos su contenido

content(ipApiJSON, format = "text")

