#' @export find_posts
find_posts <- function(key, limit = 1000, to_json = FALSE) {

  con = postgres_connector()
  on.exit({
    dbDisconnect(conn = con)
    message('Disconnecting from Postgres')
  })

  stream_submissions <-
    tbl(con, in_schema('public', 'stream_submissions')) %>%
    arrange(desc(created_utc))


  comments <-
    stream_submissions %>%
    filter(
      str_detect(str_to_lower(title), key) | str_detect(str_to_lower(selftext), key)
    ) %>%
    head(limit) %>%
    collect

  if (to_json) {
    return(toJSON(comments))
  } else {
    return(comments)
  }
}

#' @export mat_comments_by_second
mat_comments_by_second <- function(limit = 1000) {

  con = postgres_connector()
  on.exit({
    dbDisconnect(conn = con)
    message('Disconnecting from Postgres')
  })

  mat_comments_by_second <-
    tbl(con, in_schema('public', 'mat_comments_by_second')) %>%
    mutate_if(is.numeric, as.numeric) %>%
    head(limit) %>%
    collect

  mat_comments_by_second
}

#' @export plot_stream
plot_stream <- function(limit = 300,
                        timezone='UTC',
                        granularity = '1 mins',
                        add_hours = 0,
                        table = 'comments') {

  needed_table <- switch(
    table,
    'comments' = {'mat_comments_by_second'},
    'submissions' = {'mat_submissions_by_second'},
  )



  con = postgres_connector()
  on.exit(dbDisconnect(conn = con))

  data <-
    tbl(con, in_schema('public', needed_table)) %>%
    mutate_if(is.numeric, as.numeric) %>%
    arrange(desc(created_utc)) %>%
    head(limit) %>%
    collect

  data <-
    data %>%
    mutate(created_utc = round_date(created_utc, granularity)) %>%
    group_by(created_utc) %>%
    summarise(n_observations = sum(n_observations))

  gg <-
    data %>%
    ggplot() +
    aes(x = with_tz(created_utc, tzone = timezone) + hours(add_hours), y = n_observations) +
    geom_point(size = 1/10) +
    geom_col() +
    ylim(c(0, max(data$n_observations) + 5))

  gg <-
    gg +
    ggtitle(glue('Number of {table} gathered in {granularity} intervals')) +
    xlab(glue('Time: {timezone}')) +
    ylab('Number of Observations')

  return(gg)
}



#' @export get_summary
get_summary <- function() {
  con = postgres_connector()
  on.exit(dbDisconnect(conn = con))


  stream_submission_meta_data <-
    tbl(con, in_schema('public', 'stream_submission_meta_data')) %>%
    filter(meta %in% 'time') %>%
    mutate(table = 'stream_submission_meta_data') %>%
    collect

  streamall_meta_data <-
    tbl(con, in_schema('public', 'streamall_meta_data')) %>%
    mutate(table = 'streamall_meta_data') %>%
    filter(meta %in% 'time') %>%
    collect

  streamall_authors <-
    tbl(con, in_schema('public', 'streamall_meta_data')) %>%
    mutate(table = 'streamall_meta_data') %>%
    filter(meta == 'author') %>%
    mutate(amount = as.numeric(amount)) %>%
    arrange(desc(amount)) %>%
    mutate(amount = as.character(amount)) %>%
    head(30) %>%
    collect

  streamall_subreddits <-
    tbl(con, in_schema('public', 'streamall_meta_data')) %>%
    mutate(table = 'streamall_meta_data') %>%
    filter(meta == 'subreddit') %>%
    mutate(amount = as.numeric(amount)) %>%
    arrange(desc(amount)) %>%
    mutate(amount = as.character(amount)) %>%
    head(30) %>%
    collect


  binder <-
    stream_submission_meta_data %>%
    bind_rows(streamall_meta_data) %>%
    bind_rows(streamall_authors) %>%
    bind_rows(streamall_subreddits) %>%
    group_by(meta) %>%
    mutate(id = row_number()) %>%
    nest

  binder

}
