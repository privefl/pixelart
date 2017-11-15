#' Run Shiny App
#'
#' @return Nothing.
#' @export
#'
run_app <- function() {
  
  loc <- system.file("shiny/pixelart", package = "pixelart")
  shiny::runApp(loc)
}