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
import numpy as np
import pandas as pd
from sklearn.dummy import DummyClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import f1_score, recall_score
from sklearn.model_selection import (
    RandomizedSearchCV,
    cross_validate,
    train_test_split,
)
from sklearn.pipeline import Pipeline, make_pipeline
import scipy
from scipy.stats import randint
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
        "mean_accuracy_train": "{:0.4f}".format(np.mean(scores["train_accuracy"])),
        "mean_accuracy_validation": "{:0.4f}".format(np.mean(scores["test_accuracy"])),
        "mean_f1_train": "{:0.4f}".format(np.mean(scores["train_f1"])),
        "mean_f1_validation": "{:0.4f}".format(np.mean(scores["test_f1"])),
    }


# data set
train_df = pd.read_feather('../data/processed/training.feather')
train_df.loc[:,'sex_1':'default'] = train_df.loc[:,'sex_1':'default'].astype('int')
X_train, y_train = train_df.drop(columns='default'), train_df['default']

results_dict = {}

# set scoring
scoring = ['f1', 'accuracy']  # use f1 scoring because of class imbalance

# baseline model
print("Running baseline")
dummy_model = DummyClassifier(strategy='prior')
scores = cross_validate(dummy_model, X_train, y_train, return_train_score=True, scoring=scoring)
store_results("Dummy", scores, results_dict)

# model 1 Random Forest
print("Running model 1")
rf_model = make_pipeline(RandomForestClassifier())
scores = cross_validate(rf_model, X_train, y_train, return_train_score=True, scoring=scoring)
# scores
store_results("Random Forest", scores, results_dict)

# model 2 Logistic Regression
print("Running model 2")
logreg_pipeline = make_pipeline(LogisticRegression(max_iter=300, class_weight="balanced"))
scores = cross_validate(logreg_pipeline, X_train, y_train, return_train_score=True, scoring=scoring)
store_results("Logistic Regression", scores, results_dict)
pd.DataFrame(results_dict)

print(results_dict)

# hyperparameter optimization on best model
print("Optimizing hyperparameter 1")
param_dist = {
    "n_estimators": scipy.stats.randint(low=10, high=300),
    "max_depth": scipy.stats.randint(low=1, high=5000)
}
random_search = RandomizedSearchCV(RandomForestClassifier(), param_dist, n_iter=5, cv=5, random_state=120, scoring='f1')
random_search.fit(X_train, y_train)

best_score_rf = random_search.best_score_
best_est_rf = pd.DataFrame(random_search.best_estimator_)
best_cv_rf = random_search.cv_results_

hyperparam_df = pd.DataFrame(best_cv_rf)[['mean_test_score', 'params']].sort_values('mean_test_score', ascending=False)
hyperparam_df['model'] = 'RandomForest'

print("Optimizing hyperparameter 2")
param_dist = {
    "class_weight": ["balanced", "none"],
    "C": scipy.stats.randint(low=0, high=1000)
}
random_search = RandomizedSearchCV(LogisticRegression(max_iter=600), param_dist, n_iter=5, cv=5, random_state=120, scoring='f1')
random_search.fit(X_train, y_train)

best_cv_logr = random_search.cv_results_
best_hp_log = random_search.best_estimator_

log_reg_df = pd.DataFrame(best_cv_logr)[['mean_test_score', 'params']].sort_values('mean_test_score')
log_reg_df['model'] = 'LogisticRegression'

hyperparam_df=hyperparam_df.append(log_reg_df).sort_values('mean_test_score', ascending=False).reset_index(drop=True)

# Score on test data.
print("Scoring test data...")
test_df = pd.read_feather('../data/processed/training.feather')
test_df.loc[:,'sex_1':'default'] = test_df.loc[:,'sex_1':'default'].astype('int')
X_test, y_test = test_df.drop(columns='default'), test_df['default']

# use best model on test
best_model = best_hp_log
best_model.fit(X_train, y_train)

y_pred = best_model.predict(X_test)
test_score = f1_score(y_test, y_pred)
print(f"Best test score: {test_score}")

print("Complete")

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
        "mean_accuracy_train": "{:0.4f}".format(np.mean(scores["train_accuracy"])),
        "mean_accuracy_validation": "{:0.4f}".format(np.mean(scores["test_accuracy"])),
        "mean_f1_train": "{:0.4f}".format(np.mean(scores["train_f1"])),
        "mean_f1_validation": "{:0.4f}".format(np.mean(scores["test_f1"])),
    }