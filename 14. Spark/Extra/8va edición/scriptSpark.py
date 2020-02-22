from __future__ import print_function
from pyspark.sql import SparkSession
import sys
from pyspark.sql import types, functions


def zip_sort(delays, fractions):
    return sorted(zip(delays, fractions))


def quartiles(distribution):
    cumulative = 0.0
    result = []
    for delay, percentage in distribution:
        next_cumulative = cumulative + percentage
        if cumulative == 0.0:
            # minimum
            result.append(delay) 
        if cumulative < .25 and next_cumulative > .25:
            # 1st quartile
            result.append(delay) 
        if cumulative < .5 and next_cumulative > .5:
            # median
            result.append(delay) 
        if cumulative < .75 and next_cumulative > .75:
            # 3rd quartile
            result.append(delay) 
            
        cumulative = next_cumulative
    
    # maximum
    result.append(delay) 
    
    return result


if __name__ == "__main__":
    
    file = sys.argv[1]
    out = sys.argv[2]
    
    spark = SparkSession.builder.getOrCreate()
    df = spark.read.csv(file, header=True, inferSchema=True)
    timesdelays = df[['DepTime', 'DepDelay']]

    hoursdelays = timesdelays.select((timesdelays['DepTime'] / 100).cast(types.IntegerType()).alias("Hour"),
                                      'DepDelay')
    totals_per_hour = hoursdelays.groupBy('Hour').count()
    totals_per_hourdelay = hoursdelays.groupBy(['Hour', 'DepDelay']).count()
    frequencies = totals_per_hourdelay.join(totals_per_hour, on="Hour")\
                                      .select(totals_per_hourdelay['Hour'],
                                              'DepDelay',
                                              totals_per_hourdelay['count'].alias('count'),
                                              totals_per_hour['count'].alias('total'),
                                              (totals_per_hourdelay['count'] / totals_per_hour['count']).alias('fraction'))

    groups = frequencies.groupBy('Hour')
    distributions = groups.agg(functions.collect_list('DepDelay').alias('delays'), 
                               functions.collect_list('fraction').alias('fractions'),
                               functions.count('fraction').alias('len')).cache()

    zip_sort_udf = functions.udf(zip_sort, 
	                     returnType=types.ArrayType(
	                                  types.ArrayType(
	                                    types.FloatType()
	                                  )
	                                )
	                    )
    merged_distributions = distributions.select('Hour',
                                     zip_sort_udf(distributions['delays'], distributions['fractions']).alias('density_function'))


    quartiles_udf = functions.udf(quartiles, types.ArrayType(types.FloatType()))

    stats = merged_distributions.withColumn('quartiles', 
                                            quartiles_udf('density_function').cast(types.StringType()))

    stats.write.json(out)
