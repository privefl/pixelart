################################################################################

#' Downsize an image
#'
#' @inheritParams pixelart-package
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

#' Crop image
#'
#' @inheritParams pixelart-package
#' @param left Number of pixels to crop to the left
#' @param top Number of pixels to crop to the top
#' @param right Number of pixels to crop to the right
#' @param bottom Number of pixels to crop to the bottom
#'
#' @return An image object of package **Magick** of reduced or equal size.
#' @export
#'
#' @examples
#' plot(im0 <- magick::image_read("https://goo.gl/nRQi5n"))
#' plot(crop(im0, top = 200))
crop <- function(im, left = 0, top = 0, right = 0, bottom = 0) {
  
  d <- dim(im[[1]])
  w <- d[2]
  h <- d[3]
  magick::image_crop(
    im, 
    glue::glue("{w-left-right}x{h-top-bottom}+{left}+{top}")
  )
}

################################################################################