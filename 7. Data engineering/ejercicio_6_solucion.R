################################
## 18 M�ster Data Science Madrid
## Data Engineering con R
################################
## Ejercicio 6
################################

## Usaremos el paquete rvest para scrappear el catálogo de revistas de Desperta Ferro
## https://www.despertaferro-ediciones.com
## 
## Generaremos un data frame con el t�tulo de las revistas y la colecci�n a la que pertenecen

## Limpieza del entorno

rm(list=ls())

## Instalamos y cargamos las librer�as necesarias

if(! "rvest" %in% installed.packages()) install.packages("rvest", depend = TRUE)
if(! "xopen" %in% installed.packages()) install.packages("xopen", depend = TRUE)
if(! "tidyverse" %in% installed.packages()) install.packages("tidyverse", depend = TRUE)

library(rvest)
library(xopen)
library(dplyr)

## Guardamos la URL a scrappear y la abrimos con xopen para comprobar

url <- "https://www.despertaferro-ediciones.com/revistas-historia-militar/catalogo/"

xopen(url)

## Extraemos el c�digo HTML de la página web

html <- read_html(url)

html

## Extraemos el t�tulo de las revistas accediento a la clase CSS

revistas_css <- html_nodes(html, css = ".revista-slider-titulo")
revistas <- unlist(html_text(revistas_css))

## Extraemos la colecci�n de cada revista accediento a la clase CSS, esta vez mediante pipes de dplyr

coleccion <- html %>% html_nodes(css = ".revista-slider-familia") %>% html_text()

## Creamos el data frame con la informaci�n de los vectores anteriores

df <- data.frame(revistas = revistas, coleccion = coleccion, stringsAsFactors = FALSE)

## Comprobamos el data frame final

head(df)
