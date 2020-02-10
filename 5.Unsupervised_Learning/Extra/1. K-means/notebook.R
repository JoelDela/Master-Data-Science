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
my_data<-NULL 

#Verificamos si el dataset tiene NA's
sapply(my_data,function(x) any(is.na(x)))

#No queremos que el algoritmo dependa de una unidad variable arbitraria
my_data<- NULL(my_data)
head(NULL)

#veamos las distancias entre cada estado
distance <- NULL
NULL(NULL, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

#"Entrenamos" el kmeans
my_kmeans_2<-kmeans(NULL,centers = NULL,nstart = NULL)
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
my_kmeans_3 <- kmeans(NULL, centers = NULL, nstart = 10)


# plots para comparar
plot_1 <- fviz_cluster(NULL, geom = "point", data = NULL) + ggtitle(NULL)
plot_2 <- fviz_cluster(NULL, geom = "point",  data = NULL) + ggtitle(NULL)
plot_3 <- fviz_cluster(NULL, geom = "point",  data = NULL) + ggtitle(NULL)
plot_4 <- fviz_cluster(NULL, geom = "point",  data = NULL) + ggtitle(NULL)


grid.arrange(plot_1, plot_2, plot_3, plot_4, nrow = NULL)


#--------------------- Fin: Visualizacion ------------------------------#



#---------------- Inicio: Numero optimo de clusters (Elbow method) --------------------#


set.seed(123)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(my_data, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = NULL to k = NULL
k.values <- NULL

# extract wss for NULL clusters
wss_values <- NULL(k.values, wss)

plot(NULL)


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

# Compute and plot wss for k = NULL to k = NULL
k.values <- NULL

# extract avg silhouette for 2-15 clusters
avg_sil_values <- NULL(NULL, NULL)

plot(NULL,
     xlim=c(0,15))


#Manera automatica
fviz_nbclust(my_data, kmeans, method = "silhouette")


#---------------- Fin: Numero optimo de clusters (Average Silhouette Method) --------------------#





#---------------- Inicio: Numero optimo de clusters (Gap Statistic Method) --------------------#


# compute gap statistic
set.seed(123)
gap_stat <- clusGap(NULL, FUN = NULL, nstart = NULL,
                    K.max = NULL, B = NULL)
# Print the result
print(gap_stat, method = "firstmax")


#Manera automatica
fviz_gap_stat(gap_stat)


#---------------- Fin: Numero optimo de clusters (Gap Statistic Method) --------------------#






#---------------- Inicio: Resultados finales --------------------#

set.seed(123)
my_final_kmeans <- NULL
print(NULL)

fviz_cluster(NULL, data = NULL)


USArrests  %>%
  mutate(Cluster = my_final_kmeans$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")


#---------------- Fin: Resultados finales --------------------#





#---------------- Inicio: Evaluar una nueva observacion --------------------#

new_obs<-c(11,250,60,22)


#TAREA: cree una funcion para evaluar nuevas observaciones.




#---------------- Fin: Evaluar una nueva observacion --------------------#







