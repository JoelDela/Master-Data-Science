# Vemos como funciona la conexión

rm(list=ls())

if(! 'httr' %in% installed.packages()) install.packages('httr',depend=TRUE)

library(httr)

## http://ip-api.com/json/83.58.205.218

response <- GET("http://ip-api.com/json/83.58.205.218")

http_type(response)   #Nos devuelve un OBJETO respuesta

content(response)

## A continuación probamos con Amadeus

rm(list=ls())

if(! 'httr' %in% installed.packages()) install.packages('httr',depend=TRUE)

library(httr)

if(! 'jsonlite' %in% installed.packages()) install.packages('jsonlite',depend=TRUE)

library(jsonlite)

client_id <- 'Rh1ubY7scWANbMA627McQnhvqm2N4saE'
client_id_secret <- 'q714RxuxYLUSS7nG'

body_params <- paste0("grant_type=client_credentials&client_id=",
                      client_id,
                      "&client_secret=",
                      client_id_secret)

body_params

url_params <- "https://test.api.amadeus.com/v1/security/oauth2/token"

auth_response <- POST(url=url_params,
     body=body_params,
     content_type("application/x-www-form-urlencoded"))

http_type(auth_response)

token_params <- content(auth_response)$access_token

query_params <- 'origin=MAD'

headers_params <- paste0('Bearer ',token_params)

url_query_params <- "https://test.api.amadeus.com/v1/shopping/flight-destinations"

flights <- GET(
  url=url_query_params,
  query=query_params,
  add_headers(Authorization=headers_params)
)


http_type(flights)

content(flights,as='text')

getwd()

write(content(flights,as='text'), flights.txt)

f_amadeus_json_parser <- function(amadeusJSON,destfile=NULL){
  library(httr)
  library(jsonlite)
  library(stringr)
  
  JSONtext <- content(amadeusJSON,as='text')
  output <- fromJSON(str_match(JSONtext, "\\[.*?\\]")[1,])
  
  return(output)

}

flightsJSON <- f_amadeus_json_parser(flights)

head(flightsJSON)

write_json(flightsJSON,"flights.json",pretty=TRUE)

