library(magrittr)
library('rvest')
library ('plyr')

dataframefinal <- data.frame()

for (i in 1:25) {
  url =paste("http://pagina.jccm.es/justicia/112/ultima_hora/busqueda.php?pagina=", i ,"&numReg=486&d_fecha=2017-11-01&h_fecha=2018-11-14&desc=", sep="")
  tmp <- url %>% read_html() %>% html_nodes("table.incidencias") %>% html_table()
  
  tmpdf <- ldply (tmp, data.frame)
  names(tmpdf) <- c("Fecha", "Incidente")
  tmpdf <- tmpdf[-c(1), ]
  
  dataframefinal <- rbind(dataframefinal, tmpdf)
}
dataframefinal
rownames(dataframefinal) = seq(length=nrow(dataframefinal))

write.csv(dataframefinal,file='Incidencias.csv')
