library(shiny)
library(shinythemes)
library(shinycssloaders)
library(rvest)
library(dplyr)

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
      h4("Navigation"),
      hr(),
      p("Additional inputs, context, etc.")
    ),
    
    mainPanel(
      width = 9,
      column(12, div(class = "custom-panel",
                                 
                     )),
        ),
      )
)



server <- function(input, output) {
  source('functions.R')
  
  urls_shopcallebaut <- list(c('https://shop.callebaut.com/products/recipe-n-823?variant=49363128287567','823'),
                             c('https://shop.callebaut.com/products/recipe-n-811?variant=42586035093643','811'),
                             c('https://shop.callebaut.com/products/finest-belgian-white-chocolate-recipe-n-w2-white-callets?variant=49388530073935','W2'))
  
  urls_notenshop <- list(c("https://www.denotenshop.be/callebaut-chocolade-druppels-melk.html", '823'),
                         c("https://www.denotenshop.be/callebaut-chocolade-druppels-puur-54.html", '811'),
                         c("https://www.denotenshop.be/chocolade-druppels-wit.html",'W2'))
  
  urls_bol <- list(c('https://www.bol.com/be/nl/p/callebaut-chocolade-callets-melk-1-kg/9300000004321394/?s2a=&bltgh=qfA5Ai3k6CJ2VcjgqiRO-Q.2_37_38.39.FeatureOption#productTitle','823'),
                   c('https://www.bol.com/be/nl/p/callebaut-chocolade-callets-puur-1-kg/9300000001107428/?s2a=&bltgh=qfA5Ai3k6CJ2VcjgqiRO-Q.2_37_38.39.FeatureOption#productTitle','811'),
                   c('https://www.bol.com/be/nl/p/callebaut-chocolade-callets-wit-1-kg/9300000004079481/?s2a=&bltgh=pHW0zcU8aPzmpmLfQJZBoQ.2_43_44.45.FeatureOption#productTitle','W2'))
  
  choc_price_df<-read.csv2('chocolate_prices.csv')
  
  for (i in urls_notenshop){
    price_data<-scrape_prices_denotenshop(i[1],i[2])
    choc_price_df<-rbind(choc_price_df,price_data)
  }
  
  for (i in urls_shopcallebaut){
    price_data <- scrape_prices_shopcallebaut(i[1],i[2])
    choc_price_df<-rbind(choc_price_df,price_data)
  }
  
  for (i in urls_bol){
    price_data <- scrape_prices_bol(i[1],i[2])
    choc_price_df<-rbind(choc_price_df,price_data)
  }
  
  write.csv2(choc_price_df, "chocolate_prices.csv", row.names = FALSE)
}

shinyApp(ui = ui, server = server)