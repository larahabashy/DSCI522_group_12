# author: Lara Habashy
# date: 2020-11-26

"Pre-processes the default of credit card clients data (from http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients).
Writes the training and test data to separate feather files.

Usage: src/pre_process.r --train=<train> --test=<test> --out_dir=<out_dir>
  
Options:
--train=<train>       Path (including filename) to training data (feather file)
--test=<test>         Path (including filename) to test data (feather file)
--out_dir=<out_dir>   Path to directory where the processed data should be written
" -> doc

library(feather)
library(tidyverse)
library(caret)
library(docopt)
set.seed(2020)

opt <- docopt(doc)
main <- function(train, test, out_dir){
  
  # read data and convert default to factor
  training_data <- read_feather(train) 
  test_data <- read_feather(test) 
  
  dmy_train <- dummyVars( ~ sex + education + marriage, data = training_data)
  dmy_test <- dummyVars( ~ sex + education + marriage, data = test_data)
  
  one_hot_train <- data.frame(predict(dmy_train, newdata = training_data))
  one_hot_test <- data.frame(predict(dmy_test, newdata = test_data))
  
  one_hot_train <- lapply(one_hot_train, function(x) as.factor(x))
  one_hot_test <- lapply(one_hot_test, function(x) as.factor(x))
  
  training_ohe <- cbind(training_data, one_hot_train)
  test_ohe <- cbind(test_data, one_hot_test)
  
  # scale test data using scale factor
  X_train <- training_ohe %>% 
    select(-default) 
  X_test <- test_ohe %>% 
    select(-default)
  y_train <- training_ohe %>% 
    select(default) 
  y_test <- test_ohe %>% 
    select(default)
  
  pre_process_scaler <- preProcess(X_train, method = c("center", "scale"))
  X_train_scaled <- predict(pre_process_scaler, X_train)
  X_test_scaled <- predict(pre_process_scaler, X_test)
  
  training_scaled <- X_train_scaled %>% 
    mutate(default = training_data %>% select(default) %>% pull()) %>%
    janitor::clean_names()
  test_scaled <- X_test_scaled %>% 
    mutate(default = test_data %>% select(default) %>% pull()) %>%
    janitor::clean_names()
  
  try({
    dir.create(out_dir)
  })
  saveRDS(pre_process_scaler, file = paste0(out_dir, "/scale_factor.rds"))
  
  # write training and test data to feather files
  write_feather(training_scaled, paste0(out_dir, "/training.feather"))
  write_feather(test_scaled, paste0(out_dir, "/test.feather"))
}

main(opt[["--train"]], opt[["--test"]], opt[["--out_dir"]])