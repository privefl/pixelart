################################################################################

#' Pipeline to get pixel art
#'
#' @param url URL of image.
#' @param resize1 Initial resize width for processing.
#' @param ncolors Number of different colors.
#' @param resize2 Final resize widthg.
#' @param colorNA Color replacing missing values (e.g. "#ffffff").
#'
#' @return A *ggplot* object.
#' @export
#'
#' @examples
#' pipeline(
#'   url = "https://goo.gl/nRQi5n", 
#'   resize1 = 100,
#'   resize2 = 22,
#'   ncolors = 6,
#'   colorNA = "#ffffff"
#' )
pipeline <- function(url, resize1, ncolors, resize2, colorNA) {
  im0 <- color_impute(magick::image_read(url), colorNA)
  im1 <- downsize(im0, resize1)
  im2 <- downsize(im0, resize2)
  kmeans <- kmeans_colors(im1, ncolors)
  plot_color_matrix(colors_kmeans(im2, kmeans))
}

################################################################################