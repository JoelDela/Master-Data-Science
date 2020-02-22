############################################################################
############### INICIO DEL SCRIPT: FORECAST ENERGY PRICE ###################
#### ESTE SCRIPT PROPORCIONA LA PREVISI?N DEL PRECIO DE LA ENERG?A Y UN #### 
########### INTERVALO DE CONFIANZA DE ESTA PREVISI?N DEL PRECIO ############
############################################################################


rm(list=ls())




#Cargamos los datos del script download
data_price<-fread("./data_in/energy.csv",sep=",")
data_price<-as.data.frame(data_price)
data_price$V1<-NULL


y<-ts(data_price$price_spain,frequency = 24) #Serie historica de precios

npred<-24
fit5 <- tbats(y)
fcast5 <- forecast::forecast(fit5, h=npred)

#Las siguientes lineas permiten "acomodar" los datos para ser ploteados
df<-data.frame(price_spain=as.data.frame(fcast5)[,"Point Forecast"],
               datetime=as.POSIXct(paste0(Sys.Date()," ",01:24,":00:00"),format="%Y-%m-%d %H:%M:%S",tz="UTC"))
df<-rbind(data_price[,c("price_spain","datetime")],df)

#Datos del plot principal
x<-as.POSIXct(df$datetime,format="%Y-%m-%d %H:%M:%S",tz="UTC")
y<-df$price_spain

x<-as.POSIXct(data_price$datetime,format="%Y-%m-%d %H:%M:%S",tz="UTC")
y<-data_price$price_spain

#Datos del plot adicional (prevision)
x2<-as.POSIXct(paste0(Sys.Date()," ",01:24,":00:00"),format="%Y-%m-%d %H:%M:%S",tz="UTC")
y2<-as.data.frame(fcast5)[,"Point Forecast"]

#Opciones del plot
f <- list(
  family = "Courier New, monospace",
  size = 18)


#Plot con herramienta plot.ly
forecastplot<-plot_ly(x = x, y = y, mode = 'lines',type = 'scatter',name="Hist\u00f3rico") %>%
  add_trace(x=x2, y = y2, name = "Previsi\u00f3n") %>%
  plotly::layout(title = paste("Previsi\u00f3n del mercado diario de energ\u00eda en el sistema espa\u00f1ol  para el d\u00eda",Sys.Date()),
         xaxis = list(title="Datetime",titlefont = f),
         yaxis = list(title="Eur/MWh",titlefont = f))

forecastplot<-plot_ly(x = x[(length(x)-120):length(x)], y = y[(length(x)-120):length(x)], mode = 'lines',type = 'scatter',name="Hist\u00f3rico") %>%
  add_trace(x=x2, y = y2, name = "Previsi\u00f3n") %>%
  plotly::layout(title = paste("Previsi\u00f3n del mercado diario de energ\u00eda en el sistema espa\u00f1ol  para el d\u00eda",Sys.Date()),
         xaxis = list(title="Datetime",titlefont = f),
         yaxis = list(title="Eur/MWh",titlefont = f))

save(forecastplot,file=paste0(getwd(),"./data_out/forecastplot.Rdata"))

#Generamos una tabla con los resultados de la previsi?n

forecast_export<-data.frame(datetime=x2,forecast=y2)
write.csv(forecast_export,file = paste0(getwd(),"./data_out/forecast",gsub("-","",Sys.Date()),".csv"))

############################################################################
################ FIN DEL SCRIPT: FORECAST ENERGY PRICE ##################### 
############################################################################

