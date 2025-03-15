library(rvest)
library(dplyr)
library(scrapeR)

# Example function to scrape prices from a website
scrape_prices <- function(url) {
  page <- read_html(url)
  product_name <- page %>% html_node("css_selector_for_product_name") %>% html_text()
  price <- page %>% html_node('product-price-6761 > span:nth-child(1)') %>% html_text()
  date <- Sys.Date()
  
  data.frame(
    Product = product_name,
    Price = price,
    Date = date,
    Source = "ShopName"  # Replace with actual shop name
  )
}

# Example URLs (replace with actual URLs)
urls <- c("http://shop1.com/product", "http://shop2.com/product", "http://shop3.com/product")
price_data <- bind_rows(lapply(urls, scrape_prices))

write.csv(price_data, "chocolate_prices.csv", row.names = FALSE)
