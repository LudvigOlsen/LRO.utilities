% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/not_in.R
\name{\%ni\%}
\alias{\%ni\%}
\title{Values Not In}
\usage{
x \%ni\% table
}
\arguments{
\item{x}{Vector with values to be matched.}

\item{table}{Vector with values to be matched against.}
}
\value{
A logical vector, indicating if no match
 was located for each element of x.
 Values are TRUE or FALSE and never NA.
}
\description{
Negated \code{\%in\%}.
}
