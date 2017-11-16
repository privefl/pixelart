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

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Make Pixel Art Models"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("url", label = "URL of picture:", "https://goo.gl/nRQi5n"),
      
      sliderInput("resize1", label = "Width of initial downsize:",
                   min = 50, max = 300, value = 100, step = 10),
      
      sliderInput("ncolors",
                  "Number of colors:",
                  min = 2,
                  max = 10,
                  value = 7),
      
      sliderInput("resize2", label = "Width of final downsize:",
                   min = 10, max = 80, value = 20, step = 2),
      
      textInput("colorNA", label = "Color for missing:", "#ffffff"),
      
      fluidRow(
        column(12,
          h4("Code to reproduce:"),
          verbatimTextOutput("code")
        )
      )
    ),
    mainPanel(
      fluidRow(
        # Show the initial image
        column(6, 
               h2("Initial image"),
               h3("(reduced for processing)"),
               plotOutput("im1_plot")
        ),
        
        column(6, h2("Pixel Art"), plotOutput("im2_plot"))
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  im00 <- reactive({
    magick::image_read(input$url)
  }) %>% 
    debounce(1000)
  
  im0 <- reactive({
    color_impute(im00(), input$colorNA)
  }) %>% 
    debounce(1000)
  
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
      "  colorNA = '{input$colorNA}'",
      ")",
      .sep = "\n"
    )
  }) 
}

# Run the application 
shinyApp(ui = ui, server = server)
