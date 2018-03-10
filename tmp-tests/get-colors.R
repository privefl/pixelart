im0 <- magick::image_read('https://www.tutsps.com/images/Tuto_photoshop_Dessiner_un_Lapin_Cretin/Tuto_photoshop_Dessiner_un_Lapin_Cretin_27.JPG')
im0 <- magick::image_read("http://ekladata.com/iFTLlXa31o1oc0EbfSiK1iGaJaU.png")
im0 <- pixelart::downsize(im0, npixel_width = 200)


color_mat <- apply(im0[[1]], 1, as.integer)
color_mat2 <- apply(im0[[1]][1:3, , ], 2:3, function(x) {
  paste(c("#", x), collapse = "")
})

color_tab <- sort(table(color_mat2), decreasing = TRUE)
names(head(color_tab))

length(color_tab) / length(color_mat2)

plot(1:100, col = names(head(color_tab, n = 100)), pch = 16, cex = 3)
names(head(color_tab))

col_diff <- function(col1, col2) {
  r <- (col1[1] + col2[1]) / 2
  d2 <- (col2 - col1)^2
  sqrt(2 * d2[1] + 4 * d2[2] + 3 * d2[3] + r * (d2[1] - d2[3]) / 256)
}

print(N <- sum(color_tab > 5))
cols <- names(color_tab[])
cols2 <- grDevices::col2rgb(cols)
dist_mat <- matrix(0, N, N)
for (j in 1:N) {
  for (i in 1:N) {
    dist_mat[i, j] <- col_diff(cols2[, i], cols2[, j])
  }
}
dist_mat

par.save <- par(mfrow = c(2, 1))
plot(1:N, col = names(head(color_tab, n = N)), pch = 16, cex = 3)
# image(dist_mat)

d <- as.dist(dist_mat)
fit <- hclust(d)
plot(fit) # display dendogram
groups <- cutree(fit, k = 10) # cut tree into 5 clusters
groups[1:10]
dist_mat[1:10, 1:10]
# for (g in unique(groups)) {
#   cols_g <- cols[which(groups == g)]
#   plot(seq_along(cols_g), col = cols_g, pch = 16, cex = 3)
# }

centers <- sapply(unique(groups), function(g) {
  col <- round(rowMeans(cols2[, which(groups == g), drop = FALSE]))
  paste(c("#", as.raw(col)), collapse = "")
})
plot(seq_along(centers), col = centers, pch = 16, cex = 3)
