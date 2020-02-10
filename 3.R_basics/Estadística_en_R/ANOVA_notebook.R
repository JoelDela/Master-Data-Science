#=====================================================#
#     _      _   _    ___   __     __     _    
#    / \    | \ | |  / _ \  \ \   / /    / \   
#   / _ \   |  \| | | | | |  \ \ / /    / _ \  
#  / ___ \  | |\  | | |_| |   \ V /    / ___ \ 
# /_/   \_\ |_| \_|  \___/     \_/    /_/   \_\
#=====================================================#


#Supongase que se un estudio quiere comprobar si existe una diferencia significativa
# entre el averages de goles de los jugadores de futbol dependiendo de la posicion
# en la que juegan. En caso de que exista diferencia se quiere saber que posiciones
# difieren del resto. La siguiente tabla contiene una muestra de jugadores seleccionados
# aleatoriamente.

rm(list=ls())


datos<-read.csv(NULL)



# Se identifica el numero de grupos y cantidad de observaciones por grupo para
# determinar si es un modelo equilibrado. Tambien se calculan la media y desviacion
# tipica de caga grupo.

table(NULL)
#DC: Delantero centro
#MO: Medio ofensivo
#MP: Media punta
#P: Puntero

aggregate(NULL ~ NULL, data = datos, FUN = NULL)

aggregate(NULL ~ NULL, data = datos, FUN = NULL)


#Dado que el numero de observaciones por grupo no es constante, se trata de un modelo
# no equilibrado. Es importante tenerlo en cuenta cuando se comprueben las condiciones
#de normalidad y homocedasticidad (s1=s2=s3=s4).
# La representacion grafica mas util antes de realizar un ANOVA es el modelo Box-Plot.


ggplot(data = datos, aes(x = NULL, y = NULL, color = NULL)) +
  geom_boxplot() +
  theme_bw()

# Este tipo de representacion permite identificar de forma preliminar si existen asimetrias,
# datos atipicos o diferencia de varianzas. En este caso, los 4 grupos parecen seguir una
# distribucion simetrica. En el nivel iF se detectan algunos valores extremos que habra que
# estudiar con detalle por si fuese necesario eliminarlos. El tamaño de las cajas es similar
# para todos los niveles por lo que no hay indicios de falta de homocedasticidad (s1=s2=s3=s4).
# La representacion grafica mas util antes de realizar un ANOVA es el modelo Box-Plot.






# independencia:

# El tamaño total de la muestra es < 10% de la poblacion de todos los jugadores de la liga.
# Los grupos (variable categorica) son independientes entre ellos ya que se ha hecho un
# muestreo aleatorio de jugadores de toda la liga (no solo de un mismo equipo).

# Distribucion normal de las observaciones: La variable cuantitativa debe de distribuirse
# de forma normal en cada uno de los grupos. El estudio de normalidad puede hacerse de forma
# grafica (qqplot) o con test de hipotesis. 


par(mfrow = c(2,2))
qqnorm(datos[datos$posicion == "P","average"], main = "P")
qqline(datos[datos$posicion == "P","average"])
qqnorm(datos[datos$posicion == "MO","average"], main = "MO")
qqline(datos[datos$posicion == "MO","average"])
qqnorm(datos[datos$posicion == "DC","average"], main = "DC")
qqline(datos[datos$posicion == "DC","average"])
qqnorm(datos[datos$posicion == "MP","average"], main = "MP")
qqline(datos[datos$posicion == "MP","average"])


par(mfrow = c(1,1))


# Se puede emplear el test de Kolmogorov-Smirnov simple o con la correccion de Lilliefors.
# La funcion en R se llama lillie.test() y se encuentra en el paquete nortest.



by(data = datos,iNDiCES = datos$posicion,FUN = function(x){ lillie.test(NULL)})


#Los test de hipotesis no muestran evidencias de falta de normalidad. 


# Varianza constante entre grupos (homocedasticidad):
#   
#   Dado que hay un grupo (DC) que se encuentra en el limite para aceptar que se distribuye
# de forma normal, el test de Fisher y el de Bartlett no son recomendables. En su lugar es
# mejor emplear un test basado en la mediana test de Levene o test de Fligner-Killeen.

fligner.test(NULL ~ factor(NULL),datos)


leveneTest(NULL ~ factor(NULL),datos,center = "median")


# No hay evidencias significativas de falta de homocedasticidad en ninguno de los dos test.

# El estudio de las condiciones puede realizarse previo calculo del ANOVA, puesto que si
# no se cumplen no tiene mucho sentido seguir adelante. Sin embargo la forma mas adecuada
# de comprobar que se satisfacen las condiciones necesarias es estudiando los residuos del
# modelo una vez generado el ANOVA. R permite graficar los residuos de forma directa con la
# funcion plot(objeto anova).

anova <- aov(NULL ~ NULL)
summary(anova)


plot(anova)



# Dado que el p-value es superior a 0.05 no hay evidencias suficientes para considerar
# que al menos dos medias son distintas. La representacion grafica de los residuos no
# muestra falta de homocedasticidad (grafico 1) y en el qqplot los residuos se distribuyen
# muy cercanos a la linea de la normal (grafico 2).



#===========================================================================#
#  _____               _        _      _   _    ___   __     __     _    
# | ____|  _ __     __| |      / \    | \ | |  / _ \  \ \   / /    / \   
# |  _|   | '_ \   / _` |     / _ \   |  \| | | | | |  \ \ / /    / _ \  
# | |___  | | | | | (_| |    / ___ \  | |\  | | |_| |   \ V /    / ___ \ 
# |_____| |_| |_|  \__,_|   /_/   \_\ |_| \_|  \___/     \_/    /_/   \_\
#===========================================================================#




