#---------------------------------------------------------------------------#
# clean_data_scrap.R: Estas funciones se utilizan para realizar la limpieza
# de la direccion de datos descargados a partir del web scraping
#---------------------------------------------------------------------------#



#----------------------------------------------------------------------------------------------------------#
#  ___           _          _                 _____                          _                              
# |_ _|  _ __   (_)   ___  (_)   ___    _    |  ___|  _   _   _ __     ___  (_)   ___    _ __     ___   ___ 
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   | |_    | | | | | '_ \   / __| | |  / _ \  | '_ \   / _ \ / __|
#  | |  | | | | | | | (__  | | | (_) |  _    |  _|   | |_| | | | | | | (__  | | | (_) | | | | | |  __/ \__ \
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |_|      \__,_| |_| |_|  \___| |_|  \___/  |_| |_|  \___| |___/
#----------------------------------------------------------------------------------------------------------#




#------------------------------------------------------------------------------
CleanAfterNumber <- function(clean_dir_tmp){
# Input:   clean_dir_tmp  <- vector de addresse tras la primera limpieza 
# Output:  vector de addresses tras ser quitado todo lo que hay despues del primer numero que aparece en la direccion 
#------------------------------------------------------------------------------  
  unlist(lapply(clean_dir_tmp, function(x) paste0(unlist(strsplit(x, "[0-9]"))[1], str_extract(x, "[0-9]+"))))
}


#------------------------------------------------------------------------------
cleanTipo <- function(valid_address){
# Input:   valid_address  <- vector de adresses del cual queremos limpiar el Tipo 
# Output:  clean_dir      <- vector de adresses tras la limpieza del Tipo 
#------------------------------------------------------------------------------
  clean_dir <- c()
  clean_dir[1:length(valid_address)] <- NA
  dir_splitted  <- str_split_fixed(valid_address, " en ", 2)
  
  clean_dir[dir_splitted[,2] == ""] <- dir_splitted[dir_splitted[,2] == "", 1]  #Esto significa que no encontro lo de piso en, hacerlo por si acaso  )
  clean_dir[is.na(clean_dir)]       <- dir_splitted[dir_splitted[,2] != "", 2]
  return(clean_dir)
}


#------------------------------------------------------------------------------
firstCleaning <- function (address){
# Input:   address  <- vector con las direcciones  
# Output:  address  <- vector con las direcciones, tras haberles limpiado: 
#                      - una serie de palabras que posteriormente imposibilitan la geolocalizacion de la vivienda
#                      - 155m2 o 155 m 
#                      - el codigo postal 
#                      - aquello que est? entre parentesis
#                      - aquello que est? entre "****"
#------------------------------------------------------------------------------
  address <- removeWords(address, c("piso de entidad bancaria", "nº", "n º", "º", "s/n", "blo..", "bloque", "t-11", "par.."))
  
  pat_meters <- "[0-9]+ ?k?m2|[0-9]+ ?k?m | ?k?m ?[0-9]+" # 155m2 o 155 m 
  pos_withPat <- grepl(pat_meters, address)
  address[pos_withPat] <- sub(pat_meters, "\\1", address[pos_withPat])
  
  pat_PostalCode <- "[0-9]{4,}" # Codigo postal u otra informacion que no indica el numero de casa 
  pos_withPat    <- grepl(pat_PostalCode, address)
  address[pos_withPat] <- sub(pat_PostalCode, "\\1", address[pos_withPat])
  
  address <- gsub('\\(.*?\\)', '', address)
  address <- gsub('\\*\\*\\*\\*.*?\\*\\*\\*\\*', '', address)
  address <- stripWhitespace(address)

  return(address)
}




#------------------------------------------------------------------------------
getDirClean <- function(DirCleanTmp_DirCompleta, address){
# Input:   DirClean_and_Indexes  <- lista, en la que en la primera posicion esta la direccion lista solo para los
#                                   casos en los que esta la direccion completa, y en la segunda posicion tenemos la 
#                                   columna de 1s y 0s que indican si esa vivienda tiene la direccion completa o no  
#          address               <- columna con las direcciones obtendias del scrapping
# Output:  DirClean              <- columna con la direccion lo mas limpia posible, 
#                                   tanto como si esta completa, como si no 
#------------------------------------------------------------------------------
  DirCompleta <- DirCleanTmp_DirCompleta[[2]]
  DirClean    <- DirCleanTmp_DirCompleta[[1]]
  # Esto es solo de las sdirecciones completas,
  DirClean[DirCompleta == 0] <- cleanTipo(address[DirCompleta == 0])
  return(DirClean)
}





#------------------------------------------------------------------------------
Get_DirClean_DirCompleta <- function(address){
  # Input:   address        <- vector con las direcciones de cada vivienda  
  # Output:  list:
  #           - DirClean    <- columna con la direccion lo mas limpia posible, 
  #                            tanto como si esta completa, como si no 
  #           - DirCompleta <- columna de 1s y 0s que indican si esa vivienda tiene la direccion completa o no 
  #------------------------------------------------------------------------------
  clean_dir_fin <- c()
  DirCompleta   <- c()  
  clean_dir_fin[1:length(address)] <- NA
  DirCompleta  [1:length(address)] <- 0
  
  
  # indices de aquellas que tienen letra + numero(son las mas propensas a ser direcciones completas)
  
  #### First Cleaning ####
  
  
  address <- firstCleaning(address)
  
  valid_indexes <- grep("[0-9]+", address)  #grep("[a-z]+ ?\\,? ?[0-9]+", address)  
  valid_address <- address[valid_indexes]
  
  clean_dir_tmp <- cleanTipo(valid_address)
  
  # Tercera limpieza en clean_dir_tmp 
  clean_dir_tmp2  <- CleanAfterNumber(clean_dir_tmp)
  
  # Cuarta limpieza, casos de "a 4 min" 
  valid_indexes_final <- which(nchar(str_split_fixed(clean_dir_tmp2, "[0-9]", 2)[,1]) > 4)
  clean_dir           <- clean_dir_tmp2[valid_indexes_final]
  
  # Actualizamos 
  Indexes                <- valid_indexes[valid_indexes_final]
  
  clean_dir_fin[Indexes] <- clean_dir
  
  # Rellenamos columna que indica si aparece la direccion completa o no 
  DirCompleta[Indexes]             <- 1 
  
  DirClean <- getDirClean(list(clean_dir_fin, DirCompleta), address)
  
  return(list(DirClean, DirCompleta))
}



#------------------------------------------------------------------------------
getTipo <- function(address){
  return(str_split_fixed(address, " en ", 2)[,1])
}





#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#

