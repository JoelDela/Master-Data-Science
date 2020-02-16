rm(list=ls())

if(! 'rvest' %in% installed.packages()) install.packages('rvest',depend=TRUE)
if(! 'tidyverse' %in% installed.packages()) install.packages('tidyverse',depend=TRUE)

library(rvest)
library(tidyverse)

html <- read_html("https://www.despertaferro-ediciones.com/revistas-historia-militar/catalogo/")

html

## Vamos a hacerlo primero sin pipes
#Para que nos devuelva la clase hay que usar un . y para un atributo se usa #

revistas_css <- html_nodes(x = html,css = ".revista-slider-titulo")

revistas <- unlist(html_text(revistas_css))

revistas[20]

familias <- html %>% html_nodes(css=".revista-slider-familia") %>% html_text

familias[2]

df <- data.frame(revistas=revistas,familias=familias)

df
