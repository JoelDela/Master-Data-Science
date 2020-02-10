#----------------------------------------------------------------------------#
## scrap_pisos.com: Este codigo realiza el scraping de pisos.com
#----------------------------------------------------------------------------#
# INPUT: provincia que se desea descargar la informacion y tipo de operacion (alquiler/venta).
# Ejemplo: provincia<-"madrid" ; operacion<-"alquiler"

## OUTPUT: data frame con direccion, localidad, precio y m2,etc .
#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#
#  ___           _          _                         _                                                    
# |_ _|  _ __   (_)   ___  (_)   ___    _     _ __   (_)  ___    ___    ___        ___    ___    _ __ ___  
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | '_ \  | | / __|  / _ \  / __|      / __|  / _ \  | '_ ` _ \ 
#  | |  | | | | | | | (__  | | | (_) |  _    | |_) | | | \__ \ | (_) | \__ \  _  | (__  | (_) | | | | | | |
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   | .__/  |_| |___/  \___/  |___/ (_)  \___|  \___/  |_| |_| |_|
#                                            |_|                                                           
#----------------------------------------------------------------------------#




rm(list = ls())

############INPUT###########
provincia<-"madrid"  #Elige la provincia del scraping
operacion <- "venta" #Elige el tipo de operacion, deber ser: "alquiler" o "venta"
############################



#En el siguiente data frame almacenaremos los datos del web scraping
data_scrap<-data.frame(address=character(),localidad=character(),provincia=character(),last_price=numeric(),
                        m2=numeric(),fuente=character(),id=character(),operacion=character())



#inicializacion de valores del scrap
price<-0
pag<-1



#intentamos medir el tiempo que tarda
start.time <- Sys.time()


while(length(price!=0)){
  print(paste0("Scraping de la pagina ",pag))

  #URL a realizar scraping, requiere del tipo de operacion, provincia y numero de pagina
  url<-paste0("https://www.pisos.com/",operacion,"/pisos-",provincia,"/",pag,"/")

  #Se extrae el html y se realiza un "try" para que el codigo continue en caso de error
  error<-try(pisoscom <- read_html(url),silent = T)
  

  if(class(error)[1]!="try-error"){
    
    #las siguientes lineas son para extaer el numero de la ultima pagina, de esta manera saber
    #cuando el codigo debe detenerse
    
    if(pag==1){
      pager<-pisoscom %>%
        html_nodes(".pager") %>% #item que contiene el pie de pagina
        html_text()
      
      #limpieza de texto
      pager<-unlist(strsplit(pager," "))
      pager<-gsub("\r","",pager)
      pager<-gsub("\n","",pager)
      lastpage<-max(as.numeric(pager),na.rm = T)
    }
    
    
    #Para direccion
    address<-pisoscom %>% 
      html_nodes(".anuncioLink") %>%  #item de direccion, no es necesario la limpieza del texto
      html_text()
    
    detail<-pisoscom %>%
      html_nodes(".price") %>% #item de precio
      html_text()
    
    #Limipieza de texto de precio
    if(grepl("venta",url)){
      #Para venta
      price<-detail[grepl("\u20AC",detail, perl = TRUE)]
      price<-gsub("\u20AC","",price, perl = TRUE)
    }else{
      #Para alquiler
      price<-detail[grepl(paste0(" \u20AC","/mes"),detail, perl = TRUE)]
      price<-gsub(paste0(" \u20AC","/mes"),"",price, perl = TRUE)
    }
  
    price<-gsub(" ","",chartr(".", " " ,price))
    price<-as.numeric(price[!is.na(as.numeric(price))])
    
    
    
    #Es conveniente guardar un id de las descargas que se realizan, que se pueda
    #identificar posteriormente en caso de errores o comprobaciones, etc
    id<-pisoscom %>%
      html_nodes(".anuncioLink") %>% 
      html_attr("href")
    
    id<-strsplit(id,"-")
    id<-do.call(rbind,id)[,3]
    id<-paste0("pi_",gsub("/","",id))
    
    
    #Extraemos localidad
    localidad <- pisoscom %>%
      html_nodes(".location") %>% 
      html_text()
    
    
    pos<-!grepl("\\(",localidad)
    localidad[pos]<-gsub("  ","",localidad[pos])
    localidad[pos]<-gsub("\r\n","",localidad[pos])
    
    #Limpieza de texto
    localidad[!pos]<- unlist(regmatches(localidad, gregexpr("(?<=\\().*?(?=\\))", localidad, perl=T)))
    localidad<-gsub(".*\\. ", "", localidad)
    
    #otra manera de hacerlo mas entendible
    # first<-unlist(gregexpr(pattern = "\\(",localidad[!pos]))
    # last<-unlist(gregexpr(pattern = "\\)",localidad[!pos]))
    # substring(localidad[!pos],first+1,last-1)
    
    
    #Extraemos los m^2
    m2<-pisoscom %>%
      html_nodes(".characteristics") %>% 
      html_text()
    
    
    lambda<-function(x){
      first<-gregexpr(pattern = "[0-9]",x)[[1]][1]
      last<-gregexpr(pattern = "m\u00b2",x)[[1]][1]
      result<-substring(x,first,last-2)
      return(result)
    }
    
    m2<-unlist(lapply(m2, function(x) lambda(x)))
   
    
    
    #Se actualizan los otros parametros, para quedarnos con aquellos que tienen la informacion de precio
    address<-address[grepl("\u20ac",detail)]
    id<-id[grepl("\u20ac",detail)]
    localidad<-localidad[grepl("\u20ac",detail)]
    m2<-localidad[grepl("\u20ac",detail)]
    
    #Guardamos los datos en un dataset temporal llamado data_scrap_by_page
    data_scrap_by_page<-data.frame(address,localidad,rep(provincia,length(price)),price,m2,"pisoscom",id,operacion)
    names(data_scrap_by_page)<-names(data_scrap)
    
    #Si ya hemos descargado datos, lo colocamos debajo del dataset final
    data_scrap<-rbind(data_scrap,data_scrap_by_page)
    
    #Si recorremos la ultima pagina, se detiene el bucle
    pag<-pag+1
    if(pag==(lastpage+1)){break; price<-character()}
    
    #Es recomendable realizar un pause del sistema en cada iteracion y cada cierta cantidad de iteraciones
    #esto para evitar que nos pillen ;-)
    Sys.sleep(2+runif(1,min = -0.5,max = 0.5))
    if(pag %% 10 == 0){print("Sleeping Zzzzzz..."); Sys.sleep(8+runif(1,min = -2,max = 2))}
    
    
  }else{
    price<-character(); break
  }
  
  
}

#Convertimos todo a string
data_scrap<-data.frame(sapply(data_scrap,as.character),stringsAsFactors = F)



end.time <- Sys.time()

time.taken <- end.time - start.time
time.taken #Tiempo que ha tardado

#anadimos la ficha que se ha realizado la descarga
data_scrap$date_last_price<- Sys.Date()
data_scrap$address<-as.character(data_scrap$address)



#Para guardar en local
#save(data_scrap,file=paste0("./data_out/data_scrap_",provincia,"_",operacion,"_pisoscom_",Sys.Date(),".Rdata"))






#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#

