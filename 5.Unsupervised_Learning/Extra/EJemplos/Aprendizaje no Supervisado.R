## -------------------------------------------------------------------------
## SCRIPT: Aprendizaje no Supervisado.R
## CURSO: Master en Data Science
## SESI??N: Aprendizaje no Supervisado
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------


##### AGRUPACI??N: distancias o m??tricas    #######
##################################################
# 
# jer??rquico: agrupando / dividiendo de dos a dos, considerando distancias (habr?? que definir que es la distancia)
# basado en centroides: se fijan unos centros y los objetos se asignan al centro mas cercano
# modelos: gr??ficos de densidad para buscar una funci??n estad??stica que se asemeje a esos gr??ficos
# 
# Problema: que estas t??cnicas de agrupaci??n son iterativos. Big data -> Big problem
# cuando hay muchos datos, se hace un pre-clustering, como Canopy, xq sino puede que nunca converja.
# 
# Procesos iterativos y distancias dan problemas tecnol??gicos, i.e. puede tardar mucho tiempo
# 

#####   JER??RQUICO AGLOMERATIVO    #######
##########################################
# 
# distancia euclidea: raiz cuadrada de la suma de los cuadrados
# Hay que tener mucho cuidado cuando se agrupa el primer punto  de cara a agruparlo con el segundo. Xq?
#   xq hay que elegir la posici??n del grupo. Es el punto mas lejano? el mas cercano? o el del medio?
#   Ojo, el del medio generalmente no se elige xq requiere mas c??mputo.
# 
# Se suele coger el m??ximo porque se quiere que la distancia m??xima entre dos puntos sea lo mas peque??a posible
# 
# N puntos:
#   (N * (N-1)) / 2 distancias. 
#   Si tenemos 1.000.000 puntos, echa cuentas !!!!!
# 
#  C??mo se pinta? eje X los puntos, eje Y las distancias Demograma 
# El demograma se empieza a leer muy mal con muchos puntos, pero se puede cortar en capas e ir agrupando
# # en bloques

# El numero de clusters depende del sentido al negocio
# 
# Cluster: no se le dice al algoritmo en base a qu?? tiene que agrupar. 
#         No hay una separaci??n exacta en funci??n de los valores de las variables
# Segment: La poblaci??n se agrupa con unos umbrales claros en unas variables.
#         El corte se puede elegir en funci??n de experiencia, t??cnicas estad??sticas, etc.
# 
# X ejemplo. Un segmento puede ser clientes >20 a??os, con altos ingresos.
# En clustering, no sabemos esas variables
#
# El clustering jer??rquico no est?? pensado para usarse luego en producci??n en sistemas muy din??micos,
# xq implicar??a recalcular todas las distancias de nuevo caa vez que llega un individuo nuevo.
# Conclusi??n:: Esta t??cnica se evitar??a generalmente en sistemas muy din??micos.

###### CLUSTERING K-MEAN    #######
###################################
# #
# En esta t??cnica hay que decir cu??ntos grupos quiero
# - Me puedo hacer un clustering jer??rquico y luego me voy a k-means
# - Hago n iteraciones en K-mean con cluster igual a 1, 2, 3, ..., n y eligo despues el que creo que ser?? mejor
# 
# Tres fases en este proceso iterativo:
#   - Fase 1: crear tantos centroides como means quiera  (inventadas las posiciones) y calcular la distancia de todos los componentes a esos centroides
#   - Fase 2: Se elige un nuevo centroide de cada bloque (por defecto, el punto medio )
#   - Fase 3: calculo las distancias de todos los puntos a ese nuevo centroide
# 
# Se buclea hasta que la distancia entre los puntos y el nuevo centroide no sea < que un umbral 
# Si esto no ocurre nunca, es bueno poner un n??mero de iteraciones m??ximo.
# 
# En funci??n de los centroides iniciales, la agrupaci??n de k-mean puede cambiar --> PROBLEMA !
#   Esto puede no ser replicable, por lo que es super importante fijar la semilla 
# 
#  
# Coste computacional: K centroides * N puntos --> menos que el jer??rquico que ten??a ( n*(n-1)) / 2  (Falta)
# 
# Ejemplo pr??ctico: En el estudio del mercado de la vivienda, primero agruparlos en clustering (chalets, centro, viejos, etc) y luego
# ya t??cnicas regresivas.
# 
# Churn: tambi??n puedes agrupar y lo mismo los clientes que mas churn tienen son los que consumen netflix y los que no tienen internet...
# 
# 
# Por tanto: el clustering como etapa previa a cualquier modelado es una etapa muy util
# 
# Adicionalmente, cuando se pone esto en producci??n, un nuevo miembro se asociar??a a su cluster en base
# a la minima distancia entre los ultimos centroides


## -------------------------------------------------------------------------

##### AGRUPACI??N: distancias o m??tricas    #######
##################################################


##### 1. Bloque de inicializacion de librerias #####

# usar menos librer??as posibles, o las mas estandars
if(!require("dummies")){
  install.packages("dummies")
  library("dummies")
}

setwd("~/Documents/MSS/Personales/GitRepos/KSchool_dataScienceMaster/kschool/week13/Aprendizaje no Supervisado")

## -------------------------------------------------------------------------
##       PARTE 1: CLUSTERING JERARQUICO: NETFLIX MOVIELENS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

movies = read.table("data/movies.txt",header=TRUE, sep="|",quote="\"")

# interesante el argumento stringAsFactors
# si realmente esta variable string no es categ??rica, es bueno poner stringsAsFactors = FALSE
# xq sino cada uno de los valores del string R lo considera como un factor.
# Sin embargo, si lo activo en esta l??nea peta mas adelante el c??digo.
## -------------------------------------------------------------------------

##### 3. Bloque de analisis preliminar del dataset #####

str(movies)
View(movies)
head(movies)
tail(movies)

table(movies$Comedy)  # nos dice cuantas comedias hay de todas
table(movies$Western)
table(movies$Romance, movies$Drama)

## -------------------------------------------------------------------------

##### 4. Bloque de calculo de distancias #####

distances = dist(movies[2:20], method = "euclidean")

## -------------------------------------------------------------------------

##### 5. Bloque de clustering jerarquico #####

clusterMovies = hclust(distances, method = "ward.D")

dev.off()
plot(clusterMovies)


rect.hclust(clusterMovies, k=2, border="yellow")
rect.hclust(clusterMovies, k=3, border="blue")
rect.hclust(clusterMovies, k=4, border="green")

### IMP: cada paso parte algo, pero no necesariamente del mismo tama??o.
### AJA, ahora hay que entender y enterpretar los grupos. Sino todos, al menos muchos para poder sacar partido
### al trabajo realizado.

NumCluster=10

rect.hclust(clusterMovies, k=NumCluster, border="red")

movies$clusterGroups = cutree(clusterMovies, k = NumCluster)

## -------------------------------------------------------------------------

##### 6. Bloque de analisis de clusters #####

table(movies$clusterGroups)

tapply(movies$Action, movies$clusterGroups, mean)
tapply(movies$Adventure, movies$clusterGroups, mean)
tapply(movies$Animation, movies$clusterGroups, mean)
tapply(movies$Childrens, movies$clusterGroups, mean)
tapply(movies$Comedy, movies$clusterGroups, mean)
tapply(movies$Crime, movies$clusterGroups, mean)
tapply(movies$Documentary, movies$clusterGroups, mean)
tapply(movies$Drama, movies$clusterGroups, mean)

aggregate(.~clusterGroups,FUN=mean, data=movies)

## -------------------------------------------------------------------------

##### 7. Bloque de ejemplo #####

subset(movies, Title=="Men in Black (1997)")

cluster2 = subset(movies, movies$clusterGroups==2)

cluster2$Title[1:10]

cluster7 = subset(movies, movies$clusterGroups==7)

cluster7$Title[1:10]

# interesante.... D??nde meter??a una nueva pel??cula, ej, la la land?
# problemon ! no hay ninguna funci?? que lo asigne
# se podr??a calcular la distancia a cada uno de los k para ver cu??l est?? mas cerca.

## -------------------------------------------------------------------------
##       PARTE 2: CLUSTERING kMEANS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 8. Bloque de carga de Datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 9. Bloque de revisi??n basica del dataset #####

str(creditos)
head(creditos)
summary(creditos)

## -------------------------------------------------------------------------

##### 10. Bloque de tratamiento de variables #####

creditosNumericos=dummy.data.frame(creditos, dummy.class="character" )
str(creditosNumericos)

## -------------------------------------------------------------------------

##### 11. Bloque de Segmentaci??n mediante Modelo RFM 12M  #####

# El problema de trabajar con distancias es que va a comparar la suma de los cuadrados de las diferencias
# entre todas las variables.
# Qu?? pasa? que si una de las variables tiene valores muy altos tiene mucho mas peso que las demas
# En este caso el balance, el rating y la edad.
# Para solucionar esto tenemos que normalizar los datos (z-score es la normalizaci??n mas habitual)

# sino normalizamos, la que va a separar es la que tenga un orden de magnitud mas grande

# Cuando normalizar?
#   
#   Cuando se usen t??cnicas basadas en distancias
#   No es tan necesario en t??cnicas que no se basa en distancias, no mejora nada la capacidad predictiva (xej regresion lineal, arboles, etc)
#   se recomienda normalizar en muchos libros xq los algoritmos son mas rapidos con unidades mas peque??as.
#   Sin embargo, en la fase de explotaci??n podemos meter la pata (lo vemos mas abajo)
#   Recomendaci??n: no normalizar, a no ser que usemos t??cnicas que se basen en distancias
# 
# Repsol: Juan hose casado 
# Jose luis flored. Fundador de neometric (analitica avanzada) - Indra

creditosScaled=scale(creditosNumericos) # esto aplica z-score

NUM_CLUSTERS=8
set.seed(1234) # probar a lanzar lo mismo sin asignar semilla, se ve que cada salida es diferente, en algunos casos muy dr??sticas


Modelo=kmeans(creditosScaled,NUM_CLUSTERS)

creditos$Segmentos=Modelo$cluster
creditosNumericos$Segmentos=Modelo$cluster

table(creditosNumericos$Segmentos)

aggregate(creditosNumericos, by = list(creditosNumericos$Segmentos), mean)

## -------------------------------------------------------------------------

##### 12. Bloque de Ejericio  #####

## Elegir el numero de clusters

## -------------------------------------------------------------------------

##### 13. Bloque de Metodo de seleccion de numero de clusters (Elbow Method) #####

# # Errores intra-grupo
# Si sumo la media de los errores dentro del grupo (calculando la distancia de cada punto con respecto al centroide)
# Se busca a partid de que punto la reducci??n no es suficiente para buscar otro punto mas
# 
# data robot, naim, data ico. etc.

Intra <- (nrow(creditosNumericos)-1)*sum(apply(creditosNumericos,2,var))
for (i in 2:15) Intra[i] <- sum(kmeans(creditosNumericos, centers=i)$withinss)
plot(1:15, Intra, type="b", xlab="Numero de Clusters", ylab="Suma de Errores intragrupo")

## -------------------------------------------------------------------------
##       PARTE 3: PCA: REDUCCI??N DE DIMENSIONALIDAD.
## -------------------------------------------------------------------------

# Estas tecnicas tienen como principal finalidad rcambiar unas variables por otras, pero con mas informaci??n
# Despues de cambiar variables por variables, no hay multicolinealidad, las variables estan no relacionadas,
# y eso ahora muchos problemas.

####    COMPONENTES PRINCIPALES   ######
########################################

# t??cnica estad??stica. 
# la correlaci??n de una variable consigo misma es la varianza
#    v1 v2  v3
# v1 1  -1,1 
# v2    1
# v3        1
# 
# con una matriz sim??trica y definida positiva (una matriz tiene inversa que dan unidad)
# ObJ: en una matriz en la que hay correlaciones, la vamos a cambiar por otra en la que no hay correlaciones
# 
# PCA significa en ver los mismos puntos con otros ejes de referencia
# 
# 
#   -   0
#   -  0
#   - 0
#   -0
#   -++++++++++++++
#   
#   
#   -
#   -
#   -
#   -
#   -
#   -+0+0+0+0+0+0+0+0++    PCA1 = x+y, PCA2 = x-y
# 
# A = P * D * P-1
# D s??lo tiene valores en la diagonal
# n=5
# m=5
# 
# 5*1 1*1 1*5
# 5*2 2*2 1*2
# 5*3 3*3 1*3
# 
# Es muy importante ordenar la matriz D en la diagonal con los valores mas importantes de mayor a menor
# Con un data set mucho mas peque??o pero equivalente al original



## -------------------------------------------------------------------------

##SVD: SINGULAR VALUE DECOMPOSITION


##### 14. Bloque de carga de datos #####

coches=mtcars # Base de datos ejemplo en R

## -------------------------------------------------------------------------

##### 15. Bloque de revisi??n basica del dataset #####

str(coches)
head(coches)
summary(coches)

## -------------------------------------------------------------------------

##### 16. Bloque de modelo lineal #####

## ejemplo de problema de multicolinealidad
modelo_bruto=lm(mpg~.,data=coches)
summary(modelo_bruto)

cor(coches)

## -------------------------------------------------------------------------

##### 17. Bloque de modelos univariables #####

modelo1=lm(mpg~cyl,data=coches)
summary(modelo1)
modelo2=lm(mpg~disp,data=coches)
summary(modelo2)
modelo3=lm(mpg~hp,data=coches)
summary(modelo3)
modelo4=lm(mpg~drat,data=coches)
summary(modelo4)
modelo5=lm(mpg~wt,data=coches)
summary(modelo5)
modelo6=lm(mpg~qsec,data=coches)
summary(modelo6)
modelo7=lm(mpg~vs,data=coches)
summary(modelo7)
modelo8=lm(mpg~am,data=coches)
summary(modelo8)
modelo9=lm(mpg~gear,data=coches)
summary(modelo9)
modelo10=lm(mpg~carb,data=coches)
summary(modelo10)

cor(coches)

## -------------------------------------------------------------------------

##### 18. Bloque de Ejercicio #####

## ??Qu?? modelo de regresi??n lineal realizar??as?

modelo11=lm(mpg~ cyl ,data=coches)
summary(modelo11)

modelo11=lm(mpg~ cyl+wt ,data=coches)
summary(modelo11)

modelo=step(modelo_bruto, direction="both",trace=1)
summary(modelo)

## -------------------------------------------------------------------------

##### 19. Bloque de Analisis de Componentes Principales #####

PCA<-prcomp(coches[,-c(1)],scale. = TRUE)

summary(PCA)
plot(PCA)

# Aqu?? se aplicar??a la regla del codo si queremos obtener el criterio anal??tico

# Lo bueno de haber hecho PCA en este caso no es que hayamos reducido dimensionalidad, sino 
# que ahora ya no est??n correladas.

# Importante que si esto se quiere poner en producci??n hay que aplicar la formula de PCA1

## -------------------------------------------------------------------------

##### 20. Bloque de ortogonalidad de componentes principales #####

# Se ve claro con esto que las variables son incorreladas, xq todo es casi cero menos en la diagonal
cor(coches)
cor(PCA$x)

# La parte negativa es que es muy, muy dificil interpretar que es PCA1, PCA3 y las nuevas variables

## -------------------------------------------------------------------------

##### 21. Bloque de representacion grafica mediante componentes principales #####

biplot(PCA)

PCA$rotation  # tenemos la relaci??n entre las diferentes variables

## -------------------------------------------------------------------------

##### 22. Bloque de creacion de variables componentes principales #####

coches$PCA1=PCA$x[,1]
coches$PCA2=PCA$x[,2]
coches$PCA3=PCA$x[,3]

## -------------------------------------------------------------------------

##### 23. Bloque de regresion lineal con componentes principales #####

modelo_PCA=lm(mpg~PCA1,data=coches)
summary(modelo_PCA)

modelo_PCA=lm(mpg~PCA$x,data=coches)
summary(modelo_PCA)

modelo_PCA=lm(mpg~PCA1+PCA3,data=coches)
summary(modelo_PCA)

save(modelo_PCA, file="modelo_PCA") #(se puede guardar en UML, MOJO)
biplot(PCA,choices=c(1,3))


## Hay muy muy pocas empresas que tengan R en producci??n. Solo python y java
## consejo. todo c??lculo estad??stico hacerlo en el sitio donde se encuentran los datos, xej, oracle.
## spark no es trazable por las herramientas de data Governance.

# power center no tracea spark..... no te dejan subirlo a producci??n.
# los procesos python tampoco son trazables.

# ####### como se pone en producci??n un kmeans????
# hay que guardarse las medias y varianzas de cada fold, al igual que los centroides
# 
# xq?
#   xq cada vez que llega un nuevo individuo, hay que escalarlo y ver qu?? centroide est?? mas cerca
# esto se puede poner en producci??n hasta en un excel, xq es una chorrada

# 
# Todo lo que se haya hecho durante la creacci??n del modelo hay que hacerlo a cada nuevo objeto 
# que llega para ser clasificado (ya sea eliminaci??n de nulos, sustituci??n de nulos por x valores, etc)
# Explotaci??n debe ser una copia de entrenamiento
#######

## -------------------------------------------------------------------------
##       PARTE 4: CLUSTERING K-MEANS Y PCA. SAMSUNG MOBILITY DATA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 24 Bloque de inicializacion de librerias y establecimiento de directorio #####

library(ggplot2)
library(effects)
library(plyr)

## -------------------------------------------------------------------------

##### 25. Bloque de carga de Datos #####

load("data/samsungData.rda")

## -------------------------------------------------------------------------

##### 26. Bloque de analisis preliminar del dataset #####

str(samsungData)
head(samsungData)
tail(samsungData)

# Algoritmos de clasificaci??n.
# Se pueden aplicar algoritmos de clasificaci??n binarios, tantos como posibles grupos
#             m1  m2 m3 m4 m5 m6
# standing    1   0
# walking     0   1
# ..
# ..
# ..
# lying       0   0
# 
# Si tenemos muchas variables y pocas observaciones, lo mas seguro es que haya overfitting.
# 5000 observaciones no deber??an usar mas de 20 variables.  

table(samsungData$activity)
str(samsungData[,c(562,563)])
## -------------------------------------------------------------------------

##### 27. Bloque de segmentacion kmeans #####

samsungScaled=scale(samsungData[,-c(562,563)])

## Cu??ndo dir?? que mi modelo es bueno? 
#Todo lo que supere el propio azar, i.e., 1/6

set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=8)

table(kClust1$cluster,samsungData[,563])

# En el modelo 1 y 8 habr??a que hacer una regresi??n log??stica

nombres8<-c("walkup","laying","walkdown","laying","standing","sitting","laying","walkdown")

Error8=(length(samsungData[,563])-sum(nombres8[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error8

## CLuster con 10 centros.
set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=10)

table(kClust1$cluster,samsungData[,563])

nombres10<-c("walkup","laying","walkdown","sitting","standing","laying","laying","walkdown","sitting","walkup")

Error10=(length(samsungData[,563])-sum(nombres10[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error10

## -------------------------------------------------------------------------

##### 28. Bloque de PCA #####

PCA<-prcomp(samsungData[,-c(562,563)],scale=TRUE)
#PCA$rotation
#attributes(PCA)
summary(PCA)
plot(PCA)
PCA$x[,1:3]

dev.off()
par(mfrow=c(1,3))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(2,3)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(1,3)],col=as.numeric(as.factor(samsungData[,563])))

# Poner las variables PCA en el eje x e y no da mucha informaci??n, xq no se tiene ni idea 
# de que significa cada cosa
# Las PCA1 positivas son de un tipo (movimiento) y las PCA1 negativas las del contrario.
# dentro de la tipolog??a principal, ya es mas complicado separarlas

par(mfrow=c(1,1))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))

## -------------------------------------------------------------------------