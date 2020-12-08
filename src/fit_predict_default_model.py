# author: Selma Duric
# date: 2020-11-26

'''Fits pre-processed data on baseline, Decision Tree and Logistic Regression models.
Saves results in output file.

Usage: src/fit_predict_default_model.py --train_data=<train_data> --test_data=<test_data> --hp_out_dir=<hp_out_dir> --prelim_results_dir=<prelim_results_dir>

Options:
--train_data=<train_data>   Path to training data file in feather format.
--test_data=<test_data>     Path to test data file in feather format.
--prelim_results_dir=<prelim_results_dir> Path from root (incl. filename) where to save results from initial models.
--hp_out_dir=<hp_out_dir>   Path from root (incl. filename) where to save results from hyperparameter optimization as csv.
'''

# import libraries
from docopt import docopt
import os
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

opt = docopt(__doc__)

def main(train_data, test_data, out_dir, prelim_results_dir):
    # read in data sets
    train_df = pd.read_feather(train_data)
    train_df.loc[:,'sex_1':'default'] = train_df.loc[:,'sex_1':'default'].astype('int')
    X_train, y_train = train_df.drop(columns='default'), train_df['default']

    test_df = pd.read_feather(test_data)
    test_df.loc[:,'sex_1':'default'] = test_df.loc[:,'sex_1':'default'].astype('int')
    X_test, y_test = test_df.drop(columns='default'), test_df['default']

    predict_df, best_model, prelim_results = prediction(X_train, y_train)
    test_result = predict_test(X_train, y_train, X_test, y_test, best_model)

    try:
        predict_df.to_csv(out_dir, index=False)
        prelim_results.to_csv(prelim_results_dir)
    except:
        os.makedirs(os.path.dirname(out_dir))
        predict_df.to_csv(out_dir, index=False)
        prelim_results.to_csv(prelim_results_dir)


def prediction(X_train, y_train):
    """Fits given training data on random forest and logistic regression classifiers and returns scoring results with best model.
    Carries out hyperparameter optimization on both to find best model.

    Parameters
    ----------
    X_train: dataframe
        training data without target for model fitting
    y_train: dataframe
        training target for model fitting
    Returns
    ----------
    hyperparam_df: dataframe
        scoring results of RandomForestClassifier() and LogisticRegression() hyperparameter optimization.
    best_model: scikit-learn classification model
        best model chosen to use for testing
    results_dict: dataframe
        scoring results of models based on chosen scoring methods with default hyperparameters
    """
    assert X_train.shape[0] == y_train.shape[0], "data sets not the same size"
    results_dict = {}
    # set scoring
    scoring = ['f1', 'accuracy']  # use f1 scoring because of class imbalance

    # baseline model
    print("Running baseline")
    dummy_model = DummyClassifier(strategy='prior')
    scores = cross_validate(dummy_model, X_train, y_train, return_train_score=True, scoring=scoring)
    store_results("Baseline", scores, results_dict)

    # model 1 Random Forest
    print("Running model 1")
    rf_model = make_pipeline(RandomForestClassifier())
    scores = cross_validate(rf_model, X_train, y_train, return_train_score=True, scoring=scoring)
    # scores
    store_results("Random Forest", scores, results_dict)

    # model 2 Logistic Regression
    print("Running model 2")
    logreg_pipeline = make_pipeline(LogisticRegression(max_iter=600, class_weight="balanced"))
    scores = cross_validate(logreg_pipeline, X_train, y_train, return_train_score=True, scoring=scoring)
    store_results("Logistic Regression", scores, results_dict)
    results_dict= pd.DataFrame(results_dict)

    print(results_dict)

    # hyperparameter optimization on best models
    print("Optimizing hyperparameters for model 1")
    param_dist = {
        "n_estimators": scipy.stats.randint(low=10, high=300),
        "max_depth": scipy.stats.randint(low=1, high=5000)
    }
    random_search = RandomizedSearchCV(RandomForestClassifier(), param_dist, n_iter=5, cv=5, random_state=120, scoring=scoring[0])
    random_search.fit(X_train, y_train)

    best_score_rf = random_search.best_score_
    best_est_rf = pd.DataFrame(random_search.best_estimator_)
    best_cv_rf = random_search.cv_results_
    hyperparam_df = pd.DataFrame(best_cv_rf)[['mean_test_score', 'params']]
    hyperparam_df['model'] = 'RandomForest'

    print("Optimizing hyperparameters for model 2")
    param_dist = {
        "class_weight": ["balanced", "none"],
        "C": scipy.stats.randint(low=0, high=1000)
    }
    random_search = RandomizedSearchCV(LogisticRegression(max_iter=600), param_dist, n_iter=5, cv=5, random_state=120, scoring=scoring[0])
    random_search.fit(X_train, y_train)
    best_cv_logr = random_search.cv_results_
    best_hp_log = random_search.best_estimator_
    log_reg_df = pd.DataFrame(best_cv_logr)[['mean_test_score', 'params']]
    log_reg_df['model'] = 'LogisticRegression'

    # Compile results of hyperparameter optimization
    hyperparam_df = hyperparam_df.append(log_reg_df).sort_values('mean_test_score', ascending=False).reset_index(drop=True)
    column_test_name = "mean " + scoring[0] +" score"
    hyperparam_df = hyperparam_df.rename(columns={'mean_test_score': column_test_name})
    # Pick best classifier
    if hyperparam_df["model"][0] == 'RandomForest':
        best_model = best_est_rf
    else: best_model = best_hp_log

    return hyperparam_df, best_model, results_dict



def predict_test(X_train, y_train, X_test, y_test, best_model):
    """Fits a provided optimal model on given training set and outputs best score on test data.

    Parameters
    ----------
    X_train: dataframe
        training data without target for model fitting
    y_train: dataframe
        training target for model fitting
    X_test: dataframe
        test data without target to score
    y_test: dataframe
        test data target to score
    best_model : scikit-learn classification model
        model to fit on training data and run on test data
    Returns
    ----------
    test_score: float
        score achieved on test data
    """
    assert X_test.shape[0] == y_test.shape[0], "data sets not the same size"
    # Score on test data using best model
    print("Scoring test data...")
    best_model.fit(X_train, y_train)

    y_pred = best_model.predict(X_test)
    test_score = f1_score(y_test, y_pred)
    print(f"Best test score: {test_score}")
    return test_score


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

if __name__ == "__main__":
    main(opt["--train_data"], opt["--test_data"], opt["--hp_out_dir"], opt["--prelim_results_dir"])