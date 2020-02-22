## servidor: ppoveda.database.windows.net
## Database: AdventureworksLT
## User: kschool
## password: Madrid2020
## Port: 1433

# Vamos a conectar a una BBDD y vamos a lanzar una query tanto en SQL como en R

rm(list=ls())

if(! "odbc" %in% installed.packages()) install.packages('odbc',depend=TRUE)

if(! "DBI" %in% installed.packages()) install.packages('DBI',depend=TRUE)

library(odbc)
library(DBI)

unique(odbcListDrivers()$name)

con <- DBI::dbConnect(odbc::odbc(),
                      Driver = 'ODBC Driver 17 for SQL Server', 
                      Server='ppoveda.database.windows.net',
                      Database='AdventureworksLT',
                      UID='kschool',
                      PwD='Madrid2020',
                      Port=1433)

result <- dbGetQuery(con,"select Name, Color, ListPrice from SalesLT.Product where Color='Red'")
result

if(! "dbplyr" %in% installed.packages()) install.packages('dbplyr',depend=TRUE)

library(dbplyr)
library(dplyr)

db_customers <- dplyr::tbl(con,dbplyr::in_schema("SalesLT","Product"))

db_customers %>% show_query()

result_dbplyr <- 
  as.data.frame(db_customers %>% 
                  select(Name,Color, ListPrice) %>% 
                  filter(color=='Red'))


################################
#Ahora vamos a incluir todo en un DWH

Select CustomerID


product <- dbGetQuery(con,"select ProductID, Name, Color, ListPrice from SalesLT.Product")
customer <- dbGetQuery(con,"select CustomerID, FirstName, LastName, EmailAddress from SalesLT.Customer") 

sales_query <- "select  
  H.OrderDate, 
  H.CustomerID, 
  D.ProductID, 
  D.OrderQty, 
  D.UnitPrice,
  D.UnitPriceDiscount, 
  H.Status 
  from SalesLT.salesorderDetail as D 
  left join salesLT.salesOrderHeader as H 
  on D.SalesorderID=H.SalesOrderID"

sales <- dbGetQuery(con, sales_query)

conDWH <- DBI::dbConnect(odbc::odbc(),
                      Driver = 'ODBC Driver 17 for SQL Server', 
                      Server='ppoveda.database.windows.net',
                      Database='datawarehouse',
                      UID='kschool',
                      PwD='Madrid2020',
                      Port=1433)

dbWriteTable(conDWH,'productDIM',product,overwrite=TRUE)

dbWriteTable(conDWH, 'customerDIM',customer,overwrite=TRUE)

dbWriteTable(conDWH, 'SalesFACT',sales,overwrite=TRUE)

# Importante cerrar las conexiones

dbDisconnect(con)
dbDisconnect(conDWH)
