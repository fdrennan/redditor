library(redditor)
library(biggr)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))

# Do something with comments
parse_comments_wrapper <- function(x) {
  submission_value <- parse_comments(x)
  if(!file_exists('stream.csv')) {
    write_csv(x = submission_value, path = 'stream.csv', append = FALSE)
  } else {
    write_csv(x = submission_value, path = 'stream.csv', append = TRUE)
  }
  print(now(tzone = 'UTC') - submission_value$created_utc)
}

stream_comments(reddit = reddit_con,
                subreddit =  'all',
                callback =  parse_comments_wrapper)



# # Do something with submissions
# parse_submission_wrapper <- function(x) {
#   submission_value <- parse_meta(x)
#   glimpse(submission_value)
# }
# stream_submission(reddit_con, 'politics', parse_submission_wrapper)
