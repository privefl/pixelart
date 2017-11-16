################################################################################

#' Hex to RGB colors
#'
#' @param color Color in hex format (e.g. "#ffffff").
#'
#' @return A color in RGB format (e.g. `c(255, 255, 255)`).
#' @export
#'
#' @examples
#' hex2rgb("#ffffff")
#' hex2rgb("#000000")
hex2rgb <- function(color) {
  stringr::str_sub(color, c(2, 4, 6), c(3, 5, 7)) %>%
    setNames(nm = as.raw(0:255))[.] %>%
    unname()
}

################################################################################

#' Impute missing values
#' 
#' Replace missing values by a default color.
#'
#' @inheritParams pixelart
#' @param colorNA Color in hex format (e.g. "#ffffff").
#'
#' @return  An image object of package **Magick**.
#' @export
#'
#' @examples
#' im0 <- magick::image_read("https://goo.gl/nRQi5n")
#' im <- color_impute(im0)
color_impute <- function(im, colorNA = "#ffffff") {
  
  colorNA <- c(hex2rgb(colorNA), as.raw(255))
  bitmap <- im[[1]]
  
  ind.miss <- which(bitmap[4, , ] < 255, arr.ind = TRUE)
  if (nrow(ind.miss) > 0) {
    for (i in 1:4) {
      bitmap[cbind(i, ind.miss)] <- colorNA[i]
    } 
  }
  
  magick::image_read(bitmap)
}

################################################################################