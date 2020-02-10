from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.clustering import KMeans
from pyspark.sql import functions
import numpy as np
import pandas as pd

session = SparkSession.builder.getOrCreate()
df = session.read.csv('sales_segments.csv.gz', sep = '^', header=True, inferSchema=True)

df2 = df.select(
    (df['revenue_amount_seg'] / df ['bookings_seg']).alias('revenue'),
    (df['fuel_surcharge_amount_seg'] / df ['bookings_seg']).alias('tax')
)

va = VectorAssembler(inputCols=['revenue', 'tax'], outputCol='features')
assembled_df = va.transform(df2)

kmeans = KMeans(predictionCol='cluster', k=8) 
kmeans_model = kmeans.fit(assembled_df)
predicted = kmeans_model.transform(assembled_df)

stats = predicted.groupby('cluster')\
    .agg(
        functions.mean('revenue').alias('rev_avg'),
        functions.stddev('revenue').alias('rev_std'),
        functions.mean('tax').alias('tax_avg'),
        functions.stddev('tax').alias('tax_std'),
        )

annotated = predicted.join(stats, on='cluster', how='left')

calculated = annotated.select('revenue', \
                              'tax', \
                              'cluster', \
                              ((annotated['revenue'] - annotated['rev_avg']) /   annotated['rev_std']).alias('z_rev'), \
                              ((annotated['tax'] - annotated['tax_avg']) / annotated['tax_std']).alias('z_tax'))

calculated_outlier = calculated\
    .withColumn('zsquare_square', calculated['z_rev'] ** 2 + calculated['z_tax'] ** 2  )\
    .withColumn('outlier', calculated['z_rev'] ** 2 + calculated['z_tax'] ** 2 > 9  )

pd_df = calculated_outlier.select('revenue', 'tax', 'zsquare_square', 'outlier').toPandas()

kmeans_model.save('my_trained_kmeans')

session.stop()


#[kschool_08_07@ip-172-31-39-98 ~]$ spark-submit sales_segments.py 
#Traceback (most recent call last):
#  File "/home/kschool_08_07/sales_segments.py", line 2, in <module>
#    from pyspark.ml.feature import VectorAssembler
#  File "/usr/lib/spark/python/lib/pyspark.zip/pyspark/ml/__init__.py", line 22, in <module>
    
#  File "/usr/lib/spark/python/lib/pyspark.zip/pyspark/ml/base.py", line 21, in <module>
#  File "/usr/lib/spark/python/lib/pyspark.zip/pyspark/ml/param/__init__.py", line 26, in <module>
    
#ImportError: No module named numpy

#####  
###
###  No se puede lanzar xq el VectorAssembler necesita numpy en todos los nodods del cluster y parece que no es el caso en el 
###  cluster de kshool.
###
#####