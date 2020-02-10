#---------------------------------------------------------------------------------#

# SAVE_SCRAP_IN_MYSQL: Este proceso se utiliza para guardar los datos en las correspondientes
# tablas 

# INPUT: nombre de la tabla
# OUTPUT: datos en MySQL

#---------------------------------------------------------------------------------#



#---------------------------------------------------------------------------------------------------------------------------------------#
#  ___           _          _                 ____                             ____            _               ____     ___    _     
# |_ _|  _ __   (_)   ___  (_)   ___    _    / ___|    __ _  __   __   ___    |  _ \    __ _  | |_    __ _    / ___|   / _ \  | |    
#  | |  | '_ \  | |  / __| | |  / _ \  (_)   \___ \   / _` | \ \ / /  / _ \   | | | |  / _` | | __|  / _` |   \___ \  | | | | | |    
#  | |  | | | | | | | (__  | | | (_) |  _     ___) | | (_| |  \ V /  |  __/   | |_| | | (_| | | |_  | (_| |    ___) | | |_| | | |___ 
# |___| |_| |_| |_|  \___| |_|  \___/  (_)   |____/   \__,_|   \_/    \___|   |____/   \__,_|  \__|  \__,_|   |____/   \__\_\ |_____|
#---------------------------------------------------------------------------------------------------------------------------------------#




lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect) #Cerramos todas las posibles conexiones que esten abiertas

# con <- dbConnect(MySQL(), user='root', password=askForPassword("Inserta password de la base de datos"), dbname='Kschool', host='localhost') #Creamos una nueva conexion
con <- dbConnect(MySQL(), user='root', password="root", dbname='Kschool', host='localhost') #Creamos una nueva conexion



dbListTables(con)


#Insertar datos

dbWriteTable(con, name="datos_inmuebles_pisoscom", value=data_scrap2, append=T,row.names=F) 

dbClearResult(dbListResults(con)[[1]])

query_mysql<-dbSendQuery(con, "SELECT * FROM datos_inmuebles_pisoscom;")
result_query<-fetch(query_mysql, n=-1)


#cerrar las conexiones que esten abiertas
lapply(dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)



#---------------------------------------------------------------------------#
#                            _____   _         
#                           |  ___| (_)  _ __  
#                           | |_    | | | '_ \ 
#                           |  _|   | | | | | |
#                           |_|     |_| |_| |_|
#---------------------------------------------------------------------------#
