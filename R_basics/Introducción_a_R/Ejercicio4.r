# 4.1. Construye una lista que contenga todas las posibles cartas que hay en la baraja y sus puntuaciones

lista4<-list(carta=c(1:7,10:12),palo=c('Oros','Bastos','Espadas','Copas'),puntuación=c(11,10,4,3,2))
lista4

# 4.2. Construye un data frame donde cada ﬁla represente una combinacion de carta/palo/puntuacion

ejercicio4= data.frame(carta=rep(c(1:7,10:12),4),palo=rep(c('Oros','Espadas','Bastos','Copas'),each=10),puntuación=rep(c(11,0,10,rep(0,4),2,3,4),4))
ejercicio4

# 4.3. Cuantos puntos suma en total la baraja española? 
sum(ejercicio4[,3])