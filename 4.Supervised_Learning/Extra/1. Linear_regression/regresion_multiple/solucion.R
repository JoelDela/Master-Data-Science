rm(list=ls())


#Lectura de datos
my_data<-read.table("./data_in/peso_data.txt", header=T) #Lee los datos del archivo

my_data_male<-my_data[which(my_data$sexo=="male"),]


#Ajustamos modelos
y<-my_data_male$peso #la variable respuesta es el Peso
x1<-my_data_male$altura #variable x1 determinada por Altura
x2<-my_data_male$cintura #variable x2 determinada por Cintura
x3<-my_data_male$cadera #variable x3 determinada por Cadera


model1<-lm(y~x1)
model2<-lm(y~x2)
model3<-lm(y~x3)

summary(model1)
summary(model2)
summary(model3)


#Realizamos una visualizacion
par(mfrow = c( 1, 3 ))

plot(x1,y,col=4,xlab="Altura",ylab="Peso", main="Peso vs. Altura")
abline(model1,col=2)
plot(x2,y,col=4,xlab="Cintura",ylab="Peso", main="Peso vs. Cintura")
abline(model2,col=2)
plot(x3,y,col=4,xlab="Cadera",ylab="Peso",  main="Peso vs. Cadera")
abline(model3,col=2)
title(main="Rectas de Regresi\u00f3n Lineal para cada variable explicativa",
      outer=T,cex.main=2)



#Regresion lineal multiple

model4<-lm(peso~altura+cintura,data = my_data_male)
model5<-lm(peso~altura+cadera,data = my_data_male)
model6<-lm(peso~cintura+cadera,data = my_data_male)
model7<-lm(peso~altura+cintura+cadera,data = my_data_male)


summary(model4)
summary(model5)
summary(model6)
summary(model7)


# #Hacemos un grafico en 4D para sexo masculino y femenino con las variables altura y cintura
p <- plot_ly(my_data, x = ~altura, y = ~cintura, z = ~peso ,
             color = ~sexo, colors = c('red', 'blue')) %>%
  add_markers() %>%
  plotly::layout(scene = list(xaxis = list(title = 'altura'),
                      yaxis = list(title = 'cintura'),
                      zaxis = list(title = 'peso')))
p




#Hacemos un grafico en 3D para cintura y cadera a?adiendo el plano
p <- plot_ly(my_data_male, 
             x = ~cintura, 
             y = ~cadera, 
             z = ~peso,
             type = "scatter3d", 
             mode = "markers")



#Graph Resolution (more important for more complex shapes)
graph_reso <- 0.05

#Setup Axis
axis_x <- seq(min(my_data_male$cintura), max(my_data_male$cintura), by = graph_reso)
axis_y <- seq(min(my_data_male$cadera), max(my_data_male$cadera), by = graph_reso)

#Sample points
lm_surface <- expand.grid(cintura = axis_x,cadera = axis_y,KEEP.OUT.ATTRS = F)




lm_surface$peso <- predict(model6, newdata = lm_surface,type = "response")
lm_surface <- acast(lm_surface, cadera ~ cintura, value.var = "peso") #y ~ x



p<-  add_trace(p = p,
               z = lm_surface,
               x = axis_x,
               y = axis_y,
               type = "surface")
p


#Prediccion

predictorvalues<-function(x1,x2,x3,model, type){
  if (is.character(type)==T){
    new<-data.frame(altura=x1,cintura=x2,cadera=x3)
    predict.lm(model,new,interval=type)
  }
  else print("Debe introducir una variable del tipo 'character', como por ejemplo \n 'confidences'") #condicionamiento de la función
}

predictorvalues(66,37.95,43,model7,"confidence")

predict(modelo, dataframe_nuevos_datos,tipo_estimacion)
#Predecir el sexo de una persona de acuerdo a los datos


#TAREA

