library(rvest)
library(dplyr)
library(scrapeR)

# Example function to scrape prices from a website
scrape_prices <- function(url) {
  page <- read_html(url)
  price <- page %>% html_node("div.grouped-product-table__product:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(2)") %>% html_text()
  price <- extract_number(price)
  product_name <- page %>% html_node('h1.page-title') %>% html_text()
  date <- Sys.Date()
  
  data.frame(
    Product = product_name,
    Price = price,
    Date = date,
    Source = "De Notenshop"  # Replace with actual shop name
  )
}


extract_number <- function(text) {
  numbers <- gsub("[^,]?[0-9]+?[,][0-9]+", "", text)
  if (length(numbers) > 0){
    first_dec_num <- gsub("([^,]*)", "\\1", numbers)
    return(as.numeric(gsub("[^,]?", "", first_dec_num)))
  }
  else {
    return(NA)
  }
 }



# Example URLs (replace with actual URLs)
urls <- c("http://shop1.com/product", "http://shop2.com/product", "http://shop3.com/product")
price_data <- bind_rows(lapply(urls, scrape_prices))

write.csv(price_data, "chocolate_prices.csv", row.names = FALSE)