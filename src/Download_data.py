# author: Hazel Jiang in Group 12
# date: 2020-11-20

'''This script downloads data from a given URL and save it as a local feather file

Usage: src/downloadData.py --url=<url>  --saving_path=<saving_path> 

Options:
--url=<url>   URL from where you download the data (must be in standard excel format)
--saving_path=<saving_path> Path to save the downloaded file to feather file (specify '.feather')
'''

import os
import pandas as pd
from docopt import docopt

opt = docopt(__doc__)

def main(url, saving_path):
  # read in data
  df = pd.read_excel(url, index_col=0).reset_index()
  df = df.astype(str)
  # save data to feather
  try:
      df.to_feather(saving_path)
  except:
      os.makedirs(os.path.dirname(saving_path))
      df.to_feather(saving_path)

if __name__ == "__main__":
    main(opt["--url"],opt["--saving_path"])
