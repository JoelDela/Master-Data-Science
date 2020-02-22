# Introduction
hadoop es el resultado de yahoo viendo lo que hizo google e implementar/ poner en código abierto la arquitectura de SW que tenía google.

MapReduces es un concepto de almacenamiento (hdfs - Haddop Distribured File System) y procesado (map reduce)

Tanto Hadoop como Spark no tienen sentido fuera de un cluster, dado que lo que hace es coger ficheros muy grandes y distribuye los archivos mas pequeños por todo el cluster.

Map Reduce: 
Viene de la programación funcional. 
Map (toma un valor y una función y devuelve otro valor del mismo tipo)
Reduce (toma dos valores iguales y devuelve otro del mismo valor). Adicionalmente, la función tiene que ser conmutativa


Spark está basado en colecciones lazy, como map o range.

Haddop está hecho para leer y escribir de disco ---> KK !!!
Spark reaprovechó la misma arquitectura, pero trabajó en memoria

