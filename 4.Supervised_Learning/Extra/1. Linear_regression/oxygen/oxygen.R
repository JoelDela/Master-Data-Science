# Distillation experiment
# Dependent variable (y) oxygen purity (%)
# Independent variable (x) hydrocarbon level (%)

rm(list=ls())

x=c(.99,1.02,1.15,1.29,1.46,1.36,0.87,1.23,1.55,1.4,1.19,1.15,.98,1.01,1.11,1.2,1.26,1.32,1.43,.95)
y=c(90.01,89.05,91.43,93.74,96.73,94.45,87.59,91.77,99.42,93.65,93.54,92.52,90.56,89.54,89.85,90.39,93.25,93.41,94.98,87.33)

# The relation between the variables is almost linear

plot(x,y,pch=1,xlab="HC Level", ylab="O Purity",col="red")

# Estimators of regression parameters

model=lm(y~x)

model

# Estimators of coefficients, tests and R2 coefficients

summary(model)

# A medida que se agrega más variables al modelo,
# el valor R-Squared del nuevo modelo siempre sera
# mayor que el del subconjunto mas pequeno. Esto se debe a que,
# dado que todas las variables en el modelo original tambien estan
# presentes, su contribución para explicar la variable dependiente
# tambien estara presente, por lo tanto,
# cualquier nueva variable que anadimos solo puede agregar
# variación que ya estaba explicada.
# Por tanto, el valor ajustado de R-Squared es el que debe analizarse.
# R^2_adj penaliza el valor total para el número de terminos
# (variables) en nuestro modelo. Por lo tanto, cuando se comparan
# modelos anidados,  es una buena práctica condirar el valor de
# R^2_adj en lugar de R^2.

1-sum((y-predict(model))^2)/sum((y-mean(y))^2)
r_square<-summary(model)$r.squared
r_square

nvariables<-1
1-((length(x)-1)/(length(x)-nvariables-1))*(1-r_square)



# Plot of the regression line
plot(x,y,pch=5,xlab="HC Level", ylab="O Purity",col="red")
abline(model)


# Diagnostic plots 

plot(fitted.values(model),residuals(model),col="red",pch=3)


# Normality of error residuals

qqnorm(residuals(model),col="red",pch=3)
qqline(residuals(model))


hist(y,prob=T)
lines(density(y))


