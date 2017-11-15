################################################################################

#' Downsize an image
#'
#' @inheritParams pixelart
#' @param npixel_width Number of pixels for the width of the image.
#'
#' @return An image object of package **Magick** of reduced or equal size.
#' @export
#'
#' @examples
#' im0 <- magick::image_read("https://goo.gl/nRQi5n")
#' print(im <- downsize(im0, 100))
#' print(downsize(im, 200))  # only downsize
downsize <- function(im, npixel_width = 200) {
  
  `if`(dim(im[[1]])[2] <= npixel_width, im, 
       magick::image_resize(im, as.character(npixel_width)))
}

################################################################################