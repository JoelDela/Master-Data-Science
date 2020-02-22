############################################################################
################# INICIO DEL SCRIPT: PLOTLY DASHBOARD ######################
###### ESTE SCRIPT CONSTRUYE UN DASHBOARD INTERACTIVO ###### 
############################################################################


rm(list=ls())



#Lectura forecastplot
load(paste0(getwd(),"./data_out/forecastplot.Rdata"))

#Lectura matriz evolucion de errores 
load(paste0(getwd(),"./data_out/errordf.Rdata"))

#Modificacion de la fuente
f <- list(
  family = "Courier New, monospace",
  size = 18)

#Plot de evolucion del error para cada simulacion
errorplot<-plot_ly(x = 1:20, y = errordf$err5, mode = 'lines+markers',type = 'scatter',showlegend=F) %>%
  plotly::layout(title = paste("Evoluci\u00f3n del error de previsi\u00f3n para el modelo seleccionado"),
         xaxis = list(title="Simulaci\u00f3n",titlefont = f),
         yaxis = list(title="Eur/MWh",titlefont = f))
errorplot


#Lectura matriz media MAE
load(paste0(getwd(),"./data_out/matrixbarplot.Rdata"))

#Barplot de la media de los MAE
barplot <- plot_ly(
  x = names(m),
  y = m,
  type = "bar",showlegend=F,
  marker = list(color = c('rgba(204,204,204,1)','rgba(204,204,204,1)',
                          'rgba(204,204,204,1)', 'rgba(204,204,204,1)',
                          'rgba(222,45,38,0.8)','rgba(204,204,204,1)',
                          'rgba(204,204,204,1)'))
)%>%
  plotly::layout(title = "Error medio absoluto (promedio de cada prueba)",
         xaxis = list(title = "Modelos",titlefont = f),
         yaxis = list(title = "Eur/MWh",titlefont = f))


#Construimos el "Dashboard" mediante subplots
subplot(forecastplot, errorplot, barplot,
        nrows = 3, margin = 0.05, heights = c(0.30, 0.30, 0.30),titleX = F,titleY = T)%>%
plotly::layout(title = "Dashboard",
       showlegend=T,
           annotations = list(
         list(x = 0.5 , y = 0.98, text = "Prevision del precio de energ\u00eda en el sistema espa\u00f1ol para el d\u00eda 19-09-2017", showarrow = F, xref='paper', yref='paper'),
         list(x = 0.5 , y = 0.63, text = "Evoluci\u00f3n del error de previsi\u00f3n para el modelo seleccionado", showarrow = F, xref='paper', yref='paper'),
       list(x = 0.5 , y = 0.30, text = "Error medio absoluto (promedio de cada prueba)", showarrow = F, xref='paper', yref='paper'))
       )


############################################################################
########## PARA FINALIZAR SE EXPORTA LA IMAGEN COMO HTML ###################
############################################################################
