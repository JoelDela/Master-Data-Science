#---------------------------------------------------------------------------------------------------#
#  ___           _          _                 _   _        ____   _                 _                   _                 
# |_ _|  _ __   (_)   ___  (_)   ___    _    | | | |      / ___| | |  _   _   ___  | |_    ___   _ __  (_)  _ __     __ _ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | |_| |     | |     | | | | | | / __| | __|  / _ \ | '__| | | | '_ \   / _` |
#  | |  | | | | | | | (__  | | | (_) |  _    |  _  |  _  | |___  | | | |_| | \__ \ | |_  |  __/ | |    | | | | | | | (_| |
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |_| |_| (_)  \____| |_|  \__,_| |___/  \__|  \___| |_|    |_| |_| |_|  \__, |
#                                                                                                                   |___/ 
#---------------------------------------------------------------------------------------------------#

# Este codigo es utilizado para explicar como la diferencia entre Hierarchical clusters y Kmeans con datos simulados

#---------------------------------------------------------------------------------------------------#


rm(list=ls())

#Vector semilla para obtener mismos resultados estudiantes/profesor
set.seed(2015)

#Simulamos los datos utilizando la libreria dplyr 
n <- 250
c1 <- data_frame(x = rnorm(n), y = rnorm(n), cluster = 1)
c2 <- data_frame(r = rnorm(n, 5, .25), theta = runif(n, 0, 2 * pi),
                 x = r * cos(theta), y = r * sin(theta), cluster = 2) %>%
      dplyr::select(x, y, cluster)
points1 <- rbind(c1, c2) %>% mutate(cluster = factor(cluster))


## Entrenamos un k-means y hacemos una visualizacion de los datos

k<-2 #definimos el numero de centros
my_kmeans<- kmeans(points1[,c("x","y")],k) #entrenamos nuestro kmeans
data_to_plot<-data.frame(points1[,c("x","y")],cluster=factor(my_kmeans$cluster)) #seleccionamos solo las variables a "plotear"

# hacemos un plot con la libreria plot_ly
plot_ly(data_to_plot, x= ~x,y= ~y,type = "scatter",color= ~cluster, colors="Set1")



## Hacemos lo propio para un hierarchical clustering
dist_mat <- dist(points1[,c("x","y")], method = 'euclidean') #calculamos la matriz de distancias
my_hclust<-hclust(dist_mat,method = "single") #entrenamos nuestro hclust
labels<-cutree(my_hclust,k) #la funcion cutree permite dividir el hclust en el total de ramas que se deseen
data_to_plot<-data.frame(points1[,c("x","y")],cluster=factor(labels)) #seleccionamos las variables a plotear


# hacemos un plot con la libreria plot_ly
plot_ly(data_to_plot, x= ~x,y= ~y,type = "scatter",color= ~cluster,
        colors="Set1")


## Que pasa si entrenamos un kmeans para coordenadas polares?
points1_polar <- points1 %>% transform(r = sqrt(x^2 + y^2), theta = atan(y / x)) #la funcion transform permite realizar cambios de base
my_kmeans<- kmeans(points1_polar[,c("r","theta")],k) #entrenamos nuestro kmeans para k centros
data_to_plot<-data.frame(points1_polar[,c("r","theta")],cluster=factor(my_kmeans$cluster)) #seleccionamos las variables a plotear


# hacemos un plot con la libreria plot_ly
plot_ly(data_to_plot, x= ~r,y= ~theta,type = "scatter",color= ~cluster,colors="Set1")




##Datos desbalanceados, como funciona el kmeans?

rm(list=ls())
sizes <- c(20, 100, 500) #tamano de los clusters
set.seed(2015)

#Creamos el dataset simulado
centers <- data_frame(x = c(1, 4, 6), y = c(5, 0, 6), n = sizes,cluster = factor(1:3))
points <- centers %>% group_by(cluster) %>%
  do(data_frame(x = rnorm(.$n, .$x), y = rnorm(.$n, .$y)))

#Usamos plotly para graficar
plot_ly(points, x= ~x,y= ~y,type = "scatter",colors="Set1")



#Entrenamos nuestro kmeans
k<-3
my_kmeans<- kmeans(points[,c("x","y")],k) 
data_to_plot<-data.frame(points[,c("x","y")],cluster=factor(my_kmeans$cluster))

#Usamos plotly para graficar
plot_ly(data_to_plot, x= ~x,y= ~y,type = "scatter",color= ~cluster,colors="Set1")




#Hacemos lo propio para hclust
dist_mat <- dist(points[,c("x","y")], method = 'euclidean')
my_hclust<-hclust(dist_mat,method = "single")
labels<-cutree(my_hclust,k) #Prueba colocar 4
data_to_plot<-data.frame(points[,c("x","y")],cluster=factor(labels))

#Graficamos con plotly
plot_ly(data_to_plot, x= ~x,y= ~y,type = "scatter",color= ~cluster,colors="Set1")

