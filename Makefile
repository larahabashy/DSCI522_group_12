# This driver script downloads the data from the source, pre-processes the data, 
# splitting it into a training and test set. It then generates plots and performs 
# a prediction on the test set. This scripts takes no inputs.

# Usage: type `make all` from command line to execute scripts in the src directory
#				 type `make clean` from command line to clean and remove the results directory

all :  doc/report.md src/project_eda.md 

# download data  
data/raw/default_of_credit_card_clients.feather : src/Download_data.py
		python src/Download_data.py --url=http://archive.ics.uci.edu/ml/machine-learning-databases/00350/default%20of%20credit%20card%20clients.xls --saving_path=data/raw/default_of_credit_card_clients.feather
		
# clean data 
data/clean/training.feather data/clean/test.feather : src/clean_split_cred.r data/raw/default_of_credit_card_clients.feather
		Rscript src/clean_split_cred.r --input=data/raw/default_of_credit_card_clients.feather --out_dir=data/clean

# process data
data/processed/training.feather data/processed/test.feather : src/pre_process_cred.r data/clean/training.feather data/clean/test.feather
		Rscript src/pre_process_cred.r --train=data/clean/training.feather --test=data/clean/test.feather --out_dir=data/processed

# generate EDA plots 
results/figures/correlation_plot.png results/figures/density_plot.png results/figures/education_histogram.png : src/eda_cred.R data/clean/training.feather data/processed/training.feather
		Rscript src/eda_cred.r --train=data/clean/training.feather --train_scaled=data/processed/training.feather --out_dir=results/figures

# train and make predictions
results/prediction/prediction_hp_results.csv results/prediction/prediction_prelim_results.csv : src/fit_predict_default_model.py data/processed/training.feather data/processed/test.feather
		python src/fit_predict_default_model.py --train_data="data/processed/training.feather" --test_data="data/processed/test.feather" --hp_out_dir="results/prediction/prediction_hp_results.csv" --prelim_results_dir="results/prediction/prediction_prelim_results.csv"

# generate reports
src/project_eda.md : data/raw/default_of_credit_card_clients.feather
		Rscript -e "rmarkdown::render('src/project_eda.Rmd', 'md_document')"

doc/report.md : results/figures/correlation_plot.png results/figures/density_plot.png results/figures/education_histogram.png results/prediction/prediction_hp_results.csv results/prediction/prediction_prelim_results.csv 
		echo "6"
		Rscript -e "rmarkdown::render('doc/report.Rmd', 'md_document')"
    
# remove all targets and newly created directories
clean : 
		rm -rf data/raw/default_of_credit_card_clients.feather
		rm -rf data/clean/training.feather 
		rm -rf data/clean/test.feather
		rm -rf data/processed/training.feather 
		rm -rf data/processed/test.feather
		rm -rf results/figures/correlation_plot.png 
		rm -rf results/figures/density_plot.png 
		rm -rf results/figures/education_histogram.png 
		rm -rf results/prediction/prediction_hp_results.csv
		rm -rf results/prediction/prediction_prelim_results.csv
		rm -rf src/project_eda.md
		rm -rf doc/report.md
		-rmdir data/processed
		-rmdir data/clean
		-rmdir results/figures
		-rmdir results/prediction
		-rmdir results

	