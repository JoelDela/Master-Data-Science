
result<-google_places(NULL)


df_search<-data.frame(name=result$results$name,result$results$geometry$location)
nearest_search<-NULL
dest<-as.numeric(nearest_search[,c("lat","lng")])

result<-google_distance(NULL)
nearest_search$distance<-NULL

dist_bank<-min(NULL)

