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
  
  # density plot
  density_plot <- training_scaled %>%
    ggplot(aes(x = limit_bal,
               fill = default)) +
    geom_density(alpha = 0.6) +
    xlab("Credit Limit") +
    ylab("Density") +
    ggtitle("Density of Credit Limit")
  
  density_plot <- density_plot + guides(fill=guide_legend(title="Default Flag")) 
  density_plot <- density_plot + scale_shape_discrete(labels = c("Non-Defaults", "Defaults")) + scale_fill_discrete(labels = c("Non-Defaults", "Defaults"))
  
  ggsave(paste0(out_dir, "/density_plot.png"), 
         density_plot,
         width = 8, 
         height = 10)
  
  # education count colort by default
  education_histogram <- training_data %>% 
    ggplot(aes(x=factor(education), fill=default)) +
    geom_bar(position="dodge") + 
    ggtitle("Education levels of Defaulting Clients") +
    xlab("Education") +
    ylab("Count")  
  
  education_histogram <- education_histogram + guides(fill=guide_legend(title="Default Flag")) 
  education_histogram <- education_histogram + scale_shape_discrete(labels = c("Non-Defaults", "Defaults")) + scale_fill_discrete(labels = c("Non-Defaults", "Defaults"))
  education_histogram <-  education_histogram + scale_x_discrete(labels=c("0" = "Undefined", "1" = "masters",
                                                                          "2" = "bachelors", "3" = "highschool",
                                                                          "4" = "school", "5" = "other",
                                                                          "6" = "other"))
  
  ggsave(paste0(out_dir, "/education_histogram.png"), 
         education_histogram,
         width = 8, 
         height = 10)
  
  # proportions plot
  prop_plot <- training_data %>% 
    ggplot(aes(x=as.numeric(default),  y = ..prop.., fill = factor(..x..), group = 1)) +
    geom_bar(stat='count') +
    geom_text(stat='count', aes(label=..prop..), vjust=3, hjust=0.5, color = 'black') +
    scale_y_continuous(labels = scales::percent_format()) + 
    ggtitle("Proportions of Defaulting Clients") +
    xlab("Defaults") +
    ylab("Proportion") 
  
  prop_plot <- prop_plot + guides(fill=guide_legend(title="Default Flag")) 
  prop_plot <- prop_plot + scale_shape_discrete(labels = c("Non-Defaults", "Defaults")) + scale_fill_discrete(labels = c("Non-Defaults", "Defaults"))
  
  ggsave(paste0(out_dir, "/proportions_plot.png"), 
         prop_plot,
         width = 8, 
         height = 10)
  
  numeric_df <- training_data %>%
    select(-c(sex, education, marriage))
  numeric_df$default <- as.numeric(numeric_df$default)
  numeric_df$age <- as.numeric(numeric_df$age)
  
  # target counts bar plot 
  count_plot <- training_data %>% 
    ggplot(aes(x=as.numeric(default), fill=default)) +
    geom_bar() +
    geom_text(stat='count', aes(label=..count..), vjust=3, hjust=0.9, color = 'black') + 
    ggtitle("Count of Defaulting Clients") +
    xlab("Defaults") +
    ylab("Count") 
  
  count_plot <- prop_plot + guides(fill=guide_legend(title="Default Flag")) 
  count_plot <- prop_plot + scale_shape_discrete(labels = c("Non-Defaults", "Defaults")) + scale_fill_discrete(labels = c("Non-Defaults", "Defaults"))
  
  ggsave(paste0(out_dir, "/counts_plot.png"), 
         count_plot,
         width = 8, 
         height = 10)
  

  
  # correlation plot
  corr <- round(cor(numeric_df %>% select_if(is.numeric)), 1)
  correlation_plot <- ggcorrplot(corr, hc.order = TRUE, outline.col = "white")
  
  ggsave(paste0(out_dir, "/correlation_plot.png"), 
         correlation_plot,
         width = 8, 
         height = 10)
}

main(opt[["--train"]], opt[["--train_scaled"]], opt[["--out_dir"]])
