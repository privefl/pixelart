[![Travis build status](https://travis-ci.org/privefl/pixelart.svg?branch=master)](https://travis-ci.org/privefl/pixelart)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/privefl/pixelart?branch=master&svg=true)](https://ci.appveyor.com/project/privefl/pixelart)
[![CRAN status](https://www.r-pkg.org/badges/version/pixelart)](https://cran.r-project.org/package=pixelart)

# R package {pixelart}

R Package to make Pixel Art models. [[Blog post introducing the package]](https://privefl.github.io/blog/shiny-app-for-making-pixel-art-models/)

```r
# Installation
devtools::install_github("privefl/pixelart")

# Run Shiny app for pixel art models
pixelart::run_pixelart()

# Run Shiny app for resizing an image
pixelart::run_resize()
```

Webshot of Shiny App:

<center><img src="webshot.png" style="width:70%;"></center>

## Example

I present you Kong. **A.** Picture of Kong. **B.** Kong as a pixel art model, created with R package pixelart. **C. & D.** Two pixel art drawings of Kong, based on A & B.

<center><img src="kongs.png" style="width:70%;"></center>

## News

- August 1, 2018: add Shiny app for resizing images.

- March 10, 2018: run kmeans in the Lab space (instead of the RGB space)

- Nov 18, 2017: added some options for croping, rotating and saturating the image

## To improve

I think there is room for improving the pixel art models (e.g. better separation of colors). Maybe with [package imager](https://cran.r-project.org/web/packages/imager/vignettes/pixsets.html). Ideas are welcome.
