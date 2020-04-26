#' @export find_posts
find_posts <- function(key, limit = 1000, to_json = FALSE) {

  con = postgres_connector()
  on.exit({
    dbDisconnect(conn = con)
    message('Disconnecting from Postgres')
  })

  stream_submissions <-
    tbl(con, in_schema('public', 'stream_submissions'))


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
plot_stream <- function(limit = 300) {
  con = postgres_connector()
  on.exit(dbDisconnect(conn = con))

  data <-
    tbl(con, in_schema('public', 'mat_comments_by_second')) %>%
    mutate_if(is.numeric, as.numeric) %>%
    arrange(desc(created_utc)) %>%
    head(limit) %>%
    collect

  print(max(data$created_utc))

  gg <-
    data %>%
    ggplot() +
    aes(x = with_tz(created_utc, tzone = 'UTC'), y = n_observations) +
    geom_point(size = 3/10) +
    geom_line() +
    ylim(c(0, max(data$n_observations) + 5))

  return(gg)
}
