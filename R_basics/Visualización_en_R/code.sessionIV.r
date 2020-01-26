p<-murders %>% ggplot()

p+
  geom_point(aes(x = population/10^6, y = total))+
  geom_text(aes(x = population/10^6, y = total,label=state))

p+
  geom_point(aes(x = population/10^6, y = total))+
  geom_text(aes(x = population/10^6, y = total,label=abb))

p+
  geom_point(aes(x = population/10^6, y = total))+
  geom_text(aes(x = population/10^6, y = total),label=abb)

p+
  geom_point(aes(x = population/10^6, y = total))+
  geom_text(x=3,y=10,label="Hola")

p<-murders %>% ggplot(aes(x = population/10^6, y = total))
p


