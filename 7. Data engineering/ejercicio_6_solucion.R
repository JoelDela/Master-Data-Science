################################
## 18 Máster Data Science Madrid
## Data Engineering con R
################################
## Ejercicio 6
################################

## Usaremos el paquete rvest para scrappear el catÃ¡logo de revistas de Desperta Ferro
## https://www.despertaferro-ediciones.com
## 
## Generaremos un data frame con el título de las revistas y la colección a la que pertenecen

## Limpieza del entorno

rm(list=ls())

## Instalamos y cargamos las librerías necesarias

if(! "rvest" %in% installed.packages()) install.packages("rvest", depend = TRUE)
if(! "xopen" %in% installed.packages()) install.packages("xopen", depend = TRUE)
if(! "tidyverse" %in% installed.packages()) install.packages("tidyverse", depend = TRUE)

library(rvest)
library(xopen)
library(dplyr)

## Guardamos la URL a scrappear y la abrimos con xopen para comprobar

url <- "https://www.despertaferro-ediciones.com/revistas-historia-militar/catalogo/"

xopen(url)

## Extraemos el código HTML de la pÃ¡gina web

html <- read_html(url)

html

## Extraemos el título de las revistas accediento a la clase CSS

revistas_css <- html_nodes(html, css = ".revista-slider-titulo")
revistas <- unlist(html_text(revistas_css))

## Extraemos la colección de cada revista accediento a la clase CSS, esta vez mediante pipes de dplyr

coleccion <- html %>% html_nodes(css = ".revista-slider-familia") %>% html_text()

## Creamos el data frame con la información de los vectores anteriores

df <- data.frame(revistas = revistas, coleccion = coleccion, stringsAsFactors = FALSE)

## Comprobamos el data frame final

head(df)
