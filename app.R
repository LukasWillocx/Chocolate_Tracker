library(shiny)
library(shinythemes)
library(shinycssloaders)
library(rvest)
library(dplyr)
library(plotly)
library(ggplot2)
library(lubridate)

ui <- fluidPage(
  includeCSS("app_styles.css"),
  tags$script(HTML("
    function toggleTheme() {
      const body = document.body;
      body.dataset.theme = body.dataset.theme === 'dark' ? 'light' : 'dark';
    }
  ")),
  
  titlePanel(
    div("Callebaut callet pricing tracker", 
        style = "display: flex; justify-content: space-between; align-items: center;",
        tags$button(
          id = "themeToggle",
          onclick = "toggleTheme()",
          "🌓",
          class = "theme-toggle-btn"
        )
    ), 
    windowTitle = "Chocolate Tracker"
  ),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      tags$div(style = "text-align: center",h4("Information")),
      hr(),
      p("In a world where cocoa products and particularly chocolate sprinkles are getting ridiculously expensive, I've come to the conclusion that buying genuine
         callebaut callets might prove to be more economically viable. The three main chocolate categories of white, milk and dark are being considered."),
      hr(),
      tags$div(style = "text-align: center",h5('Chocolate callets')),
      hr(),
      tags$div(
        class = "image-text-container",
        tags$img(src = '811_callets.png', 
                 class = 'image-container'),
      p('N° 811 - Dark chocolate, consisting of 54.5% cocoa products and a fat content of 36.6%.')
      ),
      hr(),
      tags$div(
        class = "image-text-container",
        p('N° 823 - Milk chocolate, consisting of 33.6% cocoa products and a fat content of 36.2%.'),
        tags$img(src = '823_callets.png', 
                 class = 'image-container2'),
      ),
      hr(),
      tags$div(
        class = "image-text-container",
        tags$img(src = 'w2_callets.png', 
                 class = 'image-container'),
        p('N° W2 - White chocolate, consisting of 28% cocoa products and a fat content of 35.8%.')
      ),
      hr(),
      tags$div(style = "text-align: center",h5('Webshops / Online Vendors')),
      hr(),
      tags$div(style= 'image-align: center', 
               img(src='bol.png',height='65px'),
               img(src='Notenshop.webp',height='65px'),
               img(src='callebaut.png',height='65px')), 
    ),
    
    mainPanel(
      width = 9,
      column(12, div(class = "custom-panel",
                     plotlyOutput('pricing',height='900px'),            
                     )),
        ),
      )
)



server <- function(input, output) {
  
  # Acquire the required functions for plotting
  source('functions.R')
  
  # Rendering the interactive pricing plot
  output$pricing<-renderPlotly({
    plot_prices('chocolate_prices.csv')
  })
}

shinyApp(ui = ui, server = server)