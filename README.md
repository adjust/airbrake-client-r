### airbrakeR - R interface for notifying Airbrake on errors.

Running R dashboard apps, or reporting and other scripts might produce errors
that maintainers need to be notified about. Airbrake offers an API and this
client an interface to R for this API.

### Usage

A typical usecase becomes clear from this example:

```R
library(airbrakeR)

airbrake.config(project.id='123', project.key='key', host='https://errbit.abcd.com')

tryCatch({
  # work ...
  stop('Unexpected error occurred')
}, error=airbrake.notify)
```

### Installation

You can install this from GitHub using `devtools` by:

```R
library(devtools)
devtools::install_github('adjust/airbrake-client-r');
```
