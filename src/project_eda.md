Load the data & Preliminary Analysis
====================================

The data set consists of 25 features and 1 discrete response variable
called default\_payment\_next\_month.

    ## # A tibble: 6 x 25
    ##   ID    LIMIT_BAL SEX   EDUCATION MARRIAGE AGE   PAY_0 PAY_2 PAY_3 PAY_4 PAY_5
    ##   <chr> <chr>     <chr> <chr>     <chr>    <chr> <chr> <chr> <chr> <chr> <chr>
    ## 1 1     20000     2     2         1        24    2     2     -1    -1    -2   
    ## 2 2     120000    2     2         2        26    -1    2     0     0     0    
    ## 3 3     90000     2     2         2        34    0     0     0     0     0    
    ## 4 4     50000     2     2         1        37    0     0     0     0     0    
    ## 5 5     50000     1     2         1        57    -1    0     -1    0     0    
    ## 6 6     50000     1     1         2        37    0     0     0     0     0    
    ## # … with 14 more variables: PAY_6 <chr>, BILL_AMT1 <chr>, BILL_AMT2 <chr>,
    ## #   BILL_AMT3 <chr>, BILL_AMT4 <chr>, BILL_AMT5 <chr>, BILL_AMT6 <chr>,
    ## #   PAY_AMT1 <chr>, PAY_AMT2 <chr>, PAY_AMT3 <chr>, PAY_AMT4 <chr>,
    ## #   PAY_AMT5 <chr>, PAY_AMT6 <chr>, `default payment next month` <chr>

    ## tibble [30,000 × 25] (S3: tbl_df/tbl/data.frame)
    ##  $ ID                        : chr [1:30000] "1" "2" "3" "4" ...
    ##  $ LIMIT_BAL                 : chr [1:30000] "20000" "120000" "90000" "50000" ...
    ##  $ SEX                       : chr [1:30000] "2" "2" "2" "2" ...
    ##  $ EDUCATION                 : chr [1:30000] "2" "2" "2" "2" ...
    ##  $ MARRIAGE                  : chr [1:30000] "1" "2" "2" "1" ...
    ##  $ AGE                       : chr [1:30000] "24" "26" "34" "37" ...
    ##  $ PAY_0                     : chr [1:30000] "2" "-1" "0" "0" ...
    ##  $ PAY_2                     : chr [1:30000] "2" "2" "0" "0" ...
    ##  $ PAY_3                     : chr [1:30000] "-1" "0" "0" "0" ...
    ##  $ PAY_4                     : chr [1:30000] "-1" "0" "0" "0" ...
    ##  $ PAY_5                     : chr [1:30000] "-2" "0" "0" "0" ...
    ##  $ PAY_6                     : chr [1:30000] "-2" "2" "0" "0" ...
    ##  $ BILL_AMT1                 : chr [1:30000] "3913" "2682" "29239" "46990" ...
    ##  $ BILL_AMT2                 : chr [1:30000] "3102" "1725" "14027" "48233" ...
    ##  $ BILL_AMT3                 : chr [1:30000] "689" "2682" "13559" "49291" ...
    ##  $ BILL_AMT4                 : chr [1:30000] "0" "3272" "14331" "28314" ...
    ##  $ BILL_AMT5                 : chr [1:30000] "0" "3455" "14948" "28959" ...
    ##  $ BILL_AMT6                 : chr [1:30000] "0" "3261" "15549" "29547" ...
    ##  $ PAY_AMT1                  : chr [1:30000] "0" "0" "1518" "2000" ...
    ##  $ PAY_AMT2                  : chr [1:30000] "689" "1000" "1500" "2019" ...
    ##  $ PAY_AMT3                  : chr [1:30000] "0" "1000" "1000" "1200" ...
    ##  $ PAY_AMT4                  : chr [1:30000] "0" "1000" "1000" "1100" ...
    ##  $ PAY_AMT5                  : chr [1:30000] "0" "0" "1000" "1069" ...
    ##  $ PAY_AMT6                  : chr [1:30000] "0" "2000" "5000" "1000" ...
    ##  $ default payment next month: chr [1:30000] "1" "1" "0" "0" ...

    ##       ID             LIMIT_BAL             SEX             EDUCATION        
    ##  Length:30000       Length:30000       Length:30000       Length:30000      
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##    MARRIAGE             AGE               PAY_0              PAY_2          
    ##  Length:30000       Length:30000       Length:30000       Length:30000      
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##     PAY_3              PAY_4              PAY_5              PAY_6          
    ##  Length:30000       Length:30000       Length:30000       Length:30000      
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##   BILL_AMT1          BILL_AMT2          BILL_AMT3          BILL_AMT4        
    ##  Length:30000       Length:30000       Length:30000       Length:30000      
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##   BILL_AMT5          BILL_AMT6           PAY_AMT1           PAY_AMT2        
    ##  Length:30000       Length:30000       Length:30000       Length:30000      
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##    PAY_AMT3           PAY_AMT4           PAY_AMT5           PAY_AMT6        
    ##  Length:30000       Length:30000       Length:30000       Length:30000      
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##  default payment next month
    ##  Length:30000              
    ##  Class :character          
    ##  Mode  :character

In our data set, there are 30,000 observations of distinct credit card
clients. The mean value for the amount of a given credit card limit is
$167,484. There is some imbalance in the target class, as well as
education level and marital status. Furthermore, the average age of
clients is around 36.The target variable, default\_payment\_next\_month
has a value of 1 for default and 0 for non default.

Data Cleaning
=============

Before diving into EDA, we convert features into the best format for our
application. We also explore any missing values and find none.
Therefore, no imputation is required. However, we can consider applying
a scaling transformation to the numeric features in the data set.

    ##  [1] "id"                         "limit_bal"                 
    ##  [3] "sex"                        "education"                 
    ##  [5] "marriage"                   "age"                       
    ##  [7] "pay_0"                      "pay_2"                     
    ##  [9] "pay_3"                      "pay_4"                     
    ## [11] "pay_5"                      "pay_6"                     
    ## [13] "bill_amt1"                  "bill_amt2"                 
    ## [15] "bill_amt3"                  "bill_amt4"                 
    ## [17] "bill_amt5"                  "bill_amt6"                 
    ## [19] "pay_amt1"                   "pay_amt2"                  
    ## [21] "pay_amt3"                   "pay_amt4"                  
    ## [23] "pay_amt5"                   "pay_amt6"                  
    ## [25] "default_payment_next_month"

    ## target
    ##      0      1 
    ## 0.7788 0.2212

Partition the data set into training and test sets
==================================================

Before splitting the data set into training (75%) and testing (25%)
sets, we inspect class balance to detect any imbalance in the target
class which we attempt to correct. We also drop the `ID` features as
it’s irrelavant.

    ## train_counts
    ##      0      1 
    ## 0.7788 0.2212

    ## test_counts
    ##      0      1 
    ## 0.7788 0.2212

Exploratory analysis on the training data set
=============================================

Correlation Analysis
--------------------

![](project_eda_files/figure-markdown_github/corr-1.png)

Looking at the correlation plot, we see that the features pay\_1, …,
pay\_6 are the most correlated with the target variable
default\_payment\_next\_month. Demographic features in general seem to
be not highly correlated to our response but rather the features
tracking the monthly bill amounts. The lowest correlated features is
limit\_balance, which we consider applying a standardization
transformation to.

Feature Analysis
----------------

Next, we consider a feature selection method that allows for individual
evaluation of each feature. We apply the function selectKBest on the
full dataset to select a subset for modelling that utilizes the most
significant features. To determine an optimal number of features, or the
best k, that will yield that strongest predictive powers, we first look
at the value per features attribute of all the features in the model.
The top feature’s value, bill\_amt1 is seen to be 82.1% and the least
valuable feature. We consider selecting features with a value of
approximately at least 70%.

    ##  [1] "bill_amt1" "bill_amt2" "bill_amt3" "bill_amt4" "bill_amt5" "bill_amt6"
    ##  [7] "pay_amt1"  "pay_amt2"  "pay_amt3"  "pay_amt4"

    ##  [1] 0.8197778 0.8044000 0.7942667 0.7828889 0.7653333 0.7480000 0.3512444
    ##  [8] 0.3352889 0.3289778 0.3051556

### Variable Importance

The first approach we take to evaluate variable importance uses accuracy
and gini importance.

    ## 
    ## Call:
    ##  randomForest(formula = default_payment_next_month ~ ., data = training_data,      ntree = 50, mtry = 2, importance = TRUE) 
    ##                Type of random forest: classification
    ##                      Number of trees: 50
    ## No. of variables tried at each split: 2
    ## 
    ##         OOB estimate of  error rate: 18.79%
    ## Confusion matrix:
    ##       0    1 class.error
    ## 0 16579  944  0.05387205
    ## 1  3283 1694  0.65963432

![](project_eda_files/figure-markdown_github/var%20imp-1.png)

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    0    1
    ##          0 5561 1086
    ##          1  280  573
    ##                                           
    ##                Accuracy : 0.8179          
    ##                  95% CI : (0.8089, 0.8265)
    ##     No Information Rate : 0.7788          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.3601          
    ##                                           
    ##  Mcnemar's Test P-Value : < 2.2e-16       
    ##                                           
    ##             Sensitivity : 0.9521          
    ##             Specificity : 0.3454          
    ##          Pos Pred Value : 0.8366          
    ##          Neg Pred Value : 0.6717          
    ##              Prevalence : 0.7788          
    ##          Detection Rate : 0.7415          
    ##    Detection Prevalence : 0.8863          
    ##       Balanced Accuracy : 0.6487          
    ##                                           
    ##        'Positive' Class : 0               
    ## 

The importance of each variable in the random forest model is displayed
in the figure above. The importance function outputs a list of features,
along with their corresponding Mean Decrease Gini and Mean Decrease
Accuracy values. Mean Decrease Accuracy suggests that if the variable is
not important, then rearranging its values should not degrade the
model’s prediction accuracy. The features at the top of the figure have
the most predictive power in the model. Eliminating these features would
significantly decrease the predictive power of the model. Once again
here, we observe that demographic features has very little significance
in the data set.

The second approach we take to evaluate variable importance uses the R
package VSURF. The recently publish library (2019) implements a 3-step
feature selection process using random forests. For the sake of time,
the team has decided to omit the work on VSURF variable importance until
time permits.

Next we examine the distribution of the most and least important
features. The plot suggests education is an interesting feature that is
highly imbalanced.

![](project_eda_files/figure-markdown_github/plots-1.png)![](project_eda_files/figure-markdown_github/plots-2.png)

### Modeling Logistic Regression

    ## 
    ## Call:
    ## glm(formula = default_payment_next_month ~ ., family = binomial, 
    ##     data = training_data)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -3.2772  -0.7002  -0.5381  -0.2756   3.8453  
    ## 
    ## Coefficients:
    ##               Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept) -1.462e+01  9.350e+01  -0.156  0.87570    
    ## limit_bal   -8.413e-07  1.874e-07  -4.489 7.17e-06 ***
    ## sex2        -1.092e-01  3.574e-02  -3.057  0.00224 ** 
    ## education1   1.104e+01  9.349e+01   0.118  0.90599    
    ## education2   1.091e+01  9.349e+01   0.117  0.90713    
    ## education3   1.087e+01  9.349e+01   0.116  0.90747    
    ## education4   1.025e+01  9.349e+01   0.110  0.91268    
    ## education5   9.841e+00  9.349e+01   0.105  0.91617    
    ## education6   1.062e+01  9.350e+01   0.114  0.90954    
    ## marriage1    2.219e+00  8.086e-01   2.744  0.00606 ** 
    ## marriage2    2.047e+00  8.088e-01   2.531  0.01136 *  
    ## marriage3    2.059e+00  8.235e-01   2.500  0.01241 *  
    ## age22        6.544e-01  4.450e-01   1.471  0.14141    
    ## age23        5.574e-01  4.409e-01   1.264  0.20622    
    ## age24        5.277e-01  4.393e-01   1.201  0.22966    
    ## age25        7.135e-01  4.387e-01   1.626  0.10385    
    ## age26        3.282e-01  4.399e-01   0.746  0.45553    
    ## age27        5.538e-01  4.383e-01   1.263  0.20643    
    ## age28        5.466e-01  4.392e-01   1.245  0.21329    
    ## age29        5.300e-01  4.385e-01   1.209  0.22681    
    ## age30        5.644e-01  4.397e-01   1.284  0.19927    
    ## age31        5.194e-01  4.410e-01   1.178  0.23883    
    ## age32        5.546e-01  4.415e-01   1.256  0.20900    
    ## age33        5.697e-01  4.412e-01   1.291  0.19664    
    ## age34        5.603e-01  4.409e-01   1.271  0.20383    
    ## age35        5.128e-01  4.416e-01   1.161  0.24557    
    ## age36        7.177e-01  4.410e-01   1.627  0.10366    
    ## age37        7.115e-01  4.423e-01   1.609  0.10770    
    ## age38        6.287e-01  4.429e-01   1.419  0.15582    
    ## age39        5.741e-01  4.438e-01   1.294  0.19578    
    ## age40        7.756e-01  4.432e-01   1.750  0.08016 .  
    ## age41        6.572e-01  4.451e-01   1.477  0.13976    
    ## age42        5.914e-01  4.454e-01   1.328  0.18422    
    ## age43        6.171e-01  4.477e-01   1.378  0.16813    
    ## age44        6.397e-01  4.464e-01   1.433  0.15182    
    ## age45        4.466e-01  4.500e-01   0.993  0.32092    
    ## age46        9.277e-01  4.480e-01   2.071  0.03838 *  
    ## age47        7.386e-01  4.514e-01   1.636  0.10182    
    ## age48        7.354e-01  4.522e-01   1.626  0.10392    
    ## age49        9.342e-01  4.517e-01   2.068  0.03864 *  
    ## age50        8.188e-01  4.548e-01   1.800  0.07180 .  
    ## age51        8.208e-01  4.596e-01   1.786  0.07409 .  
    ## age52        5.220e-01  4.628e-01   1.128  0.25934    
    ## age53        5.797e-01  4.648e-01   1.247  0.21231    
    ## age54        5.597e-01  4.723e-01   1.185  0.23598    
    ## age55        7.620e-01  4.732e-01   1.610  0.10733    
    ## age56        6.335e-01  4.836e-01   1.310  0.19021    
    ## age57        5.768e-01  5.056e-01   1.141  0.25399    
    ## age58        7.334e-01  5.000e-01   1.467  0.14243    
    ## age59        5.761e-01  5.270e-01   1.093  0.27435    
    ## age60        1.143e+00  5.268e-01   2.170  0.02999 *  
    ## age61        1.089e+00  5.434e-01   2.004  0.04512 *  
    ## age62       -6.579e-01  8.261e-01  -0.796  0.42581    
    ## age63        1.263e-01  7.337e-01   0.172  0.86328    
    ## age64        1.040e+00  6.496e-01   1.601  0.10934    
    ## age65        6.012e-01  8.047e-01   0.747  0.45498    
    ## age66        5.080e-01  8.091e-01   0.628  0.53009    
    ## age67        2.004e-01  8.403e-01   0.238  0.81151    
    ## age68        1.329e+00  1.464e+00   0.907  0.36416    
    ## age69        6.765e-01  8.256e-01   0.819  0.41256    
    ## age70        4.650e-01  9.784e-01   0.475  0.63460    
    ## age71       -1.059e+01  3.247e+02  -0.033  0.97398    
    ## age72        1.238e+00  1.546e+00   0.801  0.42326    
    ## age73        3.420e+00  1.393e+00   2.455  0.01409 *  
    ## age74       -1.027e+01  3.247e+02  -0.032  0.97476    
    ## age75       -1.039e+01  3.247e+02  -0.032  0.97447    
    ## age79       -9.940e+00  3.247e+02  -0.031  0.97558    
    ## pay_0        5.900e-01  2.056e-02  28.701  < 2e-16 ***
    ## pay_2        7.242e-02  2.337e-02   3.098  0.00195 ** 
    ## pay_3        8.295e-02  2.608e-02   3.180  0.00147 ** 
    ## pay_4        2.741e-03  2.905e-02   0.094  0.92484    
    ## pay_5        3.335e-02  3.119e-02   1.069  0.28496    
    ## pay_6        2.632e-02  2.567e-02   1.025  0.30523    
    ## bill_amt1   -6.088e-06  1.330e-06  -4.579 4.68e-06 ***
    ## bill_amt2    3.596e-06  1.702e-06   2.113  0.03459 *  
    ## bill_amt3    5.948e-07  1.506e-06   0.395  0.69292    
    ## bill_amt4    1.112e-07  1.609e-06   0.069  0.94486    
    ## bill_amt5    4.574e-07  1.788e-06   0.256  0.79807    
    ## bill_amt6    4.684e-07  1.397e-06   0.335  0.73730    
    ## pay_amt1    -1.327e-05  2.606e-06  -5.092 3.55e-07 ***
    ## pay_amt2    -7.356e-06  2.251e-06  -3.269  0.00108 ** 
    ## pay_amt3    -4.587e-06  2.130e-06  -2.153  0.03130 *  
    ## pay_amt4    -5.000e-06  2.247e-06  -2.225  0.02611 *  
    ## pay_amt5    -4.488e-06  2.149e-06  -2.088  0.03681 *  
    ## pay_amt6    -1.193e-06  1.463e-06  -0.816  0.41462    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 23779  on 22499  degrees of freedom
    ## Residual deviance: 20750  on 22415  degrees of freedom
    ## AIC: 20920
    ## 
    ## Number of Fisher Scoring iterations: 11

![](project_eda_files/figure-markdown_github/glm-1.png)![](project_eda_files/figure-markdown_github/glm-2.png)

The logistic regression classifier performed faily well on the test data
with accuracy of 0.82 and AUC score of 0.724. However, many default
payments were not detected. As such, we continue to investigate way to
improve the models accuracy.
