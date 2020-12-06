# author: Lara Habashy
# date: 2020-11-26

"Creates eda plots for the pre-processed training data from the default of credit card clients data (from http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients).
Saves the plots as a png file.

Usage:  src/eda_cred.r --train=<train> --train_scaled=<train_scaled>  --out_dir=<out_dir>
  
Options:
--train=<train>     Path (including filename) to training data (which needs to be saved as a feather file)
--train_scaled=<train_scaled> 
--out_dir=<out_dir> Path to directory where the plots should be saved
" -> doc

library(feather)
library(tidyverse)
#library(caret)
library(docopt)
library(ggthemes)
#library(graphics)
library(ggcorrplot)
library(arrow)

theme_set(theme_minimal())

opt <- docopt(doc)

main <- function(train, train_scaled, out_dir) {
  
  # make directory for results
  if (!dir.exists("results")){
    dir.create(file.path(getwd(), "results"))
  }
  if (!dir.exists("results/figures")){
    dir.create(file.path(getwd(), "results/figures"))
  }
  
  # read data 
  training_data <- arrow::read_feather(train)
  training_scaled <- arrow::read_feather(train_scaled)
  
  #density plot
  density_plot <- ggplot(training_scaled) +
    aes(x = limit_bal,
        fill = default,
        color = default) +
    geom_density(alpha = 0.6) +
    xlab("Credit Limit") +
    ylab("Density") +
    ggtitle("Density of Credit Limit")
  
  ggsave(paste0(out_dir, "/density_plot.png"), 
         density_plot,
         width = 8, 
         height = 10)
  
  training_scaled$education <- as.factor(toupper(names(training_scaled[,25:31])[max.col(training_scaled[,25:31])]))
  
  #histogram
  education_histogram <- ggplot(training_scaled, aes(pay_1, fill = default)) + 
    geom_histogram(binwidth = 1) + 
    ggtitle("Histogram of Education Levels") +
    facet_grid(.~education) + 
    theme_fivethirtyeight() 
  
  ggsave(paste0(out_dir, "/education_histogram.png"), 
         education_histogram,
         width = 8, 
         height = 10)
  
  numeric_df <- training_data %>%
    select(-c(sex, education, marriage))
  numeric_df$default <- as.numeric(numeric_df$default)
  numeric_df$age <- as.numeric(numeric_df$age)
  
  #correlation plot
  corr <- round(cor(numeric_df %>% select_if(is.numeric)), 1)
  correlation_plot <- ggcorrplot(corr, hc.order = TRUE, outline.col = "white")
  
  ggsave(paste0(out_dir, "/correlation_plot.png"), 
         correlation_plot,
         width = 8, 
         height = 10)
}

main(opt[["--train"]], opt[["--train_scaled"]], opt[["--out_dir"]])
