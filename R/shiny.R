################################################################################

#' Run Shiny app for pixel art models
#' 
#' @inherit shiny::runApp
#' @inheritDotParams shiny::runApp -appDir -launch.browser
#' @return Nothing.
#' @export
#'
run_pixelart <- function(launch.browser = TRUE, ...) {
  
  loc <- system.file("shiny/pixelart", package = "pixelart")
  shiny::runApp(loc, launch.browser = launch.browser, ...)
}

################################################################################

#' Run Shiny app for resizing an image
#'
#' @inherit shiny::runApp
#' @inheritDotParams shiny::runApp -appDir -launch.browser
#' @return Nothing.
#' @export
#'
run_resize <- function(launch.browser = TRUE, ...) {
  
  loc <- system.file("shiny/resize", package = "pixelart")
  shiny::runApp(loc, launch.browser = launch.browser, ...)
}

################################################################################
