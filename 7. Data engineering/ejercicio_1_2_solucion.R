################################
## 18 Máster Data Science Madrid
## Data Engineering con R
################################
## Ejercicio 1-2
################################

## Conectar a la siguiente base de datos Azure SQL
##   Servidor: ppoveda.database.windows.net
##   Database: AdventureWorksLT
##   User: kschool
##   Password: Madrid2020
##   Port: 1433

## Limpieza del entorno

rm(list=ls())

## Instalamos y cargamos las librerías necesarias

if(! "odbc" %in% installed.packages()) install.packages("odbc", depend = TRUE)
if(! "DBI" %in% installed.packages()) install.packages("DBI", depend = TRUE)
if(! "dbplyr" %in% installed.packages()) install.packages("dbplyr", depend = TRUE)
if(! "tidyverse" %in% installed.packages()) install.packages("tidyverse", depend = TRUE)

library(odbc)
library(DBI)

## Comprobamos los drivers disponibles en el sistema
## Si no está "ODBC Driver 17 for SQL Server", lo instalamos desde aquí:
## https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?redirectedfrom=MSDN&view=sql-server-ver15

sort(unique(odbcListDrivers()[[1]]))

## Creamos la conexión a la bbdd

con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "ODBC Driver 17 for SQL Server",
                      Server   = "ppoveda.database.windows.net",
                      Database = "AdventureWorksLT",
                      UID      = "kschool",
                      PWD      = "Madrid2020",
                      Port     = 1433)

## Crear un data frame con las columnas
##   Name
##   Color
##   ListPrize
## de la tabla 
##   Product 
## en el esquema 
##   SalesLT
## con el filtro 
##   Color = "Red"
## usando los paquetes odbc y dbplyr

## odbc

## Guardamos el resultado de la query SQL

result <- dbGetQuery(con, "SELECT Name, Color, ListPrice FROM SalesLT.Product WHERE Color = 'Red'")


head(result)

## dbplyr

library(dplyr)
library(dlyr)

## Obtenemos la tabla Product del schema SalesLT

db_customers <- dplyr::tbl(con, dbplyr::in_schema("SalesLT", "Product"))

## Comprobamos la query generada por dbplyr

db_customers %>% show_query()

## Implementamos la consulta con sintaxis de dplyr

rest_dbplyr <- as.data.frame(db_customers %>% 
                               select(Name, Color, ListPrice) %>%
                               filter(Color == "Red")
)

head(rest_dbplyr)

## Implementar un proceso ETL que escriba en un data warehouse
## el siguiente modelo estrella
##
## Dimensiones
## 
## Product (ProductID, Name, Color, ListPrice)
## Customer (CustomerID, FirstName, LastName, EmailAddress)
##
## Hechos
##
## Sales:
## SalesOrderHeader (OrderDate, CustomerID, Status)
## SalesOrderDetail (ProductID, OrderQty, UnitPrice, UnitPriceDiscount)
## 
## Parámetros de conexión del data wareohuse en Azure SQL
##   Servidor: ppoveda.database.windows.net
##   Database: datawarehouse
##   User: kschool
##   Password: Madrid2020
##   Port: 1433

## Dimensiones

product <- dbGetQuery(con, "SELECT ProductID, Name, Color, ListPrice FROM SalesLT.Product")

customer <- dbGetQuery(con, "SELECT CustomerID, FirstName, LastName, EmailAddress FROM SalesLT.Customer")

## Hechos

fact_query <- 
  "
    SELECT 
     H.OrderDate,
     H.CustomerID,
     D.ProductID,
     D.OrderQty,
     D.UnitPrice,
     D.UnitPriceDiscount,
     H.Status
    FROM
     SalesLT.SalesOrderDetail D,
     SalesLT.SalesOrderHeader H
    WHERE
     D.SalesOrderID = H.SalesOrderID
  "

sales <- dbGetQuery(con, fact_query)

## Escribimos los resultados en el data warehouse

## Creamos la conexión

conDWH <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "ODBC Driver 17 for SQL Server",
                      Server   = "ppoveda.database.windows.net",
                      Database = "datawarehouse",
                      UID      = "kschool",
                      PWD      = "Madrid2020",
                      Port     = 1433)

## Volcamos los df a las tablas del data warehouse

product_write <- dbWriteTable(conDWH, "productDIM", product, overwrite = TRUE)
customer_write <- dbWriteTable(conDWH, "customerDIM", customer, overwrite = TRUE)
sales_write <- dbWriteTable(conDWH, "salesFACT", sales, overwrite = TRUE)

## Cerramos las conexiones a las bbdd

dbDisconnect(con)
dbDisconnect(conDWH)

