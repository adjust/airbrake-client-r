# Simple helper to build the package documentation
build:
	R -e 'library(roxygen2); roxygenise()' && git status
