# Vemos como funciona la conexión

rm(list=ls())

if(! 'httr' %in% installed.packages()) install.packages('httr',depend=TRUE)

library(httr)

## http://ip-api.com/json/83.58.205.218

response <- GET("http://ip-api.com/json/83.58.205.218")

http_type(response)   #Nos devuelve un OBJETO respuesta

content(response)

## Vamos a probar con las API ahora. Primero la de twitter

rm(list=ls())

if(! 'rtweet' %in% installed.packages()) install.packages('rtweet',depend=TRUE)

library(rtweet)

api_key <- "qOLzWj7gqanZPwKtEfW427eMT"
api_secret_key <- "YUAAsSVmWnpyBieEWTmoSmVZ1kQ8vTo7qOP6kbSYRdP9j7z9Xm"

access_token <- "1115180580549869574-vp8PsoadZLCkDm6FfNIw3bsjcoKRSu"
access_token_secret <- "OqGGznaYx2PIcjqtbtCh1E3hfldB2ofmGrzLGlu4fpwVU"

token <- create_token(
  app = "master_data_science",
  consumer_key=api_key,
  consumer_secret=api_secret_key,
  access_token=access_token,
  access_secret=access_token_secret
  )

token

hashtag <- "#OTDirecto14F" 

rt <- search_tweets(
  hashtag,
  n=100,
  include_rts=FALSE,
  type='popular',
  token=token
)

flw <- get_followers(
  755355310026551296,
  n=1000,
  page="-1",
  retryonratelimit=FALSE,
  parse=TRUE,
  verbose=TRUE,
  token=NULL
)





