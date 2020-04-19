# INSTALLATION GUIDE

`redditor` is a wrapper for the `praw` library in Python, so we need to do some configuration to get R working with reticulate. Listen, reticulate can be a headache. So, if you have issues, please let me know. We can both update the documentation as well as get you up and running. 

# AFTER RUNNING THE CODE BELOW WITH YOUR ASSOCIATED ENVIRONMENT VARIABLES, RESTART YOUR R SESSION
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

```


# RUNNING THE SOFTWARE

```
library(redditor)

praw = reticulate::import('praw')

reddit_con = praw$Reddit(client_id=Sys.getenv('REDDIT_CLIENT'),
                         client_secret=Sys.getenv('REDDIT_AUTH'),
                         user_agent=Sys.getenv('USER_AGENT'),
                         username=Sys.getenv('USERNAME'),
                         password=Sys.getenv('PASSWORD'))

resp <-
  get_user_comments(
    reddit = reddit_con,
    user = 'fdren',
    type = 'top',
    limit = 10
  )

# > resp
# # A tibble: 10 x 46
#    archived author author_fullname author_premium body  can_guild can_mod_post controversality created created_utc         downs
#    <lgl>    <chr>  <chr>           <lgl>          <chr> <chr>     <lgl>        <chr>             <dbl> <dttm>              <dbl>
#  1 TRUE     fdren  t2_15e764       FALSE          "Tha… ""        FALSE        ""               1.53e9 2018-08-14 14:04:50     0
#  2 TRUE     fdren  t2_15e764       FALSE          "Yep… ""        FALSE        ""               1.51e9 2017-09-15 15:41:01     0
#  3 TRUE     fdren  t2_15e764       FALSE          "Tha… ""        FALSE        ""               1.49e9 2017-04-17 20:32:55     0
#  4 TRUE     fdren  t2_15e764       FALSE          "He … ""        FALSE        ""               1.49e9 2017-04-17 18:57:40     0
#  5 TRUE     fdren  t2_15e764       FALSE          "Loo… ""        FALSE        ""               1.53e9 2018-08-14 14:14:01     0
#  6 TRUE     fdren  t2_15e764       FALSE          "Rog… ""        FALSE        ""               1.53e9 2018-08-14 14:01:52     0
#  7 TRUE     fdren  t2_15e764       FALSE          "Don… ""        FALSE        ""               1.54e9 2018-11-02 12:27:26     0
#  8 TRUE     fdren  t2_15e764       FALSE          "Thi… ""        FALSE        ""               1.51e9 2017-12-30 06:11:14     0
#  9 TRUE     fdren  t2_15e764       FALSE          "We … ""        FALSE        ""               1.49e9 2017-04-29 10:30:19     0
# 10 TRUE     fdren  t2_15e764       FALSE          "Sad… ""        FALSE        ""               1.49e9 2017-03-21 20:02:10     0
# # … with 35 more variables: edited <lgl>, fullname <chr>, gilded <chr>, id <chr>, id_from_url <chr>, is_root <lgl>,
# #   is_submitter <lgl>, link_author <chr>, link_id <chr>, link_permalink <chr>, link_title <chr>, link_url <chr>, locked <lgl>,
# #   MISSING_COMMENT_MESSAGE <chr>, name <chr>, no_follow <lgl>, num_comments <dbl>, over_18 <lgl>, parent_id <chr>,
# #   permalink <chr>, quarantine <lgl>, score <dbl>, score_hidden <lgl>, send_replies <lgl>, stickied <lgl>, STR_FIELD <chr>,
# #   submission <chr>, subreddit <chr>, subreddit_id <chr>, subreddit_name_prefixed <chr>, subreddit_type <chr>,
# #   total_awards_received <chr>, ups <dbl>, total_awards_recieved <dbl>, time_gathered_utc <dttm>

subreddit <-
  get_subreddit(
    reddit = reddit_con,
    name = 'politics',
    type = 'hot',
    limit = 3
  )
  
# > subreddit
# $meta_data
# # A tibble: 3 x 57
#   author author_fullname author_premium author_patreon_… can_gild can_mod_post clicked comment_limit created created_utc downs edited fullname gilded hidden hide_score
#   <chr>  <chr>           <chr>          <chr>            <chr>    <chr>        <chr>   <chr>         <chr>   <chr>       <chr> <chr>  <chr>    <chr>  <chr>  <chr>     
# 1 optim… t2_d5h4t        FALSE          FALSE            FALSE    FALSE        FALSE   2048          158725… 1587223148  0     FALSE  t3_g3p5… 0      FALSE  FALSE     
# 2 Polit… t2_onl9u        TRUE           FALSE            FALSE    FALSE        FALSE   2048          158727… 1587246398  0     15872… t3_g3vq… 0      FALSE  FALSE     
# 3 Zhana… t2_4o78am42     TRUE           FALSE            FALSE    FALSE        FALSE   2048          158726… 1587240554  0     FALSE  t3_g3u3… 0      FALSE  FALSE     
# # … with 41 more variables: id <chr>, is_crosspostable <chr>, is_meta <chr>, is_original_content <chr>, is_reddit_media_domain <chr>, is_robot_indexable <chr>,
# #   is_self <chr>, is_video <chr>, locked <chr>, media_only <chr>, name <chr>, no_follow <chr>, num_comments <chr>, num_crossposts <chr>, num_duplicates <chr>,
# #   over_18 <chr>, parent_whitelist_status <chr>, permalink <chr>, pinned <chr>, pwls <chr>, quarantine <chr>, saved <chr>, score <chr>, selftext <chr>,
# #   send_replies <chr>, shortlink <chr>, spoiler <chr>, stickied <chr>, subreddit <chr>, subreddit_id <chr>, subreddit_name_prefixed <chr>, subreddit_subscribers <chr>,
# #   subreddit_type <chr>, thumbnail <chr>, title <chr>, total_awards_received <chr>, ups <chr>, upvote_ratio <chr>, url <chr>, visited <chr>, wls <chr>
# 
# $comments
# # A tibble: 1,361 x 28
#    author author_fullname author_patreon_… author_premium body  can_gild can_mod_post controversiality created created_utc         depth downs fullname id    is_root
#    <chr>  <chr>           <lgl>            <lgl>          <chr> <lgl>    <lgl>                   <dbl>   <dbl> <dttm>              <dbl> <dbl> <chr>    <chr> <lgl>  
#  1 ThatD… t2_48b22        FALSE            FALSE          "[Mi… TRUE     FALSE                       0  1.59e9 2020-04-18 15:44:07     0     0 t1_fnsm… fnsm… TRUE   
#  2 NotBa… t2_4db72jwz     FALSE            FALSE          "Two… TRUE     FALSE                       0  1.59e9 2020-04-18 16:48:16     0     0 t1_fnst… fnst… TRUE   
#  3 NotBa… t2_4db72jwz     FALSE            FALSE          "Rob… TRUE     FALSE                       0  1.59e9 2020-04-18 16:48:40     0     0 t1_fnst… fnst… TRUE   
#  4 NotBa… t2_4db72jwz     FALSE            FALSE          "Thr… TRUE     FALSE                       0  1.59e9 2020-04-18 16:49:17     0     0 t1_fnst… fnst… TRUE   
#  5 glass… t2_niwn3        FALSE            FALSE          "[To… TRUE     FALSE                       0  1.59e9 2020-04-18 15:38:59     0     0 t1_fnsl… fnsl… TRUE   
#  6 4bloc… t2_53xqk        FALSE            TRUE           "On … TRUE     FALSE                       0  1.59e9 2020-04-18 15:22:14     0     0 t1_fnsk… fnsk… TRUE   
#  7 glass… t2_niwn3        FALSE            FALSE          "[Sa… TRUE     FALSE                       0  1.59e9 2020-04-18 15:38:31     0     0 t1_fnsl… fnsl… TRUE   
#  8 NotBa… t2_4db72jwz     FALSE            FALSE          "I'm… TRUE     FALSE                       0  1.59e9 2020-04-18 16:49:05     0     0 t1_fnst… fnst… TRUE   
#  9 NotBa… t2_4db72jwz     FALSE            FALSE          "Som… TRUE     FALSE                       0  1.59e9 2020-04-18 16:50:40     0     0 t1_fnst… fnst… TRUE   
# 10 NotBa… t2_4db72jwz     FALSE            FALSE          "Thr… TRUE     FALSE                       0  1.59e9 2020-04-18 16:49:54     0     0 t1_fnst… fnst… TRUE   
# # … with 1,351 more rows, and 13 more variables: is_submitter <lgl>, link_id <chr>, name <chr>, no_follow <lgl>, parent_id <chr>, permalink <chr>, score <dbl>,
# #   submission <chr>, subreddit <chr>, subreddit_id <chr>, total_awards_received <dbl>, ups <dbl>, time_gathered_utc <dttm>


reddit_by_url <-
  get_url(
    reddit = reddit_con,
    url = 'https://www.reddit.com/r/TwoXChromosomes/comments/g3t7yj/to_the_woman_who_yelled_to_me_from_across_the/'
  )

# > reddit_by_url
# $meta_data
# # A tibble: 1 x 58
#   author author_fullname author_premium author_patreon_… author_premium can_gild can_mod_post clicked comment_limit created created_utc downs edited fullname gilded hidden
#   <chr>  <chr>           <chr>          <chr>            <chr>          <chr>    <chr>        <chr>   <chr>         <chr>   <chr>       <chr> <chr>  <chr>    <chr>  <chr> 
# 1 Reshi… t2_pz3ksp9      FALSE          FALSE            FALSE          FALSE    FALSE        FALSE   2048          158726… 1587237472  0     15872… t3_g3t7… 0      FALSE 
# # … with 42 more variables: hide_score <chr>, id <chr>, is_crosspostable <chr>, is_meta <chr>, is_original_content <chr>, is_reddit_media_domain <chr>,
# #   is_robot_indexable <chr>, is_self <chr>, is_video <chr>, locked <chr>, media_only <chr>, name <chr>, no_follow <chr>, num_comments <chr>, num_crossposts <chr>,
# #   num_duplicates <chr>, over_18 <chr>, parent_whitelist_status <chr>, permalink <chr>, pinned <chr>, pwls <chr>, quarantine <chr>, saved <chr>, score <chr>, selftext <chr>,
# #   send_replies <chr>, shortlink <chr>, spoiler <chr>, stickied <chr>, subreddit <chr>, subreddit_id <chr>, subreddit_name_prefixed <chr>, subreddit_subscribers <chr>,
# #   subreddit_type <chr>, thumbnail <chr>, title <chr>, total_awards_received <chr>, ups <chr>, upvote_ratio <chr>, url <chr>, visited <chr>, wls <chr>
# 
# $comments
# # A tibble: 83 x 28
#    author author_fullname author_patreon_… author_premium body  can_gild can_mod_post controversiality created created_utc         depth downs fullname id    is_root
#    <chr>  <chr>           <lgl>            <lgl>          <chr> <lgl>    <lgl>                   <dbl>   <dbl> <dttm>              <dbl> <dbl> <chr>    <chr> <lgl>  
#  1 chick… t2_3r0xzvx2     FALSE            FALSE          "The… TRUE     FALSE                       0  1.59e9 2020-04-18 20:33:43     0     0 t1_fnth… fnth… TRUE   
#  2 ducke… t2_mtvk7        FALSE            FALSE          "I w… TRUE     FALSE                       0  1.59e9 2020-04-18 22:16:01     0     0 t1_fntt… fntt… TRUE   
#  3 craft… t2_4sopcg4a     FALSE            FALSE          "I'v… TRUE     FALSE                       0  1.59e9 2020-04-18 21:33:11     0     0 t1_fnto… fnto… TRUE   
#  4 Wiggy… t2_ypzb1        FALSE            FALSE          "Aww… TRUE     FALSE                       0  1.59e9 2020-04-18 19:53:54     0     0 t1_fntd… fntd… TRUE   
#  5 swaga… t2_175eo2       FALSE            FALSE          "Som… TRUE     FALSE                       0  1.59e9 2020-04-18 20:46:37     0     0 t1_fntj… fntj… TRUE   
#  6 Storm… t2_5ifb4bhk     FALSE            FALSE          "Wha… TRUE     FALSE                       0  1.59e9 2020-04-18 20:01:45     0     0 t1_fnte… fnte… TRUE   
#  7 pluto… t2_4hojq3pe     FALSE            FALSE          "Hec… TRUE     FALSE                       0  1.59e9 2020-04-18 20:16:57     0     0 t1_fntg… fntg… TRUE   
#  8 Willo… t2_tee6h        FALSE            FALSE          "Do … TRUE     FALSE                       0  1.59e9 2020-04-18 23:26:43     0     0 t1_fnu0… fnu0… TRUE   
#  9 becky… t2_58dcc        FALSE            FALSE          "Ann… TRUE     FALSE                       0  1.59e9 2020-04-18 22:29:03     0     0 t1_fntu… fntu… TRUE   
# 10 Nicky… t2_r7fhd        FALSE            FALSE          "The… TRUE     FALSE                       0  1.59e9 2020-04-18 22:14:22     0     0 t1_fnts… fnts… TRUE   
# # … with 73 more rows, and 13 more variables: is_submitter <lgl>, link_id <chr>, name <chr>, no_follow <lgl>, parent_id <chr>, permalink <chr>, score <dbl>, submission <chr>,
# #   subreddit <chr>, subreddit_id <chr>, total_awards_received <dbl>, ups <dbl>, time_gathered_utc <dttm>

```
