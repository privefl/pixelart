################################################################################

#' Pipeline to get pixel art
#'
#' @param url URL of image.
#' @param resize1 Initial resize width for processing.
#' @param ncolors Number of different colors.
#' @param resize2 Final resize widthg.
#' @param color_bg Color replacing missing values (e.g. "#ffffff").
#' @inheritParams magick::image_rotate
#' @inheritParams magick::image_modulate
#' @inheritParams crop
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
#'   color_bg = "#ffffff"
#' )
pipeline <- function(url, resize1 = 100, ncolors = 7, resize2 = 20, 
                     color_bg = "white", saturation = 100, degrees = 0,
                     left = 0, top = 0, right = 0, bottom = 0) {
  im0 <- url %>%
    magick::image_read() %>%
    magick::image_background(color_bg) %>%
    crop(left = left, right = right, bottom = bottom, top = top) %>%
    magick::image_rotate(degrees) %>%
    magick::image_modulate(saturation = saturation)
    
  im1 <- downsize(im0, resize1)
  kmeans <- kmeans_colors(im1, ncolors)
  
  im2 <- downsize(im0, resize2)
  plot_color_matrix(colors_kmeans(im2, kmeans))
}

################################################################################