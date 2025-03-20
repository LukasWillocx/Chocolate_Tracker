## Application to scrape chocolate pricing from three webshops

* functions.R - contains all the functions. This includes the three individual web scrapers for the three different webshops (different css selectors required to grab the pricing data) as well as plot creation, which is displayed in the application's main panel.
* blank.csv & chocolate_prices.csv - the actual dataset that gets appended with pricing data daily and a formatted blank of that dataset, in case of a desired reset.
* app.R - the application code for rendering and serving the pricing, in a formatted manner.
* cron_script.R - the scraping script to be executed at a scheduled time, server-side, on the shiny server using CRON. Current execution is set at 4:00 GMT.
* www folder - contains images for the applications layout (logos and pictures). Shiny trees the www folder as root.

