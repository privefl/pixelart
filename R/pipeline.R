################################################################################

#' Pipeline to get pixel art
#'
#' @param input A list with
#'   - `url`: the url of the image,
#'   - `resize1`: the width of the initial downsize (for processing), 
#'   - `resize2`: the width of the final image,
#'   - `ncolors`: the number of different colors   
#'
#' @return A *ggplot* object.
#' @export
#'
#' @examples
#' pipeline(list(
#'   url = "https://goo.gl/nRQi5n", 
#'   resize1 = 100,
#'   resize2 = 22,
#'   ncolors = 6
#' ))
pipeline <- function(input) {
  im0 <- magick::image_read(input$url)
  im1 <- downsize(im0, input$resize1)
  im2 <- downsize(im0, input$resize2)
  kmeans <- kmeans_colors(im1, input$ncolors)
  plot_color_matrix(colors_kmeans(im2, kmeans))
}

################################################################################