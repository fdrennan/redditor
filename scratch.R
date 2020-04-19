library(redditor)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))



# Do something with comments
parse_comments_wrapper <- function(x) {
  submission_value <- parse_comments(x)
  glimpse(submission_value)
}
stream_comments(reddit_con, 'politics', parse_comments_wrapper)


# Do something with submissions
parse_submission_wrapper <- function(x) {
  submission_value <- parse_meta(x)
  glimpse(submission_value)
}
stream_submission(reddit_con, 'politics', parse_submission_wrapper)
