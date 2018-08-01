#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(pixelart)

URL_404 <- "https://st.depositphotos.com/1561359/4961/v/950/depositphotos_49616865-stock-illustration-3d-illustration-of-error-404.jpg"

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Make Pixel Art Models"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
      textInput("url", label = "URL of picture:", "https://goo.gl/nRQi5n"),
      
      textInput("color_bg", label = "Color for background:", "white"),
      
      sliderInput("left",   "Crop left (pixels)",   value = 0, min = 0, max = 0),
      sliderInput("top",    "Crop top (pixels)",    value = 0, min = 0, max = 0),
      sliderInput("right",  "Crop right (pixels)",  value = 0, min = 0, max = 0),
      sliderInput("bottom", "Crop bottom (pixels)", value = 0, min = 0, max = 0),
      
      sliderInput("rotate", "Rotation (degrees)", value = 0, 
                  min = 0, max = 360, step = 90),
      
      sliderInput("saturation", label = "Saturation:",
                  min = 10, max = 300, value = 100, step = 10)
    ),
    mainPanel(width = 9,
      fluidRow(
        column(6, 
               sliderInput("resize1", label = "Width of initial downsize:",
                           min = 50, max = 300, value = 100, step = 10),
               
               h2("Initial image"), h3("(reduced for processing)"),
               plotOutput("im1_plot"),
               
               h4("Code to reproduce:"), verbatimTextOutput("code")
        ),
        column(6, 
               sliderInput("ncolors", "Number of colors:",
                           min = 2, max = 10, value = 7),
               sliderInput("resize2", label = "Width of final downsize:",
                              min = 10, max = 80, value = 20, step = 2),
               
               h2("Pixel Art"), plotOutput("im2_plot"))
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  im00 <- reactive({
    tryCatch(
      magick::image_background(
        magick::image_read(input$url), 
        input$color_bg
      ), 
      error = function(e) magick::image_read(URL_404)
    )
  }) %>% 
    debounce(1000)
  
  ## Sliders as a function of the image
  observeEvent(im00(), {
    d <- dim(im00()[[1]])
    w <- d[2]
    h <- d[3]
    updateSliderInput(session, "left", value = 0, min = 0, max = w / 2,
                      step = max(1, round(w / 50)))
    updateSliderInput(session, "right", value = 0, min = 0, max = w / 2,
                      step = max(1, round(w / 50)))
    updateSliderInput(session, "top", value = 0, min = 0, max = h / 2,
                      step = max(1, round(h / 50)))
    updateSliderInput(session, "bottom", value = 0, min = 0, max = h / 2,
                      step = max(1, round(h / 50)))
  })
  
  im0 <- reactive({
    im00() %>%
      crop(
        left = input$left,
        right = input$right,
        bottom = input$bottom,
        top = input$top
      ) %>%
      magick::image_rotate(input$rotate) %>%
      magick::image_modulate(saturation = input$saturation)
  })
  
  im1 <- reactive({
    downsize(im0(), input$resize1)
  }) %>% 
    debounce(1000)
  
  im2 <- reactive({
    downsize(im0(), input$resize2)
  })
  
  # output$im0_plot <- renderPlot({
  #   plot(im0())
  # })
  
  output$im1_plot <- renderPlot({
    plot(im1())
  })
  
  kmeans <- reactive({
    kmeans_colors(im1(), input$ncolors)
  })
  
  output$im2_plot <- renderPlot({
    plot_color_matrix(colors_kmeans(im2(), kmeans()))
  })
  
  output$code <- renderText({
    glue::glue(
      "pixelart::pipeline(",
      "  url = '{input$url}',", 
      "  resize1 = {input$resize1},",
      "  resize2 = {input$resize2},",
      "  ncolors = {input$ncolors},",
      "  color_bg = '{input$color_bg}',",
      "  saturation = {input$saturation},",
      "  degrees = {input$rotate},",
      "  left = {input$left},",
      "  top = {input$top},",
      "  right = {input$right},",
      "  bottom = {input$bottom}",
      ")",
      .sep = "\n"
    )
  }) 
}

# Run the application 
shinyApp(ui = ui, server = server)
