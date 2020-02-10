#---------------------------------------------------------------------------------------#
#  ___           _          _                 ____    _             _             ____  
# |_ _|  _ __   (_)   ___  (_)   ___    _    / ___|  | |_    __ _  | |_   ___    |  _ \ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   \___ \  | __|  / _` | | __| / __|   | |_) |
#  | |  | | | | | | | (__  | | | (_) |  _     ___) | | |_  | (_| | | |_  \__ \   |  _ < 
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |____/   \__|  \__,_|  \__| |___/   |_| \_\
#
#---------------------------------------------------------------------------------------#
# Stats.R: Con este unico fichero, se pretende ensenar estadistica basica para
# el master de data science, necesaria para comprender los siguientes metodos
# que se aprenderan para modelizar datos
#---------------------------------------------------------------------------------------#



rm(list=ls())

#-----------------------------------------------#
#------------ Estadisticos basicos -------------#
#-----------------------------------------------#
set.seed(123)
x<-rnorm(3000,0,10)

#--Media
mean(x)

#--varianza
var(x)

#--desviacion tipica
sd(x)


#--Moda (no hay una funcion en base predefinida)
getmode <- function(v) {
  uniqv <- unique(v)
uniqv[which.max(tabulate(match(v, uniqv)))]
}
v <- c(2,1,2,3,1,2,3,4,1,5,5,3,2,3)

getmode(v)

# Con caracteres 
charv <- c("data","science","statistics","science","science")
getmode(charv)

install.packages('DescTools')

DescTools::Mode(v)
DescTools::Mode(charv)

#--Mediana
median(x)

#--Quantiles
quantile(x,probs = c(0.5))
quantile(x)
quantile(x,probs = c(0.12,0.33,0.66,0.79))


#--Histograma
hist(x)
hist(x,prob=T)
lines(density(x),col="red",lwd=2)

plot_ly(x = x, type = "histogram")


#--Boxplots
y=rnorm(length(x),1)
boxplot(data.frame(x,y),main="Boxplots variables normales",
        xlab="Variables",ylab="valores")


plot_ly(y = x, type = "box") %>%
  add_trace(y = y)


boxplot(ggplot2::diamonds) #No tiene sentido comparar en un boxplot, variables de diferentes unidades

plot_ly(ggplot2::diamonds, y = ~price, x = ~cut, type = "box")



#--Funciones de probabilidad, densidad distribucion.


dbinom(2,size=10,prob=0.2) #Probabilidad que una binomial(10,0.2) tome el valor 2 es,
pbinom(2,size=10,prob=0.2) #Probabilidad que una binomial(10,0.2) tome un valor inferior a 2
qbinom(0.9,size=10,prob=0.2) # que valor de una binomial(10,0.2) presenta una probabilidad acumulada de 0.9 ?
rbinom(2000,size=10,prob=0.2) # generar 2000 valores aleatorios de una distribucion binomial(10,0.2)



dnorm(x, mean=0, sd=1) #d: densidad
pnorm(0.1, mean=0, sd=1) #p: distribucion
qnorm(0.65, mean=0, sd=1) #q: quantile, que valor de una N(0,1) presenta una probabilidad acumulada de 0.65 
rnorm(1000, mean=0, sd=1) #r: random values de tamano n media mean y desviacion sd


#-- Graficas Discretas
par(mfrow=c(1,2))
x<-c(0,1:10)
plot(x,dbinom(x,size=10,prob=0.5),type='h',main="Funci\u00f3n de Probabilidad Binomial", xlab="k", ylab="P(X=k)")
plot(x,pbinom(x,size=10,prob=0.5),type='s',main="Funci\u00f3n de Distribuci\u00f3n Binomial", xlab="k", ylab="P(X<=k)")


#-- Graficas Continuas
par(mfrow=c(1,2))
x<-seq(-5,5,by=0.1)
plot(x,dnorm(x,mean=0,sd=1),type='l',main="Funci\u00f3n de densidad normal",xlab="x", ylab="f(x)",col="blue",lwd=2)
plot(x,pnorm(x,mean=0,sd=1),type='l',main="Funci\u00f3n de distribuci\u00f3n normal",xlab="x", ylab="F(x)",col="blue",lwd=2)



#-----------------------------------------------#
#---------- Correlacion y covarianza -----------#
#-----------------------------------------------#

rm(list = ls())
#Dataset precargado en ggplot2
economics<-data.frame(economics)
head(economics)

#Relacion entre personal consumption (pce) y personal saving rate (psavert)
cor(economics$pce,economics$psavert)
cov(economics$pce,economics$psavert)

#Manualmente

xPart<-economics$pce-mean(economics$pce)
yPart<-economics$psavert-mean(economics$psavert)

nMinusOne <- nrow(economics)-1

xSD<-sd(economics$pce)
ySD<-sd(economics$psavert)

sum(xPart*yPart) / (nMinusOne*xSD*ySD)


#Para una matriz
cor(economics[,c(2,4:6)])

#plot con informacion relevante
ggpairs(economics[,c(2,4:6)])

#Matriz de correlacion grafica
econCor<-cor(economics[,c(2,4:6)])
econMelt<-melt(econCor,varnames = c("x","y"),
               value.name = "Correlation")
econMelt

#corplot
ggplot(econMelt,aes(x=x,y=y)) + #inicializa el plot
  geom_tile(aes(fill=Correlation))+ # Dibujar mosaicos rellenando el color en base a la correlación.
  scale_fill_gradient2(low=muted("red"),mid="white",
                       high = "steelblue",
                       limits=c(-1,1)) + #escala de colores, entre -1 y 1 desde rojo hasta azul
  theme_minimal() + #usa el theme minimo para que no haya extras en el plot
  labs(x=NULL,y=NULL) #no coloques valores de xlab ni ylab

#Con paquete corplot
col1 <- colorRampPalette(c("blue", "yellow"))
cex.before <- par("cex")    
par(cex = 0.7)    #Es el tamaño
corrplot(econCor, method = "color",
         col=col1(100), #eliges el color
         addCoef.col = "black", #color de los coeficientes
         tl.col="black", #color de las letras de los ejes
         tl.cex=1, #Tamaño de la letra de los ejes
         tl.srt=45, #Rotación eje x
         is.corr=T, #es una correlación? sí
         cl.offset=1, #Separación de label con el corrplot
         cl.cex=1/par("cex")
)

#"Correlation doesn't mean Causation"
getXKCD(which="552")

#que ocurre si tengo demasiadas variables, debo visualizar de la misma manera que en la linea 145?
data(tips)
head(tips)
ggpairs(tips)


#Covarianza
cov(economics$pce,economics$psavert)
cov(economics[,c(2,4:6)])

#Verificando que cov y cor*sd*sd son lo mismo
value1<-cov(economics$pce,economics$psavert)
value1

value2<-cor(economics$pce,economics$psavert)*(sd(economics$pce))*sd(economics$psavert)
value2

value1==value2

#-----------------------------------------------#
#------------------- Q-Q Plot ------------------#
#-----------------------------------------------#


ejemploQQ<-data.frame(V1=c(3,11,16,19,20,21,22,23,24,24,24,25,26,27,28,29,29,30,30,31,32,34))

ejemploQQ$V1 <- sort(ejemploQQ$V1) 

n <- length(ejemploQQ$V1)
a <- 1/2 

ejemploQQ$pi <- (1:n-a)/(n)
# ejemploQQ$pi <- (1:n-a)/(n+1-2*a)
ejemploQQ$phiInv <- qnorm(ejemploQQ$pi) 
par(mfrow=c(1,2))
plot(ejemploQQ$phiInv,ejemploQQ$V1,
     xlab="Cuantiles Normal Est\u00e1ndar",
     ylab="Datos ordenados", main="Ejemplo (a mano)") 

qqnorm(ejemploQQ$V1,main ="Usando la funci\u00f3n qqnorm")

qqline(ejemploQQ$V1)

#-----------------------------------------------#
#---------- Normalización ------------#
#-----------------------------------------------#


mydata<-cars

par(mfrow=c(1,2)) #mfrow crea subplots de 1 fila y 2 columnas, ordenando por filas (para hacer por col seria mfcol)

minmax_scaling <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}                                  #Con min max hacemos un cambio de variable que deja todo entre el max y el min

speed_minmax<-minmax_scaling(mydata$speed)
dist_minmax<-minmax_scaling(mydata$dist)
hist(mydata$speed)
hist(speed_minmax)
hist(mydata$dist)
hist(dist_minmax)


normalize <- function(x) {
  return ((x - mean(x)) / (sd(x)))
}                                     #Consiste en normalizar (z~N(0,1)) una distribución

speed_normalize<-normalize(mydata$speed)
dist_normalize<-normalize(mydata$dist)
hist(mydata$speed)
hist(speed_normalize)
hist(mydata$dist)
hist(dist_normalize)






#-----------------------------------------------#
#---- Intervalos de confianza "manualmente" ----#
#-----------------------------------------------#

rm(list = ls())

functions_to_load<-list.files("./Functions/",pattern = ".R",full.names = T)
sapply(functions_to_load,source)


Nest<-rnorm(5000,mean=0,sd=1)
muestra1<-sample(Nest, size=50)
muestra2<-sample(Nest,size=50)

#Media y varianza
Intervalo.Confianza.media(muestra1,alpha=0.05, sigma.conocido=T, sigma=1)
Intervalo.Confianza.var(muestra1,alpha=0.05)


#Diferencia de medias
muestrax<-rnorm(500,mean=0,sd=2)
muestray<-rnorm(280,mean=0.3,sd=2.5)

Intervalo.Confianza.difmedia(muestrax,muestray,0.05,sigmas.conocidos=T, sigmas.iguales=T, 2,2.5)
Intervalo.Confianza.convar(muestrax,muestray,0.05)




#Haciendo uso de la distribucion t-studendt 
t.test(muestrax) #intervalo de confianza





#-----------------------------------------------#
#------------- One-sample t-test ---------------#
#-----------------------------------------------#


rm(list=ls())

head(tips)

unique(tips$sex)

unique(tips$day)

# Primero realizamos una prueba t de una muestra sobre si la propina promedio
# es igual a $ 2.50. Esta prueba esencialmente calcula la media de los datos
# y crea un intervalo de confianza. Si el valor que estamos probando cae dentro
# de ese intervalo de confianza, podemos concluir que es el verdadero valor de la
# media de los datos; de lo contrario, llegamos a la conclusión de que no es el
# verdadero medio.

t.test(tips$tip,alternative = "two.sided",mu=2.5)

# Devuelve los resultados de la prueba de hipótesis
# de si la media es igual a $ 2.50. Imprime el estadístico t, los grados de libertad y el
# p-valor. También proporciona el intervalo de confianza del 95% y la media de la variable
# de la muestra El p-valor indica que la hipótesis nula 2 debe rechazarse, y llegamos a la
# conclusión de que la media no es igual a $ 2.50.


# Si la media hipotética es correcta, entonces esperamos que el estadístico t caiga en algún
# lugar en el medio, alrededor de dos desviaciones estándar de la media, de la distribución t.
# En la Figura siguiente vemos que la línea negra gruesa, que representa la media estimada, está
# tan lejos de la distribución que debemos concluir que la media no es igual a $ 2.50.


#ejemplo
randT<-rt(30000,df=NROW(tips)-1)


#hallamos el t-estadistico y otra informacion
tipTTest<-t.test(tips$tip,alternative = "two.sided",mu=2.5)

#graficamos
ggplot(data.frame(x=randT))+
  geom_density(aes(x=x),fill="grey",color="grey") +
  geom_vline(xintercept = tipTTest$statistic) + #El estadístico T es la linea continua
  geom_vline(xintercept = mean(randT) + c(-2,2)*sd(randT),linetype=2) #Media más o menos una desviación

#Las lineas discontinuas son dos desviaciones estándar
# de la media en ambas direcciones. La linea negra continua,
# es el estadístico t,
# está tan lejos de la distribución que debemos rechazar la hipótesis nula y
# concluir que la verdadera media no es $ 2.50.



# El p-valor es un concepto a menudo mal entendido. A pesar de todas las interpretaciones
# erróneas, un valor p es la probabilidad, si la hipótesis nula fuera correcta, de obtener
# un resultado tan extremo o más extremo. Es una medida de cuán extrema es el estadístico,
# en este caso, la media estimada. Si el estadístico es demasiado extremo, concluimos que
# la hipótesis nula debe ser rechazada. El problema principal con los p-valores, sin
# embargo, es determinar qué se debe considerar demasiado extremo. Ronald A. Fisher, el
# padre de las estadísticas modernas, decidió que deberíamos considerar que un p-valor
# más pequeño que 0.10, 0.05 o 0.01 es demasiado extremo. En este ejemplo,
# el valor p es 5.08 × 10^–8; esto es más pequeño que 0.01, así que rechazamos la
# hipótesis nula.

#Probamos si la media es mayor que 2.5
t.test(tips$tip,alternative = "less",mu=2.5)




#-----------------------------------------------#
#------------- Two-sample t-test ---------------#
#-----------------------------------------------#

# La mayoría de las veces, la prueba t se usa para comparar dos muestras.
# Continuando con los datos de propinas, comparamos que ocurre con los camareros
# de ambos sexos. Sin embargo, antes de ejecutar la prueba t,
# primero debemos verificar la varianza de cada muestra. Una prueba t tradicional
# requiere que ambos grupos tengan la misma varianza, mientras que la prueba t de
# dos muestras de Welch puede manejar grupos con variaciones diferentes. Exploramos
# esto tanto numéricamente como visualmente en


rm(list=ls())

#Debemos verificar la varianza para cada muestra, pues
# es necesario que ambas tengan la misma varianza.
aggregate(tip ~sex,data=tips,var)


#test de normalidad para la distribucion de tip
# Se plantea como hipótesis nula que una muestra x1, ..., xn proviene de una
# población normalmente distribuida.
shapiro.test(tips$tip)

#para chicas
shapiro.test(tips$tip[which(tips$sex=="Female")]) #p-valor < 0.05

#para chicos
shapiro.test(tips$tip[which(tips$sex=="Male")]) #p-valor < 0.05

ggplot(tips,aes(x=tip,fill=sex)) + 
  geom_histogram(binwidth = 0.5,alpha=1/2)


# Dado que los datos no parecen estar distribuidos normalmente, no se pueden aplicar los 
# test clásicos para determinar el radio de varianza entre muestras, por tanto,
# ni la prueba F estándar (a través de la función var.test) ni la prueba Bartlett
# (a través de la función bartlett.test) pueden aplicarse. Así que usamos la prueba
# no paramétrica de Ansari-Bradley para examinar la igualdad de varianzas.

#Usamos un test noparametrico
ansari.test(tip ~sex,tips) #H0: s_x/s_y=1 el p-valor >0.05?
#Observando el p-valor, se concluye que las varianzas son iguales.



# var.equal = TRUE ejecuta una prueba t de dos muestras estándar mientras que
# var.equal = FALSE (el valor predeterminado) ejecutaría la prueba de Welch (no requiere varianzas iguales
#Varianzas iguales, usamos el two-sample t-test
t.test(tip~sex,data=tips,var.equal=T) #H0: x-y =0 que valor tiene p-value?







#-----------------------------------------------#
#------------------ ANOVA ----------------------#
#-----------------------------------------------#

#El siguiente paso natural después de comparar dos grupos es comparar múltiples grupos.
# Vamos a repetir la prueba anterior, pero comparando los días.

rm(list=ls())


tipAnova<-aov(tip~day,tips)


#ANOVA prueba si un grupo es diferente de cualquier otro grupo pero no especifica
#qué grupo es diferente. Así que, un summary solo devuelve un único p-valor.
summary(tipAnova)

# Dado que la prueba tuvo un valor de p significativo, nos gustaría ver qué
# grupo difiere de los otros.
# La forma más sencilla es hacer un gráfico de cada grupo y los
# intervalos de confianza, para luego ver la superposición.
# La Figura siguiente muestra que las propinas del domingo difieren
# (apenas, con un nivel de confianza del 90%) tanto del jueves como el viernes.

tipsByDay<-ddply(tips,"day",summarize,
                 tip.mean=mean(tip),tip.sd=sd(tip),
                 Length=NROW(tip),
                 tfrac=qt(p=0.90,df=Length-1),
                 Lower=tip.mean-tfrac*tip.sd/sqrt(Length),
                 Upper=tip.mean+tfrac*tip.sd/sqrt(Length))

ggplot(tipsByDay,aes(x=tip.mean,y=day))+geom_point()+
  geom_errorbarh(aes(xmin=Lower,xmax=Upper),height=0.3)


#Test de independencias entre variables:
# Las pruebas de correlación se utilizan para determinar la presencia y el alcance de una
# relación lineal entre dos variables cuantitativas. En nuestro caso, nos gustaría probar
# estadísticamente si existe una correlación entre el total de la factura y la propina recibida
# El primer paso es visualizar la relación con el diagrama de dispersión, que se realiza en la
# línea de código a continuación.

plot(tips$total_bill,tips$tip)
lm_model<-lm(tip~total_bill,data=tips)
abline(lm_model,col="red",lwd=3)

cor(tips$total_bill,tips$tip)

shapiro.test(tips$tip)
lillie.test(tips$tip)

cor.test(tips$total_bill, tips$tip)


#Independencia de variables

relation_daysize <-table(tips$day, tips$size)
relation_daysize
chisq.test(relation_daysize)



#----------------------------------------------------------------------------------------
#  _____               _         ____    _             _             ____  
# | ____|  _ __     __| |  _    / ___|  | |_    __ _  | |_   ___    |  _ \ 
# |  _|   | '_ \   / _` | (_)   \___ \  | __|  / _` | | __| / __|   | |_) |
# | |___  | | | | | (_| |  _     ___) | | |_  | (_| | | |_  \__ \   |  _ < 
# |_____| |_| |_|  \__,_| (_)   |____/   \__|  \__,_|  \__| |___/   |_| \_\
#----------------------------------------------------------------------------------------

