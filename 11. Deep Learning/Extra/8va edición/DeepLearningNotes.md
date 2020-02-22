# 08 Sep 2018. DeepLearning notes

## Introducción

La clase se reduce a aprendizaje supervisado, pero también se puede usar en aprendizaje no supervisado.
Un ejemplo de no supervisado podría ser cómo Android descarga las imágenes a tu movil.

**Enfoque tradicional**
entrada: situación de tablero y conjunto de reglas
salida: movimiento

**Enfoque machine learning**
entrada: datos con muchas partidas y los diferentes resultados
salida: movimiento

Deep learning es un conjunto de técnicas específicas que usan redes neuronales.

## Red neuronal
cada capa hace una multiplicación matricial
tensores: matrices de matrices

Qué hace el cientifico de datos:
- Define el numero de capas
- Define el modelo
- Definir el loss function
- Método de optimización que se usa para obtener el mínimo
- Cómo se inicializan las matrices en el primer paso

La capa inicial genera números de manera aleatoria. Como la primera estimación era incorrecta, calcula el gradiente y ejecuta  back propagation para actualizar los valores de la primera matriz
El gradiente que se suele usar es el SGD (gradiente descendiente estocástico). Hay varios de estos, en función de lo queramos hacer se usa uno u otro.


### Cómo aprende una red neuronal
La primera IA es de los años 50 y la primera red de los 60.
Aprendemos una representación de los datos que hace que la resolución del problema sea mas sencilla.
Esa representación probablemente no sea legible por los humanos, por lo que son modelos de caja negra. Lo cual en ocasiones limita las aplicaciones que tiene, muchas veces por temas legales (como en los bancos en si se da la hipoteca)

### Resumen de pasos
0. Validation split + Feature engineer (normalización, flattern)
1. Elegir capas --> input_shape
2. Capas de activacion
3. Optimizador (no tiene demasiada influencia)
4. Funcion de pérdidas. Esto es crítico
5. Otros hiperparámetros: Epocas y batch_size





