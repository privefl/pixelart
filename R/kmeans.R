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
  
  im[[1]] %>%
    apply(1, as.integer) %>%
    .[, 1:3] %>%
    grDevices::convertColor(from = "sRGB", to = "Lab") %>%
    flexclust::kcca(k = ncolors)
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
  
  rgb_mat <- apply(im[[1]], 1, as.integer)[, 1:3]
  
  clusters <- rgb_mat %>%
    grDevices::convertColor(from = "sRGB", to = "Lab") %>%
    flexclust::predict(kmeans, .)
  
  colors <- sapply(seq_len(kmeans@k), function(group) {
    rgb_mat[clusters == group, 1:3, drop = FALSE] %>%
      colMeans() %>%
      round() %>%
      as.raw() %>%
      c("#", .) %>%
      paste(collapse = "")
  })
  
  matrix(colors[clusters], nrow = dim(im[[1]])[2])
}

################################################################################