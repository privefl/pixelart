% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downsize.R
\name{crop}
\alias{crop}
\title{Crop image}
\usage{
crop(im, left = 0, top = 0, right = 0, bottom = 0)
}
\arguments{
\item{im}{An image object of package \strong{Magick}.}

\item{left}{Number of pixels to crop to the left}

\item{top}{Number of pixels to crop to the top}

\item{right}{Number of pixels to crop to the right}

\item{bottom}{Number of pixels to crop to the bottom}
}
\value{
An image object of package \strong{Magick} of reduced or equal size.
}
\description{
Crop image
}
\examples{
plot(im0 <- magick::image_read("https://goo.gl/nRQi5n"))
plot(crop(im0, top = 200))
}
