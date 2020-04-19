# INSTALLATION GUIDE

`redditor` is a wrapper for the `praw` library in Python, so we need to do some configuration to get R working with reticulate. Listen, reticulate can be a headache. So, if you have issues, please let me know. We can both update the documentation as well as get you up and running. 

```
library(redditor)

# Using glue to paste strings together, however bash uses brackets by default, so we'll create a new delimiter.
new_glue <- function(string) {
  glue(string, .open = "--", .close = "--")
}

# Name of the virtualenv we want to use. I'm using the package name
VIRTUALENV_NAME <- 'redditor'

# All the reddit auth stuff.
# Visit https://www.reddit.com/prefs/apps to get credentials
reddit_auth <-
  list(
    REDDIT_CLIENT = 'YOUR_REDDIT_CLIENT_ID',
    REDDIT_AUTH = 'YOUR_REDDIT_AUTH',
    USER_AGENT = 'YOUR_USER_AGENT',
    USERNAME = 'REDDIT_USERNAME',
    PASSWORD = 'REDDIT_PASSWORD'
  )

walk2(
  names(reddit_auth),
  reddit_auth,
  function(reddit_auth_name, reddit_auth_value) {
    system(glue('echo {reddit_auth_name}={reddit_auth_value} >> .Renviron'))
  }
)

# Create your virtualenv
virtualenv_install(envname = VIRTUALENV_NAME, packages = 'praw')

# Get the path to your virtual environment, if the following returns a path to your virtualenv, then you're in good shape.
# What you need is the path to your virtualenv to be an environment variable in .Renviron in the working directory.
system('ls ${HOME}/.virtualenvs/')

# Add RETICULATE_PYTHON to the directory's .Renviron
system(
  new_glue('echo RETICULATE_PYTHON=${HOME}/.virtualenvs/--VIRTUALENV_NAME--/bin/python >> .Renviron')
)

con = postgres_connector()
praw = reticulate::import('praw')
reddit = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                     client_secret=Sys.getenv('REDDIT_AUTH'),
                     user_agent=Sys.getenv('USER_AGENT'),
                     username=Sys.getenv('USERNAME'),
                     password=Sys.getenv('PASSWORD'))


response = get_user_comments(reddit = reddit, user = 'spez', limit = 10)

dbWriteTable(
  conn = con, name = 'user_comments', value = response, append = TRUE
)

perspective <-  get_url(
  reddit,
  'https://www.reddit.com/r/pics/comments/g01kku/this_perspective_graphite_drawing/'
)

dbWriteTable(
  conn = con, name = 'posts', value = perspective, append = TRUE
)


politics <- get_subreddit(reddit, 'politics', limit = 30)
dbWriteTable(
  conn = con, name = 'hot_scrapes', value = politics, append = TRUE
)

```
