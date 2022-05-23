import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv('20016345D_LSGI4502_FYP.csv')

df.head()
X_df = df.iloc[:, :6]
X_df.head()

# Split Data into input and Output Columns
X = X_df

# separate all the columns which are to be predicted
pred_df = df.iloc[:, 6:]

# first train and test the models on MaaS_Interest column and then one # by one on others
y = df['MaaS_Interest']
pred_df.head()
df['MaaS_Familiarity'].value_counts()

from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=20, random_state=42)

clf = DecisionTreeClassifier(max_depth=4, random_state=1)
clf.fit(X_train, y_train.astype('int'))
clf.score(X_test, y_test)

clf = RandomForestClassifier(max_depth=15)
clf.fit(X_train, y_train.astype('int'))
clf.score(X_test, y_test)

clf = LogisticRegression(C=6)
clf.fit(X_train, y_train.astype('int'))
clf.score(X_test, y_test)

from sklearn.naive_bayes import GaussianNB
from sklearn.naive_bayes import CategoricalNB

clf = CategoricalNB(alpha=100)
clf.fit(X_train, y_train.astype('int'))
clf.score(X_test, y_test)

# random search logistic regression model on the sonar dataset
from scipy.stats import loguniform
from pandas import read_csv
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.model_selection import RandomizedSearchCV

# load dataset
# split into input and output elements
# define model
model = LogisticRegression()

# define evaluation
cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)

# define search space
space = dict()
space['solver'] = ['newton-cg', 'lbfgs', 'liblinear']
space['penalty'] = ['none', 'l1', 'l2', 'elasticnet']
space['C'] = loguniform(1e-5, 100)

# define search
search = RandomizedSearchCV(model, space, n_iter=500, scoring='accuracy', n_jobs=-1, cv=cv, random_state=1)

# execute search
result = search.fit(X, y)

# summarize result
print('Best Score: %s' % result.best_score_)
print('Best Hyperparameters: %s' % result.best_params_)

from sklearn.ensemble import RandomForestClassifier, VotingClassifier

clf1 = LogisticRegression(random_state=1)
clf2 = RandomForestClassifier(n_estimators=50, random_state=1)
clf3 = GaussianNB()
clf4 = CategoricalNB()

eclf1 = VotingClassifier(estimators=[('lr', clf1), ('rf', clf2), ('gnb', clf3), ('cnb', clf4)], voting='soft')
eclf1 = eclf1.fit(X_train, y_train)
print(eclf1.score(X_test, y_test))

from sklearn.ensemble import GradientBoostingClassifier

clf = GradientBoostingClassifier().fit(X_train, y_train)
clf.score(X_test, y_test)

get_ipython().system('pip install mlxtend')

import joblib
import sys

sys.modules['sklearn.externals.joblib'] = joblib

sys.modules['sklearn.externals.joblib'] = joblib

from mlxtend.feature_selection import SequentialFeatureSelector as sfs

lreg = CategoricalNB(alpha=100)
sfs1 = sfs(lreg, k_features=2, forward=True, verbose=2, scoring='accuracy')

sfs1 = sfs1.fit(X_train, y_train)

from sklearn.preprocessing import StandardScaler
from sklearn.naive_bayes import BernoulliNB

clf = BernoulliNB()
clf.fit(X_train, y_train)
clf.score(X_test, y_test)

clf = CategoricalNB(alpha=1)
clf.fit(X, pred_df['MaaS_Familiarity'])
clf.score(X, pred_df['MaaS_Familiarity'])


from sklearn.datasets import make_classification
from sklearn.multioutput import MultiOutputClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.multioutput import MultiOutputClassifier
from sklearn.utils import shuffle
from sklearn.datasets import make_regression
from sklearn.multioutput import MultiOutputRegressor
from sklearn.ensemble import GradientBoostingRegressor

# clf=MultiOutputClassifier(CategoricalNB(alpha=100)).fit(X, pred_df)

forest = RandomForestClassifier(random_state=1)
multi_target_forest = MultiOutputClassifier(forest, n_jobs=-1)
clf_fit = multi_target_forest.fit(X, pred_df)

clf_fit.score(X, pred_df)
clf_fit.predict(X)

# ## MaaS Data Prediction
df_fill = pd.read_csv('20016345D_LSGI4502_FYP_Updated.csv')

X_new = df_fill
y_new = clf_fit.predict(X_new)
results = pd.DataFrame(y_new, columns=pred_df.columns)
data_filled = df_fill.join(results)

# output the predicted result
data_filled.to_csv('20016345D_LSGI4502_FYP_Output.csv')
