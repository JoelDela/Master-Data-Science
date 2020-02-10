# PLN: Notes 28 July 2018

## Herramientas mas populares 
Basados en reglas, en estadística o en redes neuronales

NLTK: reglas
SpaCy, Textacy (basado en SpaCy)
RasaNLU: se usa mucho en los aistentes virtuales. Lo mas dificil en los asistentes es saber lo que dice el usuario cuando dice algo
NeuralCored: se basan en redes neuronales. Se basa en saber cuándo el usuario se está refiriendo a un mismo concepto.
    Mi tío juan y su perro --> Tendría que saber que su se está refiriendo a Juan
Word2Vec: inferir el significado de las palabras a través de sus contextos
  Por ejemplo: An amazing library to play with natural language. 
  Puede que no sepamos que significa la palabra library, pero por el contexto puede inferir su significado. De hecho, word2vec aprende muy bien y da un listado de sinónimos.
  
  
 
 ## Niveles de conocimiento lingüistico
 
 Ordenados de mayor a menor complejidad.
 
 **1. Fonético:** la parte más física de la lingüistica. 
  - Fonética: se estudia el sonido como un continuo. Alófono. 
  - Fonología: establece un sistema simbólico por encima del físico. Qué distinciones físicas hacen que diferentes sonidos sean todos "a"
  No es lo mismo una "a" aislada o la que va detrás de otra letra/palabra.

Ninguna de las herramientas anteriores trabaja con fonemas.

 **2. Morfolófico**
 Sirve para transformar un texto en una estructura mucho mas manejable.
 "Los niveles de conocimiento lingüistico": Si sabes que "los" es un determinante y "niveles" es un nombre, ya sabes que el "token" de "niveles" tiene mucho mas información.
 
 Si tengo un pronombre y luego un token que es ambigüo, generalmente lo tengo que etiquetar como verbo.
 
 Es decir, el tipo de palabra funciona muy bien como filtros y para desambigûar palabras. Por ejemplo, "Casa". Se puede referir al verbo "casar" o a la palabra "casa".
 
 **3. Sintáctico**
 "Yo como caramelos" se guardaría como 
 
 sujeto de come --> Yo
 Nucleo: come, Dependiente: Caramelos
 
 Sirve en las aplicaciones de análisis de sentimientos, que se basan en ver qué palabras están cargadas de significado.
 "El café es bueno"
 "El trato es bueno, el café es una mierda"
 
 **4. Semántica**
 Significado de las palabras.
 Dónde está la semántica real está en los diccionarios, pero es muy complicado usarlo en el mundo real.
 La formalización del conocimiento semántico se hace en rasgos. 
 
 Semantica de rasgos: Categorías de conceptos interelacionados donde unos tienen unos rasgos y otros no.
 Por ejemplo, en muebles. Puerta puede tener el rasgo "mas movil". Armario sería "menos movil".
 Así se podrían categorizar todas las palabras, pasando de un punto de vista de significado a un una matriz de rasgos, con 0 y 1, que es mucho mas sencillo de usar.
 
 **5. Pragmático**
 Aquí empieza a estar menos conseguidos los frameworks.
 
 Conocimeinto pragmático sería saber que la palabra "rápido" se usa con un sentido positivo en unas frases y con un sentido negativo en otros.
 Por ejemplo, la ITV fue rápida o esta obra de teatro se pasó rápido.
 
 **6. Discurso**
 Para ámbito de la investigación sobre todo
 
 **7. Conocimiento del mundo**
 Usar el lenguaje es trasmitir estados mentales.
 Lo común de estados mentales y que les permite comunicarse facilmente.
 
 Por ejemplo: Me voy a vivir a Francia. Jo, pero hablas francés?
 
 O le metes un montón de conocimiento del mundo o estás jodido para un bot que responda de manera inteligente.
 Se suele hacer con bases de conocimiento que se llaman ontologías, lo cual es una manera de representar formalmente conocimiento del mundo.
 
 Ontología: conjunto de tripletas.
 (concepto1_id, concepto2_id, relacion) 
 (hipopótamo_id, plantas_id, comen)
 
 En asistentes o bots las ontologías tienen que ser muy muy complejas.
 Por ejemplo, se está llevando mucho creción de ontologías de Wikipedia.
 
 
### Ejemplos 

- Las ranas verdes tienen la nariz grande
se rompe la prágmatica

- las ideas verdes tiene la nariz grande.
Se rompe la semántica (no puedo decir si es verdad o mentira)
una idea tendría un rasgo abstracto, por lo cual no podría tener un rasgo mas concreto.
Aqui necesitamos los rasgos semánticos (semas)

- la las tienene verdes grandes nariz ideas.
Se rompe la sintaxis.

## Segmentación en frases
Segmentar con puntos es muy débil, dado que existen Sr., D., etc. que también terminan en punto o incluso gente que escribe mal y no pone puntos.

LA discriminación sintaxica ayuda con esto.

TNS: categorizar opiniones de la gente

## Segmentación en tokens
La función split de python.
Los problemas de tokenización son mas fáciles de resolver que los problemas de segmentación en frases.

## Etiquetado morfológico
PoS: part of speech

## lematización
masculino singular en el caso de los sustantivos
infinitivo en caso de los verbos
fortisimo a fuerte

## eliminación de stop words
Palabras qe no te interesan para una determinada tarea

## etiquetado dependencial (etiquetado sintáctico)
la depende de capital con una relación de tipo -> determinante

## localización de los sintagmas nominales

## reconocimiento de entidades nombradas
LOC: location

# Resolución de correferencias
En castellano, no funciona muy bien las librerías en abierto.



# Wordnet 
Es lexica porque almacena palabra y no 
pensada principalmente para el ingles
sustantivos, verbos y adjetivos
Se basa en agrupar las palabras en conjuntos de sinónimos, en relaciones de hiperonimia y hiponimia.
hiperonimo de mesa es mueble. Relaciones de tipo de. Esta es la principal estructura de wordnet

tambien hay relaciones de parte de, por ejemplo, bicicleta y manillar. Pero estas relaciones son mucho menos frecuentes.

moverse -> andar -> correr
gustar -> amar -> idolatrar


El arbol sintáctico da mucho mas infrmación que estrucutras como wordnet-

Chequear tambien framenet

# Babble net 

La API para python no la hecho el equipo de BabbleNet y normalmente la API que se suele usar es la de JAVA
y las queries generalmente en SPARQL

Se le considera mas bien una red semántica, porque incluye mas relaciones de entidades, no de palabras.

Usa wordnet como motor para interpretar las palabras de la wikipedia.

Wikipedia tiene un monton de información de RDF (este es el padre de este)

Se hizo para el inglés  y para el resto de las lenguas se hizo con traducción automática.


# Bdpedia 


Todos los datos de preguntas como "con quien se caso Barack obama" suelen salir de aqui

# PLN
## Metodologia basado en reglas
Personas que conocen muy bien la lengua son capaces de codificar la estructura de un idiama


## Metodologia basado en estadistica / redes neuronales
etiquetamos una serie de datos y le pedimos al sistema que nos infiera el resto


