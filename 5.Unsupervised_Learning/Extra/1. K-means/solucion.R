#---------------------------------------------------------------------------------------------------#
#  ___           _          _                 _  __                                                 
# |_ _|  _ __   (_)   ___  (_)   ___    _    | |/ /         _ __ ___     ___    __ _   _ __    ___ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | ' /   ____  | '_ ` _ \   / _ \  / _` | | '_ \  / __|
#  | |  | | | | | | | (__  | | | (_) |  _    | . \  |____| | | | | | | |  __/ | (_| | | | | | \__ \
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |_|\_\        |_| |_| |_|  \___|  \__,_| |_| |_| |___/
#---------------------------------------------------------------------------------------------------#

# Este codigo es utilizado para explicar como funciona el k-means con datos reales.

#---------------------------------------------------------------------------------------------------#



rm(list=ls())

#Leemos los datos
my_data<-USArrests

#Verificamos si el dataset tiene NA's
sapply(my_data,function(x) any(is.na(x)))

#No queremos que el algoritmo dependa de una unidad variable arbitraria
my_data<-scale(my_data)
head(my_data)

#veamos las distancias entre cada estado
distance <- get_dist(my_data)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

#"Entrenamos" el kmeans
my_kmeans_2<-kmeans(my_data,centers = 2,nstart = 10)
str(my_kmeans_2)
my_kmeans_2


#Visualizamos el cluster
fviz_cluster(my_kmeans_2, data = my_data)


ggplot(aes(UrbanPop, Murder, color = factor(my_kmeans_2$cluster),
           label = row.names(USArrests)),
       data = as.data.frame(my_data)) +
  geom_text()


#--------------------- Inicio: Visualizacion ------------------------------#

#"entrenamos" otros kmeans
my_kmeans_3 <- kmeans(my_data, centers = 3, nstart = 10)
my_kmeans_4 <- kmeans(my_data, centers = 4, nstart = 10)
my_kmeans_5 <- kmeans(my_data, centers = 5, nstart = 10)

# plots para comparar
plot_1 <- fviz_cluster(my_kmeans_2, geom = "point", data = my_data) + ggtitle("k = 2")
plot_2 <- fviz_cluster(my_kmeans_3, geom = "point",  data = my_data) + ggtitle("k = 3")
plot_3 <- fviz_cluster(my_kmeans_4, geom = "point",  data = my_data) + ggtitle("k = 4")
plot_4 <- fviz_cluster(my_kmeans_5, geom = "point",  data = my_data) + ggtitle("k = 5")


grid.arrange(plot_1, plot_2, plot_3, plot_4, nrow = 2)


#--------------------- Fin: Visualizacion ------------------------------#



#---------------- Inicio: Numero optimo de clusters (Elbow method) --------------------#


set.seed(123)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(my_data, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")


#Manera mas rapida
set.seed(123)

fviz_nbclust(my_data, kmeans, method = "wss")


#---------------- Fin: Numero optimo de clusters (Elbow method) --------------------#



#---------------- Inicio: Numero optimo de clusters (Average Silhouette Method) --------------------#


# function to compute average silhouette for k clusters
avg_sil <- function(k) {
  km.res <- kmeans(my_data, centers = k, nstart = 25)
  ss <- silhouette(km.res$cluster, dist(my_data))
  mean(ss[, 3])
}

# Compute and plot wss for k = 2 to k = 15
k.values <- 2:15

# extract avg silhouette for 2-15 clusters
avg_sil_values <- map_dbl(k.values, avg_sil)

plot(k.values, avg_sil_values,
     type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of clusters K",
     ylab = "Average Silhouettes",
     xlim=c(0,15))


#Manera automatica
fviz_nbclust(my_data, kmeans, method = "silhouette")


#---------------- Fin: Numero optimo de clusters (Average Silhouette Method) --------------------#





#---------------- Inicio: Numero optimo de clusters (Gap Statistic Method) --------------------#


# compute gap statistic
set.seed(123)
gap_stat <- clusGap(my_data, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
# Print the result
print(gap_stat, method = "firstmax")


#Manera automatica
fviz_gap_stat(gap_stat)


#---------------- Fin: Numero optimo de clusters (Gap Statistic Method) --------------------#






#---------------- Inicio: Resultados finales --------------------#

set.seed(123)
my_final_kmeans <- kmeans(my_data, 4, nstart = 10)
print(my_final_kmeans)

fviz_cluster(my_final_kmeans, data = my_data)

#centros de cada cluster
USArrests  %>%
  mutate(Cluster = my_final_kmeans$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")


#---------------- Fin: Resultados finales --------------------#





#---------------- Inicio: Evaluar una nueva observacion --------------------#

new_obs<-c(11,250,60,22)

classify_kmeans<-function(new_obs,your_kmeans){
  
  my_dist<-c()
  for(i in 1:nrow(your_kmeans$centers)){
    
    dist_temp<-stats::dist(rbind(as.numeric(your_kmeans$centers[i,]),new_obs),method = "euclidean")
    my_dist<-c(my_dist,dist_temp)
      
  }
  
  result<-which(my_dist==min(my_dist))
  
  print(paste("La nueva observaci\u00f3n pertenece al cluster",result,
              "donde estan las observaciones como:",
              paste0(names(which(my_final_kmeans$cluster==result))[1:6],collapse = ", ")))
  return(result)
  
}

my_class<-classify_kmeans(new_obs ,my_final_kmeans)
my_class

#---------------- Fin: Evaluar una nueva observacion --------------------#





































#Nota: La anterior evaluacion es incorrecta, se debe normalizar los datos, 
# para esto use attributes(my_data) (datos ya transformados) para extraer
# media y desviacion de cada variable