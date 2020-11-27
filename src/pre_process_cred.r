# author: Lara Habashy
# date: 2020-11-26

"Cleans, splits and pre-processes the default of credit card clients data (from http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients).
Writes the training and test data to separate feather files.
Usage: src/pre_process_cred.r --input=<input> --out_dir=<out_dir>
  
Options:
--input=<input>       Path (including filename) to raw data (feather file)
--out_dir=<out_dir>   Path to directory where the processed data should be written
" -> doc

library(feather)
library(tidyverse)
library(caret)
library(docopt)
set.seed(2020)

opt <- docopt(doc)
main <- function(input, out_dir){
  # read data and convert default to factor
  raw_data <- read_feather(input) 
  dat <- janitor::row_to_names(raw_data, 1)
  
  df <- dat %>% janitor::clean_names()
  
  #convert factor features
  factor_features <- c('default_payment_next_month')
  df[factor_features] <- lapply(df[factor_features], function(x) as.factor(x))
  
  numeric_features <- c("limit_bal", "age", 
                        "pay_0", "pay_2", "pay_3", "pay_4", "pay_5", "pay_6", 
                        "bill_amt1","bill_amt2", "bill_amt3", "bill_amt4", "bill_amt5", "bill_amt6",
                        "pay_amt1", "pay_amt2" , "pay_amt3" , "pay_amt4","pay_amt5", "pay_amt6")
  
  df[numeric_features] <- lapply(df[numeric_features], function(x) as.numeric(x))
  
  categorical_features <- c("id", "sex", "education", "marriage")
  df[categorical_features] <- lapply(df[categorical_features], function(x) as.factor(x))
  
  dmy <- dummyVars( ~ sex + education + marriage, data = df)
  one_hot <- data.frame(predict(dmy, newdata = df))
  one_hot <- lapply(one_hot, function(x) as.factor(x))
    
  new_df <- cbind(df, one_hot)
  new_df <- new_df %>% 
    janitor::clean_names()  %>% 
    select(-c(sex, education, marriage))
  
  #rename column and drop id feature
  cred_data <- new_df %>% 
    rename(pay_1 = pay_0) %>%
    relocate(pay_1, .before=pay_2) %>%
    select(-id) 
  
  #rename target column
  cred_data <- cred_data %>%
    rename(default = default_payment_next_month)
  
  #encode unknown value as 0
  encode_function <- function(x){
    replace(x, x < -1, 0)
  }
  cred_data <- cred_data %>%
    mutate_at(c("pay_1", "pay_2", "pay_3", "pay_4", "pay_5", "pay_6"), encode_function)
  
  # split into training and test data sets
  training_rows <- cred_data %>% 
    select(default) %>% 
    pull() %>%
    createDataPartition(p = 0.75, list = FALSE)
  
  training_data <- cred_data %>% 
    slice(training_rows)
  test_data <- cred_data %>% 
    slice(-training_rows)
  
  # scale test data using scale factor
  X_train <- training_data %>% 
    select(-default) 
  X_test <- test_data %>% 
    select(-default)
  y_train <- training_data %>% 
    select(default) 
  y_test <- test_data %>% 
    select(default)
  
  pre_process_scaler <- preProcess(X_train, method = c("center", "scale"))
  X_train_scaled <- predict(pre_process_scaler, X_train)
  X_test_scaled <- predict(pre_process_scaler, X_test)
  
  training_scaled <- X_train_scaled %>% 
    mutate(default = training_data %>% select(default) %>% pull())
  test_scaled <- X_test_scaled %>% 
    mutate(default = test_data %>% select(default) %>% pull())
  
  try({
    dir.create(out_dir)
  })
  saveRDS(pre_process_scaler, file = paste0(out_dir, "/scale_factor.rds"))
  
  # write training and test data to feather files
  write_feather(training_scaled, paste0(out_dir, "/training.feather"))
  write_feather(test_scaled, paste0(out_dir, "/test.feather"))
}

main(opt[["--input"]], opt[["--out_dir"]])