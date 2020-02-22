library(dplyr)

setwd("~/Documents/MSS/Personales/GitRepos/KSchool_dataScienceMaster/kschool/week13/Aprendizaje no Supervisado")

quality = read.table("data/quality_clean.csv",header=TRUE, sep=",")

str(quality)

quality <- quality %>% 
  select (-SpeechRatio.................)

quality_train <- quality %>% 
  filter(stage=="train") 

str(quality_train)
summary(quality_train)

apply(quality_train, 2, function(x) any(is.infinite(x)))

distances_train = dist(quality_train[5:13], method = "euclidean")


clusterTrain = hclust(distances_train, method = "ward.D")

dev.off()
plot(clusterTrain)

rect.hclust(clusterTrain, k=2, border="yellow")
rect.hclust(clusterTrain, k=3, border="blue")
rect.hclust(clusterTrain, k=4, border="green")

NumCluster=4

rect.hclust(clusterTrain, k=NumCluster, border="red")

quality_train$clusterGroups = cutree(clusterTrain, k = NumCluster)

table(quality_train$clusterGroups)

aggregate(quality_train[5:14], by = list(quality_train$clusterGroups), mean)









str(distances_train)



quality %>% 
  filter(filename == "RAW_SPK00002_F_P2105_L001_01_01_99_20180321_111544.wav")

quality %>% 
  group_by(filename ) %>% 
  summarise(n=n())



quality_eval <- quality %>% 
  filter(stage=="eval") 

str(quality_train)

quality_train %>% 
  group_by(filename ) %>% 
  summarise(n=n())
##### 4. Bloque de calculo de distancias #####
