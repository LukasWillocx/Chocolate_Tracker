# Three functions to scrape the pricing on callebaut callets @ three different vendors
# The designated HTML node css selectors are acquired by inspecting the desired element in a browser
# Price variable requires additional formatting, (getting rid of units and making them numeric)

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

plot_prices <- function(file_path){
  choc_price_df<-read.csv2(file_path)
  choc_price_df$Date<-as.Date(choc_price_df$Date)
  
  ggplot(choc_price_df,aes(x=Date,y=Price,color=Source,Group=Callebaut))+
    geom_point()+
    geom_line()+
    scale_y_continuous(limits = c(0, NA))+
    facet_wrap(.~Callebaut,ncol=1)+
    theme(
      plot.background = element_rect(fill = "transparent", colour = NA),
      panel.background = element_rect(fill = "transparent", colour = NA),
      legend.background = element_rect(fill = "transparent", colour = NA),
      legend.text =  element_text(color = "#7aa6a1"),
      legend.title = element_text(color = "#7aa6a1"),
      strip.background = element_rect(fill = "#ddC7C4"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "#BEBEBE",size=0.5,linetype='dotted'),
      axis.title = element_text(color = "#7aa6a1"),
      axis.ticks = element_line(color = "#7aa6a1"),
      axis.text = element_text(color = "#7aa6a1"))+
    labs(y='Pricing (per kg)')
}


