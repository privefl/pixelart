#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(magick)
library(pixelart)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Resize an image"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      fileInput("upload", "Upload new image", accept = c('image/png', 'image/jpeg')),
      
      sliderInput("rotate", "Rotation (degrees)", value = 0, 
                  min = 0, max = 360, step = 90),
      
      sliderInput("left",   "Crop left (pixels)",   value = 0, min = 0, max = 0),
      sliderInput("top",    "Crop top (pixels)",    value = 0, min = 0, max = 0),
      sliderInput("right",  "Crop right (pixels)",  value = 0, min = 0, max = 0),
      sliderInput("bottom", "Crop bottom (pixels)", value = 0, min = 0, max = 0),
      
      downloadButton("dl", "Save new image"),
      
      width = 3
    ),
    mainPanel(
      h4(textOutput("size")),
      imageOutput("img"),
      width = 9
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # Temporary file to write image into
  tmp_jpg <- tempfile(fileext = ".jpg")
  
  # When uploading new image
  image <- reactive({
    if (is.null(input$upload)) {
      image_read("https://goo.gl/VASMjF")
    } else {
      image_convert(image_read(input$upload$datapath), "jpeg")
    }
  })
  
  image_rotated <- reactive({ 
    req(input$rotate)
    image_rotate(image(), input$rotate)
  })
  
  image_cropped <- reactive({
    req(input$left, input$right, input$bottom, input$top)
    crop(
      image_rotated(),
      left = input$left,
      right = input$right,
      bottom = input$bottom,
      top = input$top
    )
  }) %>%
    debounce(100)
  
  image_with_border <- reactive({
    image_border(image_cropped(), "red", "5x5")
  })
  
  ## Sliders as a function of the image
  observeEvent(input$upload, {
    updateSliderInput(session, "rotate", value = 0, min = 0, max = 360, step = 90)
  }, priority = 1)
  observeEvent(list(input$rotate, input$upload), {
    infos <- image_info(image_rotate(image(), input$rotate))
    w <- infos$width
    h <- infos$height
    updateSliderInput(session, "left",   value = 0, min = 0, max = w / 2,
                      step = max(1, round(w / 100)))
    updateSliderInput(session, "right",  value = 0, min = 0, max = w / 2,
                      step = max(1, round(w / 100)))
    updateSliderInput(session, "top",    value = 0, min = 0, max = h / 2,
                      step = max(1, round(h / 100)))
    updateSliderInput(session, "bottom", value = 0, min = 0, max = h / 2,
                      step = max(1, round(h / 100)))
  }, priority = 100)
  
  output$size <- renderText({
    infos <- image_info(image_cropped())
    glue::glue("Current size: {infos$width} x {infos$height}")
  })
  
  output$img <- renderImage({
    
    image_write(image_with_border(), tmp_jpg, format = "jpg")
    
    # Return a list
    list(src = tmp_jpg, contentType = "image/jpeg")
  })
  
  output$dl <- downloadHandler(
    filename = "",
    content = function(file) {
      image_write(image_cropped(), file, format = "jpg")
    },
    contentType = "image/jpeg"
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)
