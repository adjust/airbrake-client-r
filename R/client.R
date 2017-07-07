.AibrakeEnvir <- new.env()

.airbrake.url <- function() {
  host <- get('host', envir=.AibrakeEnvir)
  project.id <- get('project.id', envir=.AibrakeEnvir)
  project.key <- get('project.key', envir=.AibrakeEnvir)

  if (any(is.na(c(host, project.id, project.key)))) stop("Airbrake connection not configured.")

  sprintf('%s/api/v3/projects/%s/notices?key=%s', host, project.id, project.key)
}

#' Configure Airbrake.
#' @export
airbrake.config <- function(project.id, project.key, host='https://airbrake.io') {
  assign('project.id', project.id, envir=.AibrakeEnvir)
  assign('project.key', project.key, envir=.AibrakeEnvir)
  assign('host', host, envir=.AibrakeEnvir)
}

#' Send an Airbrake notification on error. Example `tryCatch(stop('error'), error=airbrake.notify)`
#' @export
airbrake.notify <- function(error) {
  template <- '{
    "errors":[{"type":"%s","message":"%s","backtrace":[{"file":"","line":0,"function":""}]}],
    "context":{"notifier":{"name":"Rport","version":"0.0.1"},"hostname":"%s","environment":"production"},
    "environment":{}
  }'

  err.type    <- paste(class(error), collapse=',')
  err.message <- gsub('(\\n|\\")', '', as.character(error))
  hostname    <- Sys.info()['nodename']
  payload     <- sprintf(template, err.type, err.message, hostname)

  cat("Notifying Errbit...\n")
  resp <- POST(url=.airbrake.url(), body=payload, encode='json', add_headers('Content-Type'='application/json'))

  if (status_code(resp) == 201 || status_code(resp) == 200)
    cat("OK.\n")
  else
    cat("Error connecting to Airbrake:", status_code(resp), "\n")
}

#' Send an Airbrake notification on error and then raise the error again. Useful
#' for scripts where the proper OS exit codes are relevant.
#' @export
airbrake.notify.and.raise <- function(error) {
  airbrake.notify(error)
  stop(error)
}
