# ¿Cuántas personas de la clase tienen una altura por encima de 70? Utilizar una función


library(dslabs)

data("heights")

n.tall<-function(n){
  return(sum(n>=70))
}

ft <- heights %>%
  filter(sex=='Female')%>%
  summarize(n.tall(height))

ft

#Para acceder al número como int y no como dataframe:

ft$`n.tall(height)`

#O

ft %>% .$'n.tall(height'