data(mtcars)
head(mtcars)
View(mtcars)
str(mtcars)

# 1. ¿Cuántos modelos tenían 4 cilindros y cuáles eran?

cilindros<-mtcars[which(mtcars$cyl==4),]
length(cilindros)
rownames(cilindros)

# 2. De los que tienen más de 4 cilindros, ¿cuántos y cuáles tienen transmisión automática?

cil_y_at=mtcars[which(mtcars$cyl>4 & mtcars$am==0),]
length(cil_y_at)
rownames(cil_y_at)

# 3. ¿Cuál es el consumo medio de los coches con más de 4 cilindros de transmisión automática?

cil_y_at=mtcars[which(mtcars$cyl>4 & mtcars$am==0),]
consumo=mean(cil_y_at[,1])
consumo

# 3. ¿Cuál es el consumo medio de los coches con más de 4 cilindros de transmisión manual?

cil_y_at2=mtcars[which(mtcars$cyl>4 & mtcars$am==1),]
consumo2=mean(cil_y_at2[,1])
consumo2

# Dibujamos el boxplot

boxplot(mtcars$mpg ~ factor(mtcars$am))   # El símbolo ~ significa 'en función de'

# Dibujamos lo mismo para los coches con más de 4 cilindros

boxplot(mpg ~ factor(am),data=mtcars[mtcars$cyl>4,])   # El símbolo ~ significa 'en función de'
