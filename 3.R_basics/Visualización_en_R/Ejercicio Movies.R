library(ggplot2movies)
library(dplyr)
str(movies)
view(movies)

movies

# Crear un tible nuevo que quite todas las columnas de r1 a r10

movies %>%
  select(-starts_with('r')) %>%
  mutate(Romance=movies$Romance,rating=movies$rating)

# Ver que película tiene el peor rating cada año

summary(movies)

movies %>%
  group_by(year) %>%
  slice(which.min(rating))%>%
  select(title,year,length,rating,budget)%>%
  arrange(rating,year)

# Quitar las filas que tengan NA en budget y quedarnos con las que sean de después de 1970
movies %>%
  select(title,rating,budget,year,length) %>%
  filter(!is.na(budget) & year>1970)%>%
  ggplot(aes(budget,rating,col=year))+
  geom_point()