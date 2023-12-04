library(shiny)
library(sf)
library(dplyr)
library(leaflet)
library(tidyverse)
library(readxl)

source("function_1.R")

# Read this shape file with the sf library. 

world_spdf =
  st_read(
    dsn = "./data/world_shape_file/",
    layer = "TM_WORLD_BORDERS_SIMPL-0.3")

world_cor = 
  read_excel("./data/CPI_2015.xlsx", sheet = 1) |> 
  janitor::clean_names() |> 
  select(country_territory, cpi_2015_score) |> 
  rename("2015" = cpi_2015_score) |> 
  rename("NAME" = "country_territory") |> 
  left_join(world_spdf, by = "NAME") |> 
  st_as_sf()


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
        tabPanel("Plot", textOutput("selected_variable"), 
                 textOutput("selected_year"), 
                 leafletOutput("map")),
        tabPanel("Summary", verbatimTextOutput("text")),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

# Define server logic ----
server = function(input, output) {
  dataInput = reactive({
    c(input$var, as.character(input$slider))
  })
  
  output$selected_variable<- renderText({
      paste("chosen variable", dataInput()[1])
    })
  
  output$selected_year<- renderText({
    paste("chosen year", dataInput()[2])
  })
  
  output$map <- renderLeaflet({
    map_draw(data = world_cor, 
             year = dataInput()[2])
  })
   
  # output$map<- renderPlot({
  #   data <- switch(input$var, 
  #                  "Percent White" = counties$white,
  #                  "Percent Black" = counties$black,
  #                  "Percent Hispanic" = counties$hispanic,
  #                  "Percent Asian" = counties$asian)
  #   
  #   percent_map(var = data, legend.title = legend, color = color, min = input$range[1], max = input$range[2])
  #   })
}

# Run the app ----
shinyApp(ui = ui, server = server)
