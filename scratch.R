library(redditor)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))

politics <- reddit_con$subreddit('all')
iterate(politics$stream$comments(), function(x) {
  # if (x$is_submitter) {
    message(
      glue("\n\n{x$author}\n{x$body}\nIs Submitter: {x$is_submitter}\nLink: {x$link_permalink}")
    )
  # }
})



