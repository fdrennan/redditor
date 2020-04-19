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
    type = 'hot',
    limit = 3
  )

reddit_by_url <-
  get_url(
    reddit = reddit,
    url = 'https://www.reddit.com/r/TwoXChromosomes/comments/g3t7yj/to_the_woman_who_yelled_to_me_from_across_the/'
  )
