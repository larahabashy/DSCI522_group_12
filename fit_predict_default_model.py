# author: Selma Duric
# date: 2020-11-26

'''Fits pre-processed data on baseline, Decision Tree and Logistic Regression models.
Saves results in output file.

Usage: src/fit_predict_default_model.py --train_data=<train_data> --out_dir=<out_dir>

Options:
--train_data=<train_data>   Path to training data file
--out_dir=<out_dir>         Path (including filename) where to save results. 
'''

# import libraries
from docopt import docopt
import numpy as np
import pandas as pd
from sklearn.dummy import DummyClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import (
    RandomizedSearchCV,
    cross_validate,
    train_test_split,
)
from sklearn.pipeline import Pipeline, make_pipeline

# data set
train_df = pd.read_csv('data/dataset.csv')
X_train, y_train = train_df.drop(columns='Y'), train_df['Y']

results_dict = {}

# baseline model

scoring = ['f1']  # use f1 scoring because of class imbalance
dummy_pipeline = make_pipeline(DummyClassifier())
scoring = cross_validate(dummy_pipeline, X_train, y_train, return_train_score=True, scoring=scoring)
store_results("Baseline", scoring, results_dict)

# model 1 Random Forest
tree_pipeline = make_pipeline(RandomForestClassifier())
scoring = cross_validate(tree_pipeline, X_train, y_train, return_train_score=True, scoring='f1')
store_results("Random Forest", scoring, results_dict)

# model 2 Logistic Regression
logreg_pipeline = make_pipeline(LogisticRegression())
scoring = cross_validate(logreg_pipeline, X_train, y_train, return_train_score=True, scoring='f1')
store_results("Logistic Regression", scoring, results_dict)

print(results_dict)
# hyperparameter optimization on best model
param_grid = {" __ ": }
random_search = RandomizedSearchCV( , param_grid, n_iter=20, cv=5, random_state=120)
random_search.fit(X_trian, y_train)

# Store optimized hyperparameter model in dictionary.


# Score on test data.
#best_model.fit(X_train, y_train)
#best_model.predict(X_test, y_test)
## add score to output table.


# Output table of results, sorted.

def store_results(model, scores, results_dict):
    """Stores mean cross-validation results for given model.
    Adapted from DSCI 571 course notes.

    Parameters
    ----------
    model : scikit-learn classification model
    scores : dict
        cross-validate result
    results_dict : dict
        dictionary of mean results
    Examples
    ----------
    store_results(dummy_model, scores, results)
    """
    results_dict[model] = {
        "mean_f1_train": "{:0.4f}".format(np.mean(scores["train_f1"])),
        "mean_f1_validation": "{:0.4f}".format(np.mean(scores["test_f1"]))
    }
