#---------------------------------------------------------------------------------------------------#
#  ___           _          _                 _   _        ____   _                 _                   _                 
# |_ _|  _ __   (_)   ___  (_)   ___    _    | | | |      / ___| | |  _   _   ___  | |_    ___   _ __  (_)  _ __     __ _ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | |_| |     | |     | | | | | | / __| | __|  / _ \ | '__| | | | '_ \   / _` |
#  | |  | | | | | | | (__  | | | (_) |  _    |  _  |  _  | |___  | | | |_| | \__ \ | |_  |  __/ | |    | | | | | | | (_| |
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |_| |_| (_)  \____| |_|  \__,_| |___/  \__|  \___| |_|    |_| |_| |_|  \__, |
#                                                                                                                   |___/ 
#---------------------------------------------------------------------------------------------------#

# Este codigo es utilizado para explicar como funciona Hierarchical clustering con datos reales.

#---------------------------------------------------------------------------------------------------#



rm(list=ls())

#Para que todos tengamos el mismo resultado
set.seed(786)

#Leemos los datos
seeds_df <- as.data.frame(fread("./data_in/seeds_dataset_modified.txt",sep = ';',header = FALSE))

#Definimos los nombres de las columnas
columns_name <- c('area','perimeter','compactness','length.of.kernel','width.of.kernal','asymmetry.coefficient','length.of.kernel.groove','type.of.seed')
colnames(seeds_df) <- columns_name


#Preanalisis de los datos
str(seeds_df)
summary(seeds_df)
any(is.na(seeds_df))


#Rellenamos NA's con la moda
for(i in 1:ncol(seeds_df)){
  seeds_df[,i][which(is.na(seeds_df[,i]))] <- Mode(seeds_df[,i])[1]
}


#Eliminamos la columna que tiene las etiquetas (recordemos que queremos construir)
#un modelo no supervisado, supongamos entonces que no tenemos la columna de etiquetas
seeds_label <- seeds_df$type.of.seed
seeds_df$type.of.seed <- NULL
str(seeds_df)



#Normalizamos el dataset
seeds_df_sc <- as.data.frame(scale(seeds_df))

#media cero y desviacion 1
summary(seeds_df_sc)


#Calculamos la matriz de distancias
dist_mat <- dist(seeds_df_sc, method = 'euclidean')


#Ejecutamos el hierarchical clustering con linkage method=average
hclust_avg <- hclust(dist_mat, method = 'average')
plot(hclust_avg)


#Sabemos ya que solo tenemos 3 etiquetas diferentes, por tanto elegimos k=3
cut_avg <- cutree(hclust_avg, k = 3)
cut_avg


#Si queremos ver los clusters en el dendograma usamos abline
plot(hclust_avg)
rect.hclust(hclust_avg , k = 3, border = 2:6)
abline(h = 3, col = 'red')



#Usamos la función color_branches() de la biblioteca dendextend
#para visualizar el árbol con diferentes ramas de colores.
avg_dend_obj <- as.dendrogram(hclust_avg)
avg_col_dend <- color_branches(avg_dend_obj, h = 3)
plot(avg_col_dend)


#Contamos cuantas observaciones fueron asignadas a cada cluster
seeds_df_cl <- mutate(seeds_df, cluster = cut_avg)
as.data.frame(count(seeds_df_cl,cluster))
#o tambien
table(cut_avg)


#Es comun evaluar la tendencia entre dos caracteristicas del cluster para extraer mas informacion
#util de los datos agrupados. Como ejercicio, analice la tendencia entre el perimetro del trigo y
#el area agrupada con la ayuda del paquete ggplot2.
ggplot(seeds_df_cl, aes(x=area, y = perimeter, color = factor(cluster))) + geom_point()

#Nota: Observe que para todas las variedades de trigo parece haber una relacion lineal
# entre su perimetro y area.


#Comparemos lo real con lo observado (matriz de confusion), aunque en la practica,
#esto no sucedera nunca
table(seeds_df_cl$cluster,seeds_label)
