library(magick)


plot_image <- function(im) {
  
  library(ggplot2)
  
  raster <- as.raster(im)
  rows <- seq_len(nrow(raster))
  cols <- seq_len(ncol(raster))
  
  cbind(
    expand.grid(y = rev(rows), x = cols),
    expand.grid(color = raster, stringsAsFactors = FALSE)) %>%
    ggplot() +
    geom_tile(aes(x, y, fill = I(color))) +
    coord_equal() +
    theme_void() +
    geom_vline(xintercept = c(0.5, cols + 0.5)) +
    geom_hline(yintercept = c(0.5, rows + 0.5))
}

im0 <- magick::image_read("https://www.tutsps.com/images/Tuto_photoshop_Dessiner_un_Lapin_Cretin/Tuto_photoshop_Dessiner_un_Lapin_Cretin_27.JPG")


plot_image(image_resize(im0, geometry = "30", "Point"))
plot_image(image_resize(im0, geometry = "30", "Box"))
plot_image(image_resize(im0, geometry = "30", "Lanczos"))
plot_image(image_resize(im0, geometry = "30", "Triangle"))
plot_image(image_resize(im0, geometry = "30", "Hermite"))
plot_image(image_resize(im0, geometry = "30", "Hanning"))
plot_image(image_resize(im0, geometry = "30", "Blackman"))
plot_image(image_resize(im0, geometry = "30", "Gaussian"))
plot_image(image_resize(im0, geometry = "30", "Cubic"))
plot_image(image_resize(im0, geometry = "30", "Catrom"))
plot_image(image_resize(im0, geometry = "30", "Bessel"))


im0 <- magick::image_read('https://www.tutsps.com/images/Tuto_photoshop_Dessiner_un_Lapin_Cretin/Tuto_photoshop_Dessiner_un_Lapin_Cretin_27.JPG')
# im0 <- magick::image_read('http://p6.storage.canalblog.com/66/25/1309561/107143446.jpeg')
# im0 <- magick::image_read('https://wir.skyrock.net/wir/v1/resize/?c=isi&im=%2F4256%2F75864256%2Fpics%2F3029540548_1_3_4r1s0B9N.jpg&w=250')
# im0 <- magick::image_read('http://www.happyhousewife.fr/wp-content/uploads/Logo-Batman.png')
# im0 <- magick::image_read("https://i2-prod.mirror.co.uk/incoming/article7731571.ece/ALTERNATES/s298/Pokemon-charmander.png")
im0 <- magick::image_read("https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/1200px-International_Pok%C3%A9mon_logo.svg.png")
# im0 <- magick::image_read("https://i.pinimg.com/736x/ba/fc/f9/bafcf94994c2e67099f9fc67cb6287c3--fiesta-ironman-face-template.jpg")


ncolors <- 3

im <- magick::image_resize(im0, "200")

kmeans <- flexclust::kcca(apply(im[[1]], 1, function(x) as.integer(x)), ncolors)
kmeans@centers
kmeans@cluster


im_small <- image_resize(im0, geometry = "80")
tmp <- im_small[[1]] %>%
  apply(1, as.integer) %>%
  flexclust::predict(kmeans, .) %>%
  kmeans@centers[., ] %>%
  round()
  
colors <- paste0("#", as.raw(tmp[, 1]), as.raw(tmp[, 2]), as.raw(tmp[, 3]))  
dim(colors) <- dim(im_small[[1]])[2:3]

plot_image2 <- function(raster) {
  
  library(ggplot2)
  
  rows <- seq_len(nrow(raster))
  cols <- seq_len(ncol(raster))
  
  cbind(
    expand.grid(y = rev(cols), x = rows),
    expand.grid(color = t(colors), stringsAsFactors = FALSE)) %>%
    ggplot() +
    geom_tile(aes(x, y, fill = I(color))) +
    coord_equal() +
    theme_void() +
    geom_vline(xintercept = c(0.5, rows + 0.5), size = 0.5) +
    geom_hline(yintercept = c(0.5, cols + 0.5), size = 0.5)
}

plot_image2(colors)

