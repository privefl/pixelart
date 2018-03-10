color_mat_lab <- grDevices::convertColor(color_mat[, 1:3], 
                                         from = "sRGB", to = "Lab")


km <- flexclust::kcca(color_mat_lab, 5)
groups <- flexclust::predict(km, color_mat_lab)

centers <- sapply(unique(groups), function(g) {
  col <- round(colMeans(color_mat[groups == g, 1:3]))
})
plot(seq_len(ncol(centers)), col = apply(centers, 2, function(col) {
  paste(c("#", as.raw(col)), collapse = "")
}), pch = 16, cex = 3)


km <- pixelart::kmeans_colors(im0, 3)
plot(1:3, col = unique(as.vector(pixelart::colors_kmeans(im0, km))), pch = 16, cex = 3)
