library(redditor)
library(glue)
library(dbplyr)
library(stringr)



con = postgres_connector()
dbListTables(con)

hot_scrapes <- tbl(con, in_schema('public', 'hot_scrapes'))


