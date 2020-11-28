# author: Lara Habashy
# date: 2020-11-26

"Creates eda plots for the pre-processed training data from the Wisconsin breast cancer data (from http://mlr.cs.umass.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data).
Saves the plots as a pdf and png file.
Usage: src/eda_cred.r --train=<train> --out_dir=<out_dir>
  
Options:
--train=<train>     Path (including filename) to training data (which needs to be saved as a feather file)
--out_dir=<out_dir> Path to directory where the plots should be saved
" -> doc

library(feather)
library(tidyverse)
library(caret)
library(docopt)
library(ggthemes)
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
}

main(opt[["--train"]], opt[["--out_dir"]])