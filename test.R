library(redditor)

praw = reticulate::import('praw')

reddit = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                     client_secret=Sys.getenv('REDDIT_AUTH'),
                     user_agent=Sys.getenv('USER_AGENT'),
                     username=Sys.getenv('USERNAME'),
                     password=Sys.getenv('PASSWORD'))

resp <-
  get_user_comments(
    reddit = reddit,
    user = 'fdren',
    type = 'top',
    limit = 10
  )


subreddit <-
  get_subreddit(
    reddit = reddit,
    name = 'politics',
    type = 'top',
    limit = 3
  )

reddit_by_url <-
  get_url(
    reddit = reddit,
    url = 'https://www.reddit.com/r/TwoXChromosomes/comments/g3t7yj/to_the_woman_who_yelled_to_me_from_across_the/'
  )

# Building a bot
# ndexr is my subreddit - have at it if you want to mess aroung
if (FALSE) {
  ndexr <- reddit$subreddit('ndexr')
  iterate(ndexr$stream$comments(), function(x) {
    if(str_detect(x$body, 'googleit')) {
      google_search <- str_trim(str_remove(x$body, "^.*]"))
      google_search <- str_replace_all(google_search, " ", "+")
      lmgtfy <- glue('https://lmgtfy.com/?q={google_search}')
      x$reply(lmgtfy)
    }
  })

}
