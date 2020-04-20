library(biggr)
library(redditor)

dumps <- s3_list_objects('reddit-dumps')
files <- dir_ls(path = 'data_files')

walk(
  dumps$key,
  function(x) {
    if (!any(str_detect(files, x))) {
      s3_download_file('reddit-dumps', from = x, to = glue('data_files/{x}'))
      message('Downloading data')
    } else {
      message('Passing data')
    }
  }
)

dir_delete('csv_files')
dir_create('csv_files')
walk(files, ~ unzip(zipfile = ., exdir = 'csv_files'))

csv_data <- map_df(dir_ls(path = 'csv_files'), read_csv)

csv_data %>%
  group_by(subreddit) %>%
  count %>%
  arrange(desc(n)) %>%
  head(100) %>%
  as.data.frame()

