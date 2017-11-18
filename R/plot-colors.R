################################################################################

#' Plot color matrix
#'
#' @param raster A matrix of colors (in hex format, e.g. "#ffffff").
#'
#' @return A *ggplot* object.
#' @export
#' 
#' @import ggplot2
#'
#' @examples
#' (colors <- matrix(c("#008744", "#0057e7", "#d62d20", "#ffa700"), 2))
#' plot_color_matrix(colors)
plot_color_matrix <- function(raster) {
  
  rows <- seq_len(nrow(raster))
  cols <- seq_len(ncol(raster))
  
  cbind(
    expand.grid(y = rev(cols), x = rows),
    expand.grid(color = t(raster), stringsAsFactors = FALSE)) %>%
    ggplot() +
    geom_tile(aes_string("x", "y", fill = "I(color)")) +
    coord_equal() +
    theme_void() +
    geom_vline(xintercept = c(0.5, rows + 0.5), size = 0.5) +
    geom_hline(yintercept = c(0.5, cols + 0.5), size = 0.5)
}

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
    stats::setNames(nm = as.raw(0:255))[.] %>%
    unname()
}

################################################################################