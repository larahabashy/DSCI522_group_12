Credit Card Default Predicting
================
Selma Duric, Lara Habashy, Hazel Jiang
2020-11-28

  - [Summary](#summary)
  - [Introduction](#introduction)
  - [Methods](#methods)
      - [Data](#data)
      - [Analysis](#analysis)
  - [Results & Discussion](#results-discussion)
  - [References](#references)

## Summary

## Introduction

In recent years, credit card becomes more and more popular in Taiwan.
Because card-issuing banks are all trying to increase market share,
there exists more unqualified applicants who are not able to pay their
credit card on time. This behaviour is very harmful to both banks and
cardholders. (\#reference) It is always better to prevent than to solve
a problem. By detecting patterns of people who tend to default their
credit card payment, banks are able to minimize the risk of issuing
credict card to people who may not be able to pay on time.

Here we would like to use a machine learning algorithm to predict
whether a person is going to defualt on his/her credit card payment. We
are going to test on different model and hyperparameters to find the
best score on prediction. With the model, banks could predict if the
applicant has the ability to pay on time and make better decision on
whether to issue the person a credit card. Thus, if the machine learning
algorithm can make accurate prediction, banks are able to find reliable
applicants and minimize their loss on default payment.

## Methods

### Data

The dataset we are using in the project is originally from Department of
Information Management in Chun Hua University, Taiwan and Department of
Civil Engineering in Tamkang University, Taiwan. It was sourced from UCI
Machine Learning Repository (\#references) and can be found
[here](http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients#).
[This
file](http://archive.ics.uci.edu/ml/machine-learning-databases/00350/default%20of%20credit%20card%20clients.xls)
is what we used to build the model. The data set contains 30,000
observations representing individual customers in Taiwan. Each row
contains relevant information about the distinct individual as well as
how timely they were with their bill payments and the corresponding bill
amounts for each time period. The bill payment information contains
records from April 2005 to September 2005 and each individual have the
same number of time periods. The data was collected from an important
cash and credit card issuing bank in Taiwan.We will make our prediction
based on the features given by the data.

### Analysis

There are 30,000 observations of distinct credit card clients in this
data set with each row represents a client. 25 different feature are
included with information of each given client, such as gender, age,
approved credit limit, education, marital status, their past payment
history, bill statements, and previous payments for 6 months (April-Sept
2005). Feature transformations are applied to the given features so each
observation has the same number of time periods.
[Here](https://github.com/UBC-MDS/DSCI522_group_12/blob/main/src/project_eda.md)
is a more detailed exploratory analysis that explained how we transform
and use each feature.There exists class imbalance in the data set, and
one pattern we found is that people with higher credit card limit are
more likely to default their payment.

<div class="figure">

<img src="../results/density_plot.png" alt="Figure 1. Density of Credit Limit Between Default Clients and On-time Clients" width="50%" />

<p class="caption">

Figure 1. Density of Credit Limit Between Default Clients and On-time
Clients

</p>

</div>

Both `LogisticRegression` and `RandomForest` model will be used to build
this classification model to predict whether a client will default on
the credit card payment. Because of the class imbalance we have, we will
look at test accuracy as well as f1 scores on both model. For each
model, the appropriate hyperparameters were chosen using 5-fold cross
validation. The R and Python programing languages and the following R
and Python packages were used to perform the analysis: …ADD packages and
ref.

The code used to perform the analysis and create this report can be
found [here](https://github.com/UBC-MDS/DSCI522_group_12/tree/main/src)

## Results & Discussion

| mean\_test\_score | params                                     | model              |
| ----------------: | :----------------------------------------- | :----------------- |
|         0.5105468 | {‘C’: 382, ‘class\_weight’: ‘balanced’}    | LogisticRegression |
|         0.5103729 | {‘C’: 679, ‘class\_weight’: ‘balanced’}    | LogisticRegression |
|         0.5102955 | {‘C’: 559, ‘class\_weight’: ‘balanced’}    | LogisticRegression |
|         0.4771019 | {‘max\_depth’: 946, ‘n\_estimators’: 161}  | RandomForest       |
|         0.4733326 | {‘max\_depth’: 1793, ‘n\_estimators’: 168} | RandomForest       |
|         0.4704956 | {‘max\_depth’: 560, ‘n\_estimators’: 94}   | RandomForest       |
|         0.4690769 | {‘max\_depth’: 1408, ‘n\_estimators’: 43}  | RandomForest       |
|         0.4432478 | {‘max\_depth’: 736, ‘n\_estimators’: 20}   | RandomForest       |
|         0.3958155 | {‘C’: 158, ‘class\_weight’: ‘none’}        | LogisticRegression |
|         0.3958155 | {‘C’: 596, ‘class\_weight’: ‘none’}        | LogisticRegression |

Table 1. This is a summary of the scores for LogisticRegression and
RandomForest

## References
