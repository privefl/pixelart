################################################################################

#' Perform K-means on RGB colors
#'
#' @inheritParams pixelart
#' @param ncolors Number of colors (clusters). Default is 8.
#'
#' @return An object of class *kcca* of package **flexclust**.
#' @export
#'
#' @examples
#' im0 <- magick::image_read("https://goo.gl/nRQi5n")
#' im <- magick::image_resize(im0, "100")
#' kmeans <- kmeans_colors(im)
#' kmeans@centers
kmeans_colors <- function(im, ncolors = 8) {
  flexclust::kcca(apply(im[[1]], 1, as.integer), ncolors)
}

################################################################################

#' Colors from kmeans
#' 
#' Get projection on kmeans for colors of image.
#'
#' @inheritParams pixelart
#' @param kmeans An object of class *kcca* of package **flexclust**.
#'
#' @return A matrix of colors (in hex format, e.g. "#ffffff").
#' @export
#'
#' @examples
#' im0 <- magick::image_read("https://goo.gl/nRQi5n")
#' im <- magick::image_resize(im0, "100")
#' kmeans <- kmeans_colors(im, 5)
#' im_small <- magick::image_resize(im0, "30")
#' plot(im_small)
#' table(colors <- colors_kmeans(im_small, kmeans))
#' plot_color_matrix(colors)
colors_kmeans <- function(im, kmeans) {
  
  tmp <- im[[1]] %>%
    apply(1, as.integer) %>%
    flexclust::predict(kmeans, .) %>%
    kmeans@centers[., ] %>%
    round()
  
  matrix(paste0("#", as.raw(tmp[, 1]), as.raw(tmp[, 2]), as.raw(tmp[, 3])), 
         nrow = dim(im[[1]])[2])
}

################################################################################