# author: Hazel Jiang in Group 12
# date: 2020-11-20

'''This script downloads data from a given URL and save it as a local file

Usage: src/downloadData.py --url=<url>  --saving_path=<saving_path> 

Options:
--url=<url>   URL from where you download the data (must be in standard excel format)
--saving_path=<saving_path> Path to save the downloaded file to csv file
'''

import os
import pandas as pd
from docopt import docopt

opt = docopt(__doc__)

def main(url, saving_path):
  # read in data
  df = pd.read_excel(url)
  # save data to csv
  try:
    df.to_csv(saving_path, index=False)
  except:
    os.makedirs(os.path.dirname(saving_path))
    df.to_csv(saving_path, index=False)

if __name__ == "__main__":
    main(opt["--url"],opt["--saving_path"])
