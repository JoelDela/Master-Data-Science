rm(list=ls())

#load dataset, you can use choose file also
my_data<-as.data.frame(fread(NULL,sep=";"))
# my_data<-as.data.frame(fread(choose.files()))

my_data_train<-my_data[1:400,]

my_data_train$Y<-ifelse(my_data_train$Y=="malo",NULL,NULL)



##########################Pregunta 1########################################

#Creamos los modelos de Regresión Logística simples

m1<-glm(Y~X1, family=binomial(link = "NULL") ,data = my_data_train)
anova(m1, test="Chi")

m2<-glm(Y~X2, family=binomial(link = "NULL") ,data = my_data_train)
anova(m2, test="Chi")

m3<-glm(Y~X3, family=binomial(link = "NULL") ,data = my_data_train)
anova(m3, test="Chi")

m4<-glm(Y~X4, family=binomial(link = "NULL") ,data = my_data_train)
anova(m4, test="Chi")

m5<-glm(Y~X5, family=binomial(link = "NULL") ,data = my_data_train)
anova(m5, test="Chi")

m6<-glm(Y~X6, family=binomial(link = "NULL") ,data = my_data_train)
anova(m6, test="Chi")

m7<-glm(Y~X7, family=binomial(link = "NULL"), data = my_data_train)
anova(m7, test="Chi")


##################Pregunta 2#############################

#Buscamos hacer una seleccion de las varibles.

#Modelo utilizando todas las  variables menos X4 y X7

m8<-glm(Y~NULL, binomial(link = "NULL"), data = NULL)
anova(m8, test="Chi")

#Eliminamos X1
model<-glm(Y~X2+X3+X4+X5+X6+X7, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X2
model<-glm(Y~X1+X3+X4+X5+X6+X7, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X3
model<-glm(Y~X1+X2+X4+X5+X6+X7, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X4
model<-glm(Y~X1+X2+X3+X5+X6+X7, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X5
model<-glm(Y~X1+X2+X3+X4+X6+X7, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X6
model<-glm(Y~X1+X2+X3+X4+X5+X7, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X7
model<-glm(Y~X1+X2+X3+X4+X5+X6, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Renombramos el modelo m8 quitando la variable NULL y repetimos el procedimiento

m8<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)
anova(m8, test="Chi")

#Eliminamos X1
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X2
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X3
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X4
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X5
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X6
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Renombramos el modelo m8 quitando la variable X5 y repetimos el procedimiento

m8<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)
anova(m8, test="Chi")

#Eliminamos X1
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X2
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X3
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X4
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Eliminamos X6
model<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)

#Comparando Con el modelo con todas las variables
anova(m8,model, test="Chi")

#Renombramos el modelo m8 quitando la variable NULL

m8<-glm(Y~NULL, binomial(link = "logit"), data = my_data_train)
anova(m8, test="Chi")

#Usamos la función step
stepAIC(glm(Y~NULL,binomial(link = "logit"), data = my_data_train))


#########################Pregunta 3###############################

exp(confint(NULL,level=NULL))

##########################Pregunta 4###################################

exp(coefficients(NULL))


############################Pregunta 5#######################################


my_pred<-predict(m8,newdata= NULL,type = "response")


############################Pregunta 6#######################################


pred_cutoff<-function(epsilon,pred){
  result<-ifelse(pred < epsilon,0,1)
  return(result)
}


pred_cutoff_03 <- pred_cutoff(NULL,my_pred)
pred_cutoff_05 <- pred_cutoff(NULL,my_pred)
pred_cutoff_08 <- pred_cutoff(NULL,my_pred)

conf_matrix_03<-table(pred=NULL,actual= NULL)
conf_matrix_05<-table(pred=NULL,actual= NULL)
conf_matrix_08<-table(pred=NULL,actual= NULL)


sum(NULL)/sum(NULL)
conf_matrix_03[2,2]/(conf_matrix_03[2,2]+conf_matrix_03[1,2]) #tpr
conf_matrix_03[1,1]/(conf_matrix_03[1,1]+conf_matrix_03[2,1]) #tnr

sum(diag(conf_matrix_05))/sum(conf_matrix_05)
conf_matrix_05[2,2]/(conf_matrix_05[2,2]+conf_matrix_05[1,2]) #tpr
conf_matrix_05[1,1]/(conf_matrix_05[1,1]+conf_matrix_05[2,1]) #tnr

sum(diag(conf_matrix_08))/sum(conf_matrix_08)
conf_matrix_08[2,2]/(conf_matrix_08[2,2]+conf_matrix_08[1,2]) #tpr
conf_matrix_08[1,1]/(conf_matrix_08[1,1]+conf_matrix_08[2,1]) #tnr

############################Pregunta 7#######################################


r<-roc.area(my_data_train$Y,my_pred)
roc.plot(my_data_train$Y,my_pred,main=paste0("Curva ROC con AUC=", r$A))


############################Pregunta 8#######################################

epsilon<-seq(length=100, from=0, to=1)

df<-data.frame(accuracy=rep(0,100),epsilon)
Y<-my_data_train$Y


for(i in 1:100){
  print(i)
  PYeq1<-NULL
  confusion_matrix<-NULL
  df$accuracy[i]<-sum(diag(confusion_matrix))/(sum(confusion_matrix))
  
}

plot(epsilon,df$accuracy,xlab="Epsilon value",ylab="Accuracy",type="l",main="Optimizaci\u00f3n accuracy \n datos de entrenamiento")
df[df$accuracy==max(df$accuracy),]


PYeq1<-ifelse(my_pred<NULL,0,1)
confusion_matrix<-table(PYeq1,Y)
confusion_matrix
confusion_matrix[2,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #fpr
confusion_matrix[1,2]/(confusion_matrix[1,2]+confusion_matrix[2,2]) #fnr
confusion_matrix[2,2]/(confusion_matrix[2,2]+confusion_matrix[1,2]) #tpr
confusion_matrix[1,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #tnr



r<-roc.area(my_data_train$Y,my_pred)
roc.plot(my_data_train$Y,my_pred,main=paste0("Curva ROC con AUC=", r$A))




############################Pregunta 9#######################################


#### a) Balanceo de muestras


rm(list=ls())

#load dataset, you can use choose file also
my_data<-as.data.frame(fread("./data_in/data_scoring.csv",sep=";"))
my_data$Y<-ifelse(my_data$Y=="malo",0,1)

my_data<-my_data[sample(1:nrow(my_data)),]

my_data_test<-my_data[1:(NULL),]
my_data_train<-my_data[setdiff(rownames(NULL),rownames(NULL)),]
my_data_train_0<-my_data_train[which(my_data_train$Y==0),]
my_data_train_1<-my_data_train[which(my_data_train$Y==1),]


my_sample<-sample(rownames(NULL),nrow(NULL))
my_data_train_sampled<-my_data_train[my_sample,]
my_data_train<-rbind(my_data_train_sampled,my_data_train_0)
table(my_data_train$Y)

my_data_test<-my_data[setdiff(rownames(NULL),rownames(NULL)),]
nrow(my_data_train)+nrow(my_data_test)==nrow(my_data)
print(paste0("Filas train=",nrow(my_data_train),"     Filas test=",nrow(my_data_test)))

#### b) Modelo todas las variables
my_model<-glm(Y~X1+X2+X3+X4+X5+X6+X7, binomial(link = "logit"), data = my_data_train)


#### c) Prediccion
my_pred<-predict(my_model,newdata= my_data_train,type = "response")



epsilon<-seq(length=100, from=0, to=1)

df<-data.frame(accuracy=rep(0,100),epsilon)
Y<-my_data_train$Y



for(i in 1:100){
  print(i)
  PYeq1<-ifelse(my_pred<epsilon[i],0,1)
  confusion_matrix<-table(PYeq1,Y)
  df$accuracy[i]<-sum(diag(confusion_matrix))/(sum(confusion_matrix))
  
}

plot(epsilon,df$accuracy,xlab="Epsilon value",ylab="Accuracy",type="l",main="Optimizaci\u00f3n accuracy")
df[df$accuracy==max(df$accuracy),]

epsilon_optimal<-df[df$accuracy==max(df$accuracy),]$epsilon[1]
PYeq1<-ifelse(my_pred<epsilon_optimal,0,1)
confusion_matrix<-table(PYeq1,Y)
confusion_matrix
confusion_matrix[2,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #fpr
confusion_matrix[1,2]/(confusion_matrix[1,2]+confusion_matrix[2,2]) #fnr
confusion_matrix[2,2]/(confusion_matrix[2,2]+confusion_matrix[1,2]) #tpr
confusion_matrix[1,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #tnr


my_pred<-predict(my_model,newdata= my_data_test,type = "response")
Y<-my_data_test$Y
PYeq1<-ifelse(my_pred<epsilon_optimal,0,1)
confusion_matrix<-table(PYeq1,Y)
accuracy_test<-sum(diag(confusion_matrix))/(sum(confusion_matrix))
tpr_test<-confusion_matrix[2,2]/(confusion_matrix[2,2]+confusion_matrix[1,2]) #tpr
tnr_test<-confusion_matrix[1,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #tnr

### d) Cross-validation





rm(list=ls())

#load dataset, you can use choose file also
my_data<-as.data.frame(fread("./data_in/data_scoring.csv",sep=";"))
my_data$Y<-ifelse(my_data$Y=="malo",0,1)

my_data<-my_data[sample(1:nrow(my_data)),]


n_fold<-5

my_performance_data_train<-data.frame(accuracy=rep(0,n_fold),epsilon=rep(0,n_fold),tpr=rep(0,n_fold),tnr=rep(0,n_fold),AUC=rep(0,n_fold))
my_performance_data_test<-data.frame(accuracy=rep(0,n_fold),epsilon=rep(0,n_fold),tpr=rep(0,n_fold),tnr=rep(0,n_fold),AUC=rep(0,n_fold))



for(i in 1:n_fold){
  print(i)
  
  #Balanceo clasess
  
  my_data_test<-my_data[((i-1)*nrow(my_data)/n_fold+1):(i*nrow(my_data)/n_fold),]
  my_data_train<-my_data[setdiff(rownames(my_data),rownames(my_data_test)),]
  my_data_train_0<-my_data_train[which(my_data_train$Y==0),]
  my_data_train_1<-my_data_train[which(my_data_train$Y==1),]
  
  
  my_sample<-sample(rownames(my_data_train_1),nrow(my_data_train_0))
  my_data_train_sampled<-my_data_train[my_sample,]
  my_data_train<-rbind(my_data_train_sampled,my_data_train_0)
  
  my_data_test<-my_data[setdiff(rownames(my_data),rownames(my_data_train)),]
  
  
  
  #Entreno modelo 
  my_model<-glm(Y~X1+X2+X3+X4+X5+X6+X7, binomial(link = "logit"), data = my_data_train)
  
  
  #Prediccion y cutoff optimo
  my_pred<-predict(my_model,newdata= my_data_train,type = "response")
  
  
  
  epsilon<-seq(length=100, from=0, to=1)
  
  df<-data.frame(accuracy=rep(0,100),epsilon)
  Y<-my_data_train$Y
  
  
  
  for(j in 1:100){
    PYeq1<-ifelse(my_pred<epsilon[j],0,1)
    confusion_matrix<-table(PYeq1,Y)
    df$accuracy[j]<-sum(diag(confusion_matrix))/(sum(confusion_matrix))
  }
  
  
  my_performance_data_train$accuracy[i]<-unique(max(df$accuracy))
  
  epsilon_optimal<-df[df$accuracy==max(df$accuracy),]$epsilon[1]
  my_performance_data_train$epsilon[i]<-epsilon_optimal
  
  
  PYeq1<-ifelse(my_pred<epsilon_optimal,0,1)
  confusion_matrix<-table(PYeq1,Y)
  my_performance_data_train$tpr[i]<-confusion_matrix[2,2]/(confusion_matrix[2,2]+confusion_matrix[1,2]) #tpr
  my_performance_data_train$tnr[i]<-confusion_matrix[1,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #tnr
  my_performance_data_train$AUC[i]<-roc.area(my_data_train$Y,my_pred)$A
  
  
  
  my_pred<-predict(my_model,newdata= my_data_test,type = "response")
  Y<-my_data_test$Y
  PYeq1<-ifelse(my_pred<epsilon_optimal,0,1)
  confusion_matrix<-table(PYeq1,Y)
  my_performance_data_test$accuracy[i]<-sum(diag(confusion_matrix))/(sum(confusion_matrix))
  my_performance_data_test$epsilon[i]<-epsilon_optimal
  
  my_performance_data_test$tpr[i]<-confusion_matrix[2,2]/(confusion_matrix[2,2]+confusion_matrix[1,2]) #tpr
  my_performance_data_test$tnr[i]<-confusion_matrix[1,1]/(confusion_matrix[2,1]+confusion_matrix[1,1]) #tnr
  my_performance_data_test$AUC[i]<-roc.area(my_data_test$Y,my_pred)$A
  
  
}

sapply(my_performance_data_train, NULL)
sapply(my_performance_data_test, NULL)



############################ Pregunta 10 #######################################


my_new_data<-data.frame(X1="cuenta.buena",X2=24,X3="pre.bueno",X4="personal",X5=3000,X6="hombre",X7="no.solo")
my_pred<-predict(my_model,newdata= my_new_data,type = "response")
PYeq1<-ifelse(my_pred<epsilon_optimal,0,1)

if(PYeq1==1){print("¡Enhorabuena! su cr\u00e9dito ha sido aprobado")}else{"Lo sentimos... no es elegible para el cr\u00e9dito que solicita"}


############################ Pregunta 11 #######################################



my_model<-glm(Y~X1+X2+X3+X4+X5+X6+X7, binomial(link = "logit"), data = my_data)
exp(coefficients(my_model))



