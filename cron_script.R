# Script to be executed by cron daily 

# libraries

library(rvest)
library(dplyr)
library(lubridate)

# Set the working directory to the server directory here it'll be 
# setwd("srv/shiny-server/Chocolate_Tracker") 

##### Duplicate from the functions.R ###########################################
scrape_prices_denotenshop <- function(url,callebaut_id) {
  page <- read_html(url)
  price <- page %>% 
    html_node("div.grouped-product-table__product:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(2)") %>% 
    html_text2()
  price <- as.numeric(gsub(',','.',strsplit(price,'\\n')[[1]][1]))
  product_name <- page %>% html_node('h1.page-title') %>% html_text2()
  date <- today()
  
  data.frame(
    Product = product_name,
    Callebaut = callebaut_id,
    Price = price,
    Date = date,
    Source = "De Notenshop" 
  )
}

scrape_prices_shopcallebaut <- function(url,callebaut_id) {
  page <- read_html(url)
  price <- page %>% 
    html_node(".sale-price-regular--lg > div:nth-child(2) > span:nth-child(2)") %>% 
    html_text2()
  price <- gsub("[(€/)kg]", "", price)
  price <- as.numeric(gsub(',','.',price))
  product_name <- page %>% html_node('.product-info__title') %>% html_text2()
  date <- today()
  
  data.frame(
    Product = product_name,
    Callebaut = callebaut_id,
    Price = price,
    Date = date,
    Source = "shop Callebaut" 
  )
}

scrape_prices_bol <- function(url,callebaut_id) {
  page <- read_html(url)
  price <- page %>% 
    html_node(".promo-price") %>% 
    html_text2()
  price <- as.numeric(gsub(" ", ".", price))
  product_name <- page %>% html_node('.page-heading > span:nth-child(1)') %>% html_text2()
  date <- today()
  
  data.frame(
    Product = product_name,
    Callebaut = callebaut_id,
    Price = price,
    Date = date,
    Source = "bol" 
  )
}
################################################################################

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
choc_price_df$Date<-as.Date(choc_price_df$Date)

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