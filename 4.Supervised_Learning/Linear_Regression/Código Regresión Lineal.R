# 1. Cargamos los datos

library(dplyr)
advertising <- read.csv('advertising.csv',sep=';', header=T,fileEncoding = 'utf-8')
glimpse(advertising)   #Parecido a str(advertising)

# 2. Hacemos una observación primaria de los datos a través de summary y de un plot

summary(advertising)

pairs(advertising,col='red')

# 3. Habrá que ajustar el modelo lineal
# Primero miramos las ventas frente a la TV

lm_fit_sales_TV <- lm(Sales ~ TV, data= advertising)
lm_fit_sales_TV

summary(lm_fit_sales_TV)

names(lm_fit_sales_TV)

confint(lm_fit_sales_TV, level = 0.99)

# 4. Generamos predicciones

new_advertising <- data.frame(TV = c(100, 150, 200, 250))
predicted_values <- predict(lm_fit_sales_TV, new_advertising, interval = 'confidence')
new_advertising <- cbind(new_advertising,predicted_values)
new_advertising

# 5. Pintamos los datos

plot(advertising$TV, advertising$Sales, type = 'p', col = 'red', xlab = 'TV', ylab = 'Sales')
abline(lm_fit_sales_TV, col = 'blue')

# 6. Presentamos los residuos

plot(advertising$TV, lm_fit_sales_TV$residuals, type = 'p', col = 'red', xlab = 'TV', ylab = 'Sales')

# Aquí vemos que no se cumplen los 3 requisitos ESTRICTAMENTE, en este caso no se cumple la homocedasticidad
# es decir, la varianza del error no es constante. Por tanto habrá que buscar más variables.


