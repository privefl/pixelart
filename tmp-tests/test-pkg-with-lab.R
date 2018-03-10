url <- "https://goo.gl/nRQi5n"
ncolors <- 6

im0 <- url %>%
  magick::image_read() %>%
  magick::image_background("white") %>%
  magick::image_modulate(saturation = 100)

im1 <- downsize(im0, 200)
kmeans <- kmeans_colors(im1, ncolors)

im2 <- downsize(im0, 30)

cols <- colors_kmeans(im2, kmeans)
plot_color_matrix(cols)
