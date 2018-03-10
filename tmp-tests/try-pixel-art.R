library(imager)

im <- load.image('http://jeroen.github.io/images/tiger.svg')

for (i in 0:6) {
  plot(resize(im, 20, 20, interpolation_type = i), main = i)
}
im_resized <- resize(im, 10, 10, )
plot(im)
plot(im_resized)

plot(im)
im2 <- imager::RGBtoLab(im)
plot(im2)

im2[1, 1, , ]

# im0 <- load.image('https://www.tutsps.com/images/Tuto_photoshop_Dessiner_un_Lapin_Cretin/Tuto_photoshop_Dessiner_un_Lapin_Cretin_27.JPG')
im0 <- load.image('https://i.ytimg.com/vi/uAuKfROSQnw/maxresdefault.jpg')
# im0 <- load.image('http://p6.storage.canalblog.com/66/25/1309561/107143446.jpeg')
# im0 <- load.image('https://wir.skyrock.net/wir/v1/resize/?c=isi&im=%2F4256%2F75864256%2Fpics%2F3029540548_1_3_4r1s0B9N.jpg&w=250')
im0 <- load.image('https://i.ytimg.com/vi/SQzHehzdNmk/maxresdefault.jpg')
# im0 <- load.image('http://www.happyhousewife.fr/wp-content/uploads/Logo-Batman.png')
# im0 <- load.image("https://i2-prod.mirror.co.uk/incoming/article7731571.ece/ALTERNATES/s298/Pokemon-charmander.png")
# im0 <- load.image("https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/1200px-International_Pok%C3%A9mon_logo.svg.png")

plot(im0, axes = FALSE)

reduce <- max(mean(dim(im0)[1:2] / 200), 1)
ncolors <- 4


im <- resize(im0, width(im0) / reduce,
             height(im0) / reduce, 
             interpolation_type = 1)
plot(im)
{
  # im <- RGBtoYCbCr(im)
  dim_im <- dim(im)
  dim(im) <- c(prod(dim_im[1:2]), dim_im[4])
  kmeans <- flexclust::kcca(im[], ncolors)
  # kmedians <- Gmedian::kGmedian(im[], ncenters = 5)
  
  im[] <- kmeans@centers[kmeans@cluster, ]
  # im[] <- kmedians$centers[kmedians$cluster, ]
  dim(im) <- dim_im
  # im <- YCbCrtoRGB(im)
  plot(im)
}
# Lab/HSI/HSL/HSV donne des couleurs bizarres

reduce2 <- 3.5
im2 <- resize(im, width(im) / reduce2,
              height(im) / reduce2, 
              interpolation_type = 1)

plot(im2)
dim_im2 <- dim(im2)
dim(im2) <- c(prod(dim_im2[1:2]), dim_im2[4])
im2[] <- kmeans@centers[predict(kmeans, im2[]), ]
dim(im2) <- dim_im2

im2_df <- cbind(
  expand.grid(y = rev(seq_len(ncol(im2))), x = seq_len(nrow(im2))),
      expand.grid(color = as.raster(im2), stringsAsFactors = FALSE)) 

ggplot(im2_df) +
  geom_tile(aes(x, y, fill = I(color))) +
  coord_equal() +
  theme_void() +
  geom_vline(xintercept = c(0.5, seq_len(nrow(im2)) + 0.5)) +
  geom_hline(yintercept = c(0.5, seq_len(ncol(im2)) + 0.5))



