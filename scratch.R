library(redditor)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))



submission_stream <- function(reddit, subreddit, callback) {
  politics <- reddit_con$subreddit(subreddit)
  iterate(politics$stream$submission(), callback)
}


get_submission <- function(x) {
  print(pasrse_meta(x))
  Sys.sleep(10)
}


comment_stream(reddit_con, 'all', get_comments)
