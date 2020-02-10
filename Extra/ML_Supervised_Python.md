# Preparing data 
```python
# Input
X = df[['TotalSF']] # pandas DataFrame
# Label
y = df["SalePrice"] # pandas Series

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.10)
```

# Cross Validation and Grid Search

## Cross Validation
We calculate metric for several subsets (determine by cv) with cv=5, we will have 5 results from 5 training/test
```python
from sklearn.model_selection import cross_val_score
cross_val_score(reg,X,y,cv=5,scoring="neg_mean_squared_error")
```
## Grid Search{.tabset}
```python
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import GridSearchCV

reg_test = GridSearchCV(KNeighborsRegressor(),
                        param_grid={"n_neighbors":np.arange(3,50)})
reg_test.fit(X,y)
reg_test.best_score_
reg_test.best_estimator_
reg_test.best_params_
```

# Regression

## Linear Regression 
```python
from sklearn.linear_model import LinearRegression
reg = LinearRegression()
reg.fit(X,y)
reg.predict([[2540],[3500],[4000]])
```

## K nearest neighbors
```python
from sklearn.neighbors import KNeighborsRegressor
regk = KNeighborsRegressor(n_neighbors=2)
regk.fit(X,y)
```

## Decision Tree
* Max_depth: Number of Splits
* Min_samples_leaf: Minimum number of observations per leaf
```python
from sklearn.tree import DecisionTreeRegressor
regd = DecisionTreeRegressor(max_depth=3)
regd.fit(X,y)
```
## Random Forest
* __n_estimators__ #tree
* __max_depth__ max #Splits
* __min_samples_leaf__ min #observations per leaf
```python
from sklearn.ensemble import RandomForestRegressor
regr = RandomForestRegressor(n_estimators = 100, max_depth = 10, min_samples_leaf = 20)
cross_val_score(regr,X,y,cv=5,scoring='accuracy').mean()
# Gradient Boosting Tree
```

# Classification
## Logistic regression
```python
from sklearn.linear_model import LogisticRegression
clf=LogisticRegression()
clf.fit(X,y)
```
## K nearest neighbors
```python
from sklearn.neighbors import KNeighborsClassifier
regk = KNeighborsClassifier(n_neighbors=2)
regk.fit(X,y)
```

## Decision Tree
```python
from sklearn.tree import DecisionTreeClassifier
clf = DecisionTreeClassifier(min_samples_leaf=20,max_depth=3)
clf.fit(X,y)
```
## Support Vector Machine
Parameters:
* C: Sum of Error Margins
* kernel:
 * linear: line of separation
 * rbf: circle of separation
    * Additional param gamma: Inverse of the radius
 * poly: curved line of separation
    * Additional param degree: Degree of the polynome
```python
from sklearn.svm import SVC
clf = SVC(kernel="linear",C=10)
clf.fit(X,y)
```
## Random Forest
* __n_estimators__ #tree
* __max_depth__ max #Splits
* __min_samples_leaf__ min #observations per leaf
```python
from sklearn.ensemble import RandomForestClassifier
clfr = RandomForestClassifier(n_estimators = 100, max_depth = 10, min_samples_leaf = 20)
cross_val_score(clfr,X,y,cv=5,scoring='accuracy').mean()
```

## Gradient Boosting Tree
```python
from sklearn.ensemble import GradientBoostingRegressor
gbr = GradientBoostingRegressor(max_depth=4, n_estimators=100, learning_rate=0.1)
cross_val_score(gbr,X,y,scoring='neg_mean_absolute_error').mean()
```

# Metrics
## Regression

### MAE
```python
from sklearn.metrics import mean_absolute_error
mean_absolute_error(reg.predict(X_test),y_test)
```

### MAPE
```python
np.mean(np.abs(reg.predict(X_test)-y_test)/y_test)
```

### RMSE
```python
from sklearn.metrics import mean_squared_error
np.sqrt(mean_squared_error(reg.predict(X_test),y_test))
```

### Correlation
```python
# Direct Calculation
np.corrcoef(reg.predict(X_test),y_test)[0][1]
# Custom Scorer
from sklearn.metrics import make_scorer
def corr(pred,y_test):
   return np.corrcoef(pred,y_test)[0][1]

cross_val_score(reg,X,y,cv=5,scoring=make_scorer(corr))
```

### Bias
```python
# Direct Calculation
np.mean(reg.predict(X_test)-y_test)
# Custom Scorer
from sklearn.metrics import make_scorer
def bias(pred,y_test):
   return np.mean(pred-y_test)

cross_val_score(reg,X,y,cv=5,scoring=make_scorer(bias))
```
## Classification
### Accuracy
```python
from sklearn.metrics import accuracy_score
accuracy_score(y_test,clf.predict(X_test))
# Cross Validation
cross_val_score(clf,X,y,scoring="accuracy")
```

## Confusion Matrix 
$\begin{bmatrix}
TN & FN \\ 
FP & TP 
\end{bmatrix}$
* Precision = TP / TP+FP 
* Recall = TP / TP+FN --> como de bien predice los 1
```python
from sklearn.metrics import confusion_matrix
confusion_matrix(y_test, clfK.predict(X_test))
```

### Precision and Recall
```python
# Metrics
from sklearn.metrics import precision_score, recall_score
from sklearn.metrics import classification_report
precision_score(y_test,clf.predict(X_test))
classification_report(y_test,clf.predict(X_test))
# Cross Validation
cross_val_score(clf,X,y,scoring="precision")
cross_val_score(clf,X,y,scoring="recall")
```
### ROC curve
```python
from sklearn.metrics import roc_curve
# We chose the target
target_pos = 1 # Or 0 for the other class
fp,tp,_ = roc_curve(y_test,pred[:,target_pos])
plt.plot(fp,tp)
```
#### AUC
```python
# Metrics
from sklearn.metrics import roc_curve, auc
fp,tp,_ = roc_curve(y_test,pred[:,1])
auc(fp,tp)
# Cross Validation
cross_val_score(clf,X,y,scoring="roc_auc")
```
# DRAW
```python
def draw(clf,X,y,h=0.05):
    
    plt.figure(figsize=(7,7))

    x_min, x_max = X[:, 0].min() - 0.05, X[:, 0].max() + .05
    y_min, y_max = X[:, 1].min() - .05, X[:, 1].max() + .05
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h),
                         np.arange(y_min, y_max, h))
    
    if clf is not None:
        Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
        Z = Z.reshape(xx.shape)
        plt.scatter(xx,yy,c=Z)
    else:
        plt.scatter(xx,yy)
    
    plt.scatter(X[:,0],X[:,1],c=y,cmap="Paired")
```
    
# SAVE/LOAD MODEL
```python
import pickle
pickle.dump(clf, open('modelo.pickle','wb'))
clf_loaded = pickle.load(open('modelo.pickle','rb'))
clf_loaded.get_params
```
