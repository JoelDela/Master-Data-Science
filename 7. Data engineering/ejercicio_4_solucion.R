################################
## 18 Máster Data Science Madrid
## Data Engineering con R
################################
## Ejercicio 4
################################

## Usaremos la API de Twitter https://developer.twitter.com/
## para explorar los tweets sobre un hashtag concreto
## 
## Usaremos la librería rtweet: https://rtweet.info/
##
## Prerrequisitos: 
##   Tener cuenta de Twitter
##   Solicitar una cuenta de desarrollador y que sea aprobada por Twitter: https://developer.twitter.com/en/apply-for-access
##     Cumplimentaremos la información que nos solicitan, 
##     y para facilitar la aprobación, indicaremos que somos estudiantes y que el objetivo es hacer pruebas con su API
##   Una tengamos la cuenta aprobada, crearemos un anueva app: https://developer.twitter.com/en/apps

## Limpieza del entorno

rm(list=ls())

## Instalamos y cargamos el paquete rteet

if(! "rtweet" %in% installed.packages()) install.packages("rtweet", depend = TRUE)
if(! "tidyverse" %in% installed.packages()) install.packages("tidyverse", depend = TRUE)

library(rtweet)

## Guardamos los valores de las keys y tokens para la autenticación
## IMPORTANTE: cambiarlos por vuestro propios valores

api_key <- "qOLzWj7gqanZPwKtEfW427eMT"
api_secret_key <- "YUAAsSVmWnpyBieEWTmoSmVZ1kQ8vTo7qOP6kbSYRdP9j7z9Xm"

access_token <- "1115180580549869574-vp8PsoadZLCkDm6FfNIw3bsjcoKRSu"
access_token_secret <- "OqGGznaYx2PIcjqtbtCh1E3hfldB2ofmGrzLGlu4fpwVU"

twitter_dev_app <- "master_data_science"

## Autenticamos con Twitter y guardamos el token ()

token <- create_token(
  app = twitter_dev_app,
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret
)

token

## Buscamos 100 tweets sobre un hashtag

hashtag <- "#datascience"

rt <- search_tweets(
  hashtag, 
  n = 100, 
  include_rts = FALSE,
  type = "popular",
  token = token
)

rt

## Extra: Word Cloud
## Basado en https://towardsdatascience.com/create-a-word-cloud-with-r-bde3e7422e8a

## Librerías necesarias
if(! "wordcloud2" %in% installed.packages()) install.packages("wordcloud2", depend = TRUE)
if(! "tm" %in% installed.packages()) install.packages("tm", depend = TRUE)

library(wordcloud2)
library(tm)

## Creamos un vector con el texto de los tweets

text <- rt$text

# Creamos un corpus apartr del vector anterior

docs <- Corpus(VectorSource(text))            

# Limpiamos el texto del corpus

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, removeWords, c(stopwords("spanish"),stopwords("english"),"abdsc"))

## Creamos la term document matrix
## y preparamos el data frame para el word cloud

dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix), decreasing = TRUE) 
df <- data.frame(word = names(words), freq = words)
head(df)

## Visualizamos el word cloud

wordcloud2(data = df, size = 1.6, color = "random-dark")

