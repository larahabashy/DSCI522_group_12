# author: Lara Habashy
# date: 2020-11-26

"Creates eda plots for the pre-processed training data from the default of credit card clients data (from http://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients).
Saves the plots as a png file.
Usage: Rscript src/eda_cred.r --train=<train> --out_dir=<out_dir>
  
Options:
--train=<train>     Path (including filename) to training data (which needs to be saved as a feather file)
--out_dir=<out_dir> Path to directory where the plots should be saved
" -> doc

library(feather)
library(tidyverse)
#library(caret)
library(docopt)
library(ggthemes)
#library (PerformanceAnalytics)
#library(graphics)

theme_set(theme_minimal())

opt <- docopt(doc)

main <- function(train, out_dir) {
  # read data 
  training_scaled <- read_feather(train) 

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
  
  training_scaled$education <- as.factor(toupper(names(training_scaled[,23:29])[max.col(training_scaled[,23:29])]))
  
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
  
  numeric_df <- training_scaled
  numeric_df$default <- as.numeric(numeric_df$default)
  numeric_df$age <- as.numeric(numeric_df$age)
  numeric_df$sex <- NULL
  numeric_df$education <- NULL
  numeric_df$marriage <- NULL
  ggsave(corr_plot, "correlation_plot.png")
  #correlation plot
  corr_plot <- PerformanceAnalytics::chart.Correlation(numeric_df %>% select_if(is.numeric), histogram=TRUE, method = "pearson", col="blue", pch=1, main="all")
  
  ggsave(paste0(out_dir, "/correlation_plot.png"), 
         corr_plot,
         width = 8, 
         height = 10)
  
}

main(opt[["--train"]], opt[["--out_dir"]])