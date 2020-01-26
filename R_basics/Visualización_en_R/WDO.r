#################################################################
# RWANDA ggplot2
#################################################################

# Loading data from the WDB web using an API
install.packages('WDI')
library(WDI)

WDIsearch(string = "life.*expectancy", field = "name", cache = NULL)

df.le = WDI(country = "all", indicator = c("SP.DYN.LE00.IN"), start = 1900, 
            end = 2012)
head(df.le)
levels(factor(df.le$country))
levels(factor(df.le$year))

require(ggplot2)
g = ggplot() + geom_boxplot(data = df.le, aes(x = year, y = SP.DYN.LE00.IN, 
                                              group = year))
g = g + theme(axis.text.x = element_text(angle = 45, hjust = 1))
g

? geom_boxplot

subset(df.le, year > 1988 & SP.DYN.LE00.IN < 40)
#df.le %>% filter (year > 1988 & SP.DYN.LEE.IN < 40)

g = g + geom_line(data = subset(df.le, country == "Rwanda"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "red")
g

g = g + geom_line(data = subset(df.le, country == "Sierra Leone"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "orange")
g

# H01: Genocide > 1994 x
# H02: AIDS epidemy also in Kenya, South Africa, Uganda, etc

g = g + geom_line(data = subset(df.le, country =="Kenya"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "green")
g

g = g + geom_line(data = subset(df.le, country =="South Africa"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "green")
g

g = g + geom_line(data = subset(df.le, country =="Uganda"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "green")
g

#H03: Civil War
g = g + geom_line(data = subset(df.le, country =="Bangladesh"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "blue")
g

g = g + geom_line(data = subset(df.le, country =="Iraq"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "red")
g

g = g + geom_line(data = subset(df.le, country =="Iran, Islamic Rep."), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "red",lty=2)
g

g = g + geom_line(data = subset(df.le, country =="Afghanistan"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "violet")
g

g = g + geom_line(data = subset(df.le, country =="Cambodia"), aes(x = year, y = SP.DYN.LE00.IN), 
                  col = "pink")
g
