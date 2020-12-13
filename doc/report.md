Credit Card Default Prediction
================
Selma Duric, Lara Habashy, Hazel Jiang</br>
11/28/2020

  - [Summary](#summary)
  - [Introduction](#introduction)
  - [Methods](#methods)
      - [Data](#data)
      - [Analysis](#analysis)
  - [Results & Discussion](#results-discussion)
  - [References](#references)

## Summary

Here we attempt to apply two machine learning models
`LogisticRegression` and `RandomForest` on a credit card default data
set and find the better model with optimized hyperparameter to predict
if a client is likely to default payment on the credit card in order to
lower the risk for banks to issue credit card to more reliable clients.
`LogisticRegression` performed better compared to `RandomForest`. Our
best prediction has f1 score of 0.51 with optimzed hyperpameter of
*C=382* and *class\_weight=‘balanced’*.

## Introduction

In recent years, credit card becomes more and more popular in Taiwan.
Because card-issuing banks are all trying to increase market share,
there exists more unqualified applicants who are not able to pay their
credit card on time. This behavior is very harmful to both banks and
cardholders.(Yeh and Lien 2009) It is always better to prevent than to
solve a problem. By detecting patterns of people who tend to default
their credit card payment, banks are able to minimize the risk of
issuing credit card to people who may not be able to pay on time.

Here we would like to use a machine learning algorithm to predict
whether a person is going to default on his/her credit card payment. We
plan to try both `Logistic Regression` and `Random Forest` on the
training data with default parameter and optimized hyperparameters. We
will pick the best performing model with optimized hyperparameters to
predict on the test data. Thus, if the machine learning algorithm can
make accurate prediction, banks are able to find reliable applicants and
minimize their loss on default payment.

## Methods

### Data

The dataset we are using in the project is originally from Department of
Information Management in Chun Hua University, Taiwan and Department of
Civil Engineering in Tamkang University, Taiwan. It was sourced from UCI
Machine Learning Repository and can be found
[here](http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients#).
Specifically, [This
file](http://archive.ics.uci.edu/ml/machine-learning-databases/00350/default%20of%20credit%20card%20clients.xls)
is what we used to build the model. This dataset has information on
default payments of credit card in Taiwan from April to September 2005.
There are 30,000 observations of distinct credit card clients in this
data set with each row representing a unique client. There are 25
variables in total. Within the 25 variables, 23 of them are useful
features for the prediction (we will drop `ID` column since it is
irrelevant to the prediction). Our target is
`default.payment.next.month` column. There are 2 classes in the column,
with `class 0` respect to payment on time and with `class 1` respect to
default on payment. We notice there exists class imbalance in the target
column. 77.9% of the examples are belong to `class 1` and only 22.1% of
examples belong to `class 0`. Because we are interested to find
customers who are likely to default on their payment, predicting
`class 1` correctly is more imortant to us. Instead of getting a good
accuracy score, we care more about the recall score. At the same time,
precision score is also very important because if we predict customers
to the wrong class, it my hurt customer loyalty. Therefore, considering
the importance of both recall and precision, we will use f1 score as our
metrics for assessment.

### Analysis

Based on the description of the dataset, we divided features into 2
types, numerical features and categorical features. In terms of
numerical features, each individual have the same 6 month time periods
for bill statements and previous payment monthly (measured in dollar
amounts) as well as the history of past payment `PAY_0`, `PAY_2`…`PAY_6`
that representing the delay of the repayment in months. Furthermore, we
also have credit card limit (`LIMIT_BAL`) and age as our numerical
features. We examined the correlation between all the numerical features
and the target, based on the plot we found that credit limit is likely
to be negative correlated to the target and age is slightly positive
correlated to the target. Also, `BILL_AMT` features are negative
correlated to our target, and the further the `BILL_AMT`(compare to the
due date), the less correlative it is to the target.

\*\*\*\*\*\*\* ADD PLOT \*\*\*\*\*\*\*\*

In terms of categorical features, we have `SEX`, `EDUCATION` and
`MARRIAGE`. Based on the plot and data description, we have 6 categories
for `EDUCATION` with 1=graduate school, 2=university, 3=high school,
4=others and 5,6=unknown. It seems like people with high school
education has a higher proportion of default payments. It drew our
attention that we do not have a lot of data for category 4, 5 and 6, nor
do we know what they actually mean. Without further information, it may
have minor affect on our prediction accuracy.

\*\*\*\*\*\* ADD PLOT \*\*\*\*\*\*\*\*

We have a more detailed description and analysis on the data we have in
our EDA report, including confusion matrix and how we transform data.
The EDA report can be found
[Here](https://github.com/UBC-MDS/DSCI522_group_12/blob/main/src/project_eda.md)

Both a linear classification model `LogisticRegression` and an ensemble
decision tree classification model `RandomForest` from
scikit-learn(Pedregosa et al. 2011) will be used to build this
classification model. We will compare the their performance with default
parameters first then apply hyperparameter tuning. The appropriate
hyperparameters were chosen using `RandomSearchCV` with 5 iteration and
5-fold cross validation. We will optimize `class_weight` and `C`
hyperparameters for `Logistic Regression` and `n_estimators` and
`max_depth` for `Random Forest`. The R(R Core Team 2020) and Python(Van
Rossum and Drake 2009) programming languages and the following R and
Python packages were used to perform the analysis: docopt(de Jonge
2018), feather(Wickham 2019), knitr(Xie 2020), tidyverse(Wickham
2017)and Pandas(team 2020).

The code used to perform the analysis and create this report can be
found [here](https://github.com/UBC-MDS/DSCI522_group_12/tree/main/src)

## Results & Discussion

To look at which model is better for prediction, we first compare the
two models with default hyperparameters. We used `DummyRegression` with
`strategy='prior'` as our baseline. Although it has an accuracy score of
0.78, it is not very reliable because we have class imbalance in the
data set and f1 score is more important in our prediction. Our baseline
has f1 score of 0, which is not good. On the other hand, both
`RandomForest` and `LogisticRegression` has better score on f1.
`RandomForest` has a very high f1 on the training set, but the score is
low on the validation set, and there exists a huge gap between the two
scores, which means we have an overfitting problem. On the other hand,
`LogisticRegression` has very similar training and validation f1 scores,
it has a higher f1 score compared to `RandomForest` model. Therefore, we
believe `LogisticRegression` is a better model to use for prediction.

| X1                         | Baseline | Random Forest | Logistic Regression |
| :------------------------- | -------: | ------------: | ------------------: |
| mean\_accuracy\_train      |   0.7788 |        0.9995 |              0.7448 |
| mean\_accuracy\_validation |   0.7788 |        0.8155 |              0.7440 |
| mean\_f1\_train            |   0.0000 |        0.9988 |              0.5125 |
| mean\_f1\_validation       |   0.0000 |        0.4707 |              0.5108 |

Table 1.Comparison between accuracy and f1 with default hyperparameters
for each model

Since the validation scores were comparable, we decided to tune
hyperparameters for both models and compare the results with the
previous table. The hyperparameters we chose for `RandomForest` is
`n_estimators` (low=10, high=300) and `max_depth` (low=1, high=5000).
The hyperparameters for `LogisticRegression` is `class_weight`
(“balanced” vs “none”) and `C` (low=0, high=1000). We only focus on f1
score in this comparasion since it is more relavant to the issue we care
about. We ranked the f1 score from high to low. As indicated in the
table, our best f1 score is 0.51 with hyperparameter *C=382* and
*class\_weight=‘balanced’*. The results also show that the top 3 f1
scores are all come from `LogisricRegression`. This finding further
confirmed our results from previous table that `LogisticRegression` is a
better model to use than `RandomForest`.

| mean f1 score | params                                     | model              |
| ------------: | :----------------------------------------- | :----------------- |
|     0.5104704 | {‘C’: 559, ‘class\_weight’: ‘balanced’}    | LogisticRegression |
|     0.5103458 | {‘C’: 382, ‘class\_weight’: ‘balanced’}    | LogisticRegression |
|     0.5102955 | {‘C’: 679, ‘class\_weight’: ‘balanced’}    | LogisticRegression |
|     0.4776511 | {‘max\_depth’: 1793, ‘n\_estimators’: 168} | RandomForest       |
|     0.4746316 | {‘max\_depth’: 946, ‘n\_estimators’: 161}  | RandomForest       |
|     0.4704937 | {‘max\_depth’: 1408, ‘n\_estimators’: 43}  | RandomForest       |
|     0.4666232 | {‘max\_depth’: 560, ‘n\_estimators’: 94}   | RandomForest       |
|     0.4494723 | {‘max\_depth’: 736, ‘n\_estimators’: 20}   | RandomForest       |
|     0.3958155 | {‘C’: 158, ‘class\_weight’: ‘none’}        | LogisticRegression |
|     0.3958155 | {‘C’: 596, ‘class\_weight’: ‘none’}        | LogisticRegression |

Table 2. F1 score with optimized hyperpamaters for each model

Based on the result above, we find that although `LogisticRegression` is
a better model to use, the f1 score is only around 0.5. It is not a very
good score, which means the prediction from this model is not as
reliable. To further improve this model in future, it is a good idea to
take consideration of other hyperparameters or apply feature engineering
to add more useful features to help with prediction. Furthermore, we may
also want to look at the confusion matrix of model performance and try
to minimize the false negative in the prediction by changing the
threshold of the model.

It is a fair score but there is for sure some room for improvement. One
possible way is to do feature enginnering. We only have 23 features for
the model to learn, and based on our results from feature selection,
whether or not we apply feature selection does not affect our score by a
lot. This may because we do not have lots of features and what our model
could learn is limited. Therefore, future reseach may consider to create
new features that would help the model to better learn the pattern, or
if possible, gather more data for better prediction score.

## References

<div id="refs" class="references hanging-indent">

<div id="ref-docopt">

de Jonge, Edwin. 2018. *Docopt: Command-Line Interface Specification
Language*. <https://CRAN.R-project.org/package=docopt>.

</div>

<div id="ref-R">

R Core Team. 2020. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-reback2020pandas">

team, The pandas development. 2020. *Pandas-Dev/Pandas: Pandas* (version
1.1.1). Zenodo. <https://doi.org/10.5281/zenodo.3993412>.

</div>

<div id="ref-Python">

Van Rossum, Guido, and Fred L. Drake. 2009. *Python 3 Reference Manual*.
Scotts Valley, CA: CreateSpace.

</div>

<div id="ref-tidyverse">

Wickham, Hadley. 2017. *Tidyverse: Easily Install and Load the
’Tidyverse’*. <https://CRAN.R-project.org/package=tidyverse>.

</div>

<div id="ref-featherr">

———. 2019. *Feather: R Bindings to the Feather ’Api’*.
<https://CRAN.R-project.org/package=feather>.

</div>

<div id="ref-knitr">

Xie, Yihui. 2020. *Knitr: A General-Purpose Package for Dynamic Report
Generation in R*. <https://yihui.org/knitr/>.

</div>

<div id="ref-yeh2009comparisons">

Yeh, I-Cheng, and Che-hui Lien. 2009. “The Comparisons of Data Mining
Techniques for the Predictive Accuracy of Probability of Default of
Credit Card Clients.” *Expert Systems with Applications* 36 (2):
2473–80.

</div>

</div>
