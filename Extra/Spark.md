https://medium.com/@GalarnykMichael/install-spark-on-ubuntu-pyspark-231c45677de0
# SparkSQL and DataFrames

Dataset(data with type) vs DataFrame (rows of data)

__Advantage__
* custom memory management (project Tungsten),
* optimized execution plans (Catalyst optimizer)

### Important clasess

* __pyspark.sql.SparkSession__ Main entry point for DataFrame and SQL functionality.
```
from pyspark.sql import SparkSession
session = SparkSession.builder.getOrCreate()  # Create session
# if notebooke has been open with "pyspark" you can use direcctly spark instead of the last 2 lines

session.sparkContext.getConf().getAll()       # All config
session = SparkSession.builder.config('someoption.key','somevalue').getOrCreate() #Update config
```

* __pyspark.sql.DataFrame__ A distributed collection of data grouped into named columns.
```
df = session.createDataFrame(rows)
df = session.createDataFrame(rdd)
df = session.createDataFrame(zip(ids,positions),schema=[id,position])
df = session.read.csv('txtfile.csv') # read.json and read.parquet
df = session.sql('SELECT * FROM csv.`txtfile.csv` where _c3 = "..." ')

df.printSchema()

df.select('id').show()
df.filter(df['id']>5) or df.where(df['id']>5) 

df.take(5) # show rows
df.show(5) # show a table

df.crosstab('col1', 'col2') # pivot table

df.groupBy('col').mean('col2).show() 
df.groupBy('col').agg(functions.mean('col2').alias('pepe'),
                      functions.stddev_pop('col2')
                      
df.join(df1, on='id', how='left').show()      # By default how is = 'inner'
df.join(df1, on=df['id']==df1['id2']).show()  # column name is diferent in tables
df.join(df1, on=['id', 'location']).show()    # join by two columns
```

* __pyspark.sql.Column__ A column expression in a DataFrame.
```
# Adding columns, DataFrame is inmutable, so we create a new one
df2 = df.withColumn('anewcol',df['id']*10).withColumn('anewcol2',df['id']*10)
```
* __pyspark.sql.Row__ A row of data in a DataFrame.
```
from pyspark.sql import Row
rows = [Row(id=id_, position=postition_) for id_,postition_ in zip(ids,positions)]

```

* `pyspark.sql.GroupedData` Aggregation methods, returned by DataFrame.groupBy().
* `pyspark.sql.DataFrameNaFunctions` Methods for handling missing data (null values).
* `pyspark.sql.DataFrameStatFunctions` Methods for statistics functionality.
* __pyspark.sql.functions__ List of built-in functions available for DataFrame, each function expect a column.
```
from pyspark.sql import functions
df.select('id',functions.sqrt(df['id'])).show(3)          # Do Not use Python functions.

uds_log1p = functions.udf(math.log1p, types.FloatType())  # Create a User Define Fucntion to use Python functions
functions.udf(lambda x: x+x)

df3 = df.select('id','position',uds_log1p('id'))

# UDF are faster in Scala than in pySpark
```



* __pyspark.sql.types__ List of data types available.
```
from pyspark.sql import types
# Define schema
fields = [types.StructField('id', types.IntegerType()),types.StructField('position', types.StringType())]
my_schema = types.StructType(fields)
session.createDataFrame(zip(ids,positions),schema=my_schema)
```
* `pyspark.sql.Window` For working with window functions.


### Summary statistics

https://databricks.com/blog/2015/06/02/statistical-and-mathematical-functions-with-dataframes-in-spark.html

# Script
```shell
from __future__ import print_function
from pyspark.sql import SparkSession, types, functions
import sys

# Create functions
def zipsort(a,b):
    return sorted(zip(a,b))
zipsort_udf = functions.udf(zipsort, types.ArrayType(types.ArrayType(types.FloatType())))

if __name__ == "__main__":

    file = sys.argv[1]
    out = sys.argv[2]
```

### Execute local job 
```shell
unset PYSPARK_DRIVER_PYTHON
spark-submit myjob.py file out
```

### Execute job at Google Cloud
```shell
gcloud init
gsutil mb -p [CLUSTER_NAME]  gs://bucket-name                     # Create a folder
gsutil cp [LOCAL_OBJECT_LOCATION] gs://[DESTINATION_BUCKET_NAME]/ # Upload file
gsutil ls gs://[DESTINATION_BUCKET_NAME]/                         # Ckeck if file has been uploaded
gcloud dataproc jobs submit pyspark --cluster [CLUSTER] \ [myjob.py] -- [ARGS]  # Execute

```

# RDDs
```Spark
my_rdd = sc.parallelize(input_list) # Distribution
my_rdd2 = my_rdd.map(funtion_name)  # Not compute
my_rdd2.collect()                   # Compute

my_rdd.take(3) # compute the 3 firts elements and show them
```

* __Transformations__ produce an RDD. map, filter, reduceByKey. sc.parallelize and sc.textFile
* __Actions__ are implemented as methods on an RDD, and return an object non RDD. reduce, collect, take, takeOrdered, and count.
```spark
my_first_rdd\
    .filter(funtion_name)\      # Trasformation
    .map(lambda n:1)\           # Trasformation
    .reduce(lambda a,b: a+b)    # Action
    
my_rdd.takeOrdered(10, lambda x: -x) # Reverse order
```
Persists
```spark
from pyspark import StorageLevel
StorageLevel.MEMORY_AND_DISK
non_s_cake.persist()
#usedisk, usememory, useOffheap, deserielized, replication 
non_s_cake.getStorageLevel()

# you can use also my_rdd.cache() to persists 
```
Partitions
```
my_rdd = sc.parallelize(input_list, num_partitions) 
my_rdd.getNumPartitions()
my_rdd.glom().collect()   # Show how data is distributed on each partition
```
Pair RDDs
```
pair_rdd = my_rdd.map(lambda element: (element,1))
count_elements = pair_rdd.reduceByKey(lambda v1,v2: v1+v2)
count_elements.collect()

# if RDD is like (key, (value1,..., valuen)), you can work with mapValues
my_rdd.mapValues(lambda v: v[0]-v[n-1])
```
Text File
```
# Read file
s_lines = sc.textFile('txtfile_name.txt')

# lower case
words = s_lines.map(lambda line: line.lower())\
               .flatMap(lambda line: line.split()) # flatMap put all toguether in the same line and remove empty elements

# Remove empty words
words = s_lines.map(lambda line: line.lower())\
               .flatMap(lambda line: line.split())
               
               
```

# R

```r
install.packages("sparklyr")
library(sparklyr)
spark_install(version = "2.3")

sc <- spark_connect(master = "local")
spark_connection_is_open(sc)              # TRUE if spark is connected 


puntero_spark <- spark_read_csv(sc, 'table_name', "./data/file.csv") # read flights table directly into Spark

tabla_r <- read.csv('./data/file.csv')
puntero_spark <- copy_to(sc, tabla_r)     # Copy dataframe to the Spark cluster 
                                          # la tabla en spark se sigue llamanda tabla_r
                                          # puntero_spark apunta a tabla_r de spark y 
                                          # sobre el puntero se pueden usar comandos dplyr

tabla_spark %>% group_by(fieldname) %>% summarize(count = n(), mean_rating = mean(Rating)) %>% collect()
result %>% arrange(desc(mean_rating))     # Other transformation                                                                       

src_tbls(sc)                              # See which data frames are available in Spark

rm(chocolate_tbls)
chocolate_tbls <- tbl(sc, "chocolate")    # tbl() nos permiete acceder a los dataframes de Spark 
                                          # incluso si hemos borrado la referencia 

table_filtered <- puntero_spark %>%
                  filter(!is.na(ARR_DELAY) & !is.na(DEP_DELAY)) %>%
                  filter(DEP_DELAY > 15 & DEP_DELAY < 240) 
sql <- ft_dplyr_transformer(sc, table_filtered)  # encapsula las transformaciones definidas sobre un pipeline de datos
print(sql$param_map$statement)            # Print sql sentence

model_data <- table_filtered %>%
              left_join(airlines_tbl, by = c("UNIQUE_CARRIER" = "IATA")) %>%
              mutate(GAIN = DEP_DELAY - ARR_DELAY) %>% # New Column
              select(YEAR, MONTH, ARR_DELAY, DEP_DELAY, DISTANCE, UNIQUE_CARRIER, AIRLINE_NAME, TAIL_NUM, GAIN, COUNTRY)
              
              distinct(ORIGIN_AIRPORT_ID, ORIGIN_CITY_NAME) %>% 
              transmute(id = as.character(ORIGIN_AIRPORT_ID), name = ORIGIN_CITY_NAME)

summarize_carrier <- model_data %>%
                    group_by(UNIQUE_CARRIER) %>%
                    summarize(airline = min(AIRLINE_NAME), gain=mean(GAIN), 
                              distance=mean(DISTANCE), depdelay=mean(DEP_DELAY)) %>%
                    select(airline, gain, distance, depdelay) %>%
                    arrange(gain)

# Partition the data into training and validation sets
model_partition <- model_data %>% sdf_random_split (train = 0.7, valid = 0.2, test = 0.1, seed = 43)

# Fit a linear model
ml1 <- model_partition$train %>% ml_linear_regression(GAIN ~ DISTANCE + DEP_DELAY + UNIQUE_CARRIER + COUNTRY)

ft_r_formula(LBEL ~ FEATURE1 + FEATURE2)    # Vector Assembler
```
## SparkSQL
```r
library(DBI)

sdf_register( model_partition$valid, name = "model_validation")
model_validation_samples <- dbGetQuery(sc, "SELECT * FROM model_validation LIMIT 10")

ml_predict(ml1, sdf_copy_to(sc, model_validation_samples[5, ]))
```
## Write and Close
```r
spark_write_parquet(puntero_spark, "./data/path")

spark_disconnect(sc)
```




