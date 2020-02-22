```python
%pylab inline
import pandas as pd

from importlib import reload # Reload Library
relo
ad(pd)

import os
os.getcwd() #get current directory
```

# TIPS

## Enumerate
```python
for i, elements in enumerate(planets):
    pass
```
## ZIP
```python
planets =('mercurio', 'venus','tierra','mars')    
n_moons = [0,0,1,2]
list(zip(planets, n_moons))
# [('mercurio', 0), ('venus', 0), ('tierra', 1), ('mars', 2)]
```

## Comprehension
```python
[n for n in range(10) if n % 2 ==0] #even number < 10

```

# NUMPY
## Generate Random Data
```python
np.linspace(0, 19, 5) # 5 numbers between 0 and 19
np.arange(0,10,2)     # Even numbers between 0 and 10
np.random.normal(size=5) #5 random numbers from a Normal Distribution
np.random.randint(10, size=15) #15 natural numbers less than 10
np.random.shuffle(a) #Shuffle a list o maxtrix

import random
random.randrange(0, 100, 7) #return one number between 0 and 100 multiple of 7
```

## Strings
```python
sentence = 'abcdefghijklmnñopqrstuvwxyz'
sentence[2::3] #from second character until the end taking 3 by 3
sentence[::-1] #reverse
```

## Be careful when copying
```python
a = [2,3] ; b = [3,2]
a = b[:]   # different objects
a = b.copy # different objects
a = b      # reference the same object, if one is updated then the other is also updated
```
## Lists
```python
List.sort() y List.reverse() # update list

list(sorted(list)) y list(reversed(List)) # devuelve la lista ordenada o al reves pero sin modificarla
```

# PANDAS
## Dummies
Convert categorical variable into dummy/indicator variables
```python
def createDummies(df, var_name):
    dummy = pd.get_dummies(df[var_name], prefix=var_name)
    df = df.drop(var_name, axis = 1)
    df = pd.concat([df, dummy ], axis = 1)
    return df
```

## Prints
```python
name ='hitos'
birth = 1990
print('{} will reach 100 years in {}'.format(name, birth))
print(name, 'will reach 100 years in', birth + 100)
message = '%s will reach 100 years in %s' %(name,birth + 100)
print(message)
print(name + ' will reach 100 years in ' + str(birth + 100))
print('\t tabulator \n line break') 
print('-'*70) # print 70 times "-"
```

## Functions
```python
## Functions
def function_name(variable=(0,0)): # Default value (0,0)
    'Function Description, help(function_name) returns the text in here'
    return ....
    
# fun1() or fun2() or fun3() = the first returned value different than None
```

## Functional Programming
```python
map(lambda n: n**2, input_list)
map(function_name, input list)

filter(lambda n: n<10, input_list)
filter(function_name, input_list)
[element for element in input_list if function_name(element)]

list(map(lambda n: n**2,filter(function_name, input_list)))

from functools import reduce
reduce(function_name, input_list) # function_name takes 2 and only 2 parameters
``
