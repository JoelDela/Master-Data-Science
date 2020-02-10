#---------------------------------------------------------------------------------------------------#
#  ___           _          _                 ____     ____      _    
# |_ _|  _ __   (_)   ___  (_)   ___    _    |  _ \   / ___|    / \   
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | |_) | | |       / _ \  
#  | |  | | | | | | | (__  | | | (_) |  _    |  __/  | |___   / ___ \ 
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |_|      \____| /_/   \_\
# 
#---------------------------------------------------------------------------------------------------#

# Este codigo es utilizado para explicar como funciona el Analisis de componentes principales
# para reducir la dimensionalidad del dataset y aplicar clustering.

#---------------------------------------------------------------------------------------------------#



rm(list=ls())


#Otra manera de importar el dataset
knitr::kable(mtcars)

# Siempre es bueno echarle un vistazo al dataset
summary(mtcars)



# cor = TRUE indica si debe realizarse con matriz de correlacion o matriz de covarianzas.
pcaCars <- princomp(mtcars, cor = TRUE)

# que objetos tenemos en pcaCars
names(pcaCars)

# "score" contiene las componentes principales
pcaCars$scores

# proporcion de varianza explicada por cada componente
summary(pcaCars)


# bar plot
plot(pcaCars)


# line plot
plot(pcaCars, type = "l")


#---------------------- Clustering ------------------------#

#Empezamos la parte que nos interesa, como podemos construir un clustering con solo dos variables?

# cluster cars
carsHC <- hclust(dist(pcaCars$scores[,1:2]), method = "ward.D2") #ward.D2: https://es.wikipedia.org/wiki/M%C3%A9todo_de_Ward

# dendrogram
plot(carsHC)


# cut the dendrogram into 3 clusters
carsClusters <- cutree(carsHC, k = 3)


# Visualizamos el dendograma con los rectangulos de cada cluster
plot(carsHC)
rect.hclust(carsHC, k=3, border="red")


# anadimos la etiqueta de cluster
carsDf <- data.frame(pcaCars$scores, "cluster" = factor(carsClusters))
carsDf


# Visualizar es siempre la mejor herramienta
ggplot(carsDf,aes(x=Comp.1, y=Comp.2)) +
  geom_text_repel(aes(label = rownames(carsDf))) +
  theme_classic() +
  geom_hline(yintercept = 0, color = "gray70") +
  geom_vline(xintercept = 0, color = "gray70") +
  geom_point(aes(color = cluster), size = 3) +
  xlab("PC1") +
  ylab("PC2") + 
  xlim(-5, 6) + 
  ggtitle("PCA plot of Cars")



#Realice el mismo analisis considerando todas las componentes principales:
# cluster cars
carsHC <- hclust(dist(pcaCars$scores), method = "ward.D2")

# dendrograma
plot(carsHC)


#--------------------- Ahora con K-means ------------------------------#

#considerando el mismo PCA, exraemos las dos primeras componentes
my_data<-as.data.frame(pcaCars$score)[,1:2]
names(my_data)<-c("pca1","pca2")

# "entrenamos" el kmenas
my_kmeans<-kmeans(my_data,centers=3,nstart=10)

# Visualizar siempre sera de gran ayuda
fviz_cluster(my_kmeans, geom = "point", data = my_data) + ggtitle("k = 3")

# Ahora con plotly, mas chulo :)
plot_ly(my_data, x=~pca1,y=~pca2,type = "scatter",color = factor(my_kmeans$cluster),colors="Set1") %>%
  add_markers(p = )




#------------ que ocurre en 3 dimensiones? ---------------------#

#seleccionamos las tres primeras componentes
my_data<-as.data.frame(pcaCars$score)[,1:3]
names(my_data)<-c("pca1","pca2","pca3")


# "entrenamos" el kmeans
my_kmeans<-kmeans(my_data,centers=3,nstart=10)


#Visualizamos con plotly
plot_ly(my_data, x=~pca1,y=~pca2,z=~pca3,color = factor(my_kmeans$cluster),colors="Set1") %>%
  add_markers() %>%
  plotly::layout(scene = list(xaxis = list(title = 'PC1'),
                      yaxis = list(title = 'PC2'),
                      zaxis = list(title = 'PC3')))


# que valores quedaron en cada cluster?
my_data$cluster<-my_kmeans$cluster
my_data[which(my_data$cluster==1),]



