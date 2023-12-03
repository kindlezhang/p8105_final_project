library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel(h2("CPI distribution globally")),
  sidebarLayout(
    
    sidebarPanel(
      img(
        src = "rstudio.png",
        height = 40,
        width = 120
      ),
      br(),
      h4(strong("explanation")),
      helpText(
        div(
        "say whatever you want",
        style = "color:blue"
      ), 
        "whatever you want"),
      selectInput("var", 
                  label = h4(strong("Choose a variable to display")),
                  choices = c("CPI", 
                              "GDP",
                              "something else", 
                              "something else2"),
                  selected = "CPI"),
      sliderInput("slider", 
                  h4(strong("year")),
                  min = 1980, max = 2023, value = 1980)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot")),
        tabPanel("Summary", verbatimTextOutput("selected_variable")),
        tabPanel("Table", tableOutput("table"))
      ),
      textOutput("selected_variable"),
      plotOutput("plot")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  dataInput <- reactive({
    
  
  })
  
  output$selected_variable<- renderText({
      paste("chosen variable", input$var)
    })

  # output$selected_range<- renderText({
  #   paste("You have chosen a range that goes from", input$range[1], "to" , input$range[2])
  # })
  # 
  # output$map<- renderPlot({
  #   data <- switch(input$var, 
  #                  "Percent White" = counties$white,
  #                  "Percent Black" = counties$black,
  #                  "Percent Hispanic" = counties$hispanic,
  #                  "Percent Asian" = counties$asian)
  #   
  #   color <- switch(input$var, 
  #                   "Percent White" = "darkgreen",
  #                   "Percent Black" = "black",
  #                   "Percent Hispanic" = "darkorange",
  #                   "Percent Asian" = "darkviolet")
  #   
  #   legend <- switch(input$var, 
  #                    "Percent White" = "% White",
  #                    "Percent Black" = "% Black",
  #                    "Percent Hispanic" = "% Hispanic",
  #                    "Percent Asian" = "% Asian")
  #   
  #   percent_map(var = data, legend.title = legend, color = color, min = input$range[1], max = input$range[2])
  #   
}

# Run the app ----
shinyApp(ui = ui, server = server)
