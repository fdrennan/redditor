#' @export stream_comments
stream_comments <- function(reddit, subreddit, callback) {
  stream <- reddit_con$subreddit(subreddit)
  iterate(stream$stream$comments(), callback)
}


#' @export stream_submission
stream_submission <- function(reddit, subreddit, callback) {
  stream <- reddit_con$subreddit(subreddit)
  iterate(stream$stream$submissions(), callback)
}
