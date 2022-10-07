library(netstat)
library(RSelenium)
library(tidyverse)
library(rvest)
library(data.table)
library(janitor)


# Necessary background stuffs
rsDriver_obj <- rsDriver(browser = "chrome",
                         chromever = "106.0.5249.61",
                         verbose = FALSE,
                         port = free_port())
## I have used free_port function from netstat package to use a free port.


remDr <- rsDriver_obj$client

#remDr$open()
remDr$navigate("https://ehandicap.net/?SysCID=DGCLTD&ACTION=Go")
Sys.sleep(1)



# Following code downloads the dataset which has the overall
#information but not the detailed info for each player.

## The website by default shows only 15 entries but it is possible to show all the entries. It makes all the entries  apparent.

webElem <- remDr$findElement(using = 'xpath', '//select[@name = "example_length"]/option[@value = "-1"]')
webElem$clickElement()

# Saving the webpage

#data_table_meta <- remDr$findElement(using = 'id', 'example')
data_table_meta <- remDr$findElement(using = 'xpath', '//*[@id="example"]/tbody')



data_table_meta_html <- data_table_meta$getPageSource()
#page <- read_html(data_table_meta_html |> unlist())
css_selector <- '#example > tbody'
df_meta <- read_html(data_table_meta_html |> unlist()) |> html_element(css = css_selector) |> html_table()
df_meta <- df_meta |> rename(
  member=X1,
  ID=X2,
  home_course=X3,
  home_tee=X4,
  index=X5,
  handicap=X6)

df_meta$url <- paste0("https://ehandicap.net/cgi-bin/hcapstat.exe?CID=dgcltd&MID=", df_meta$ID)


write.csv(df_meta, "./df_meta.csv")

#to close the server
remDr$close()


## extracting individual data

# Necessary background stuffs
rsDriver_indiv <- rsDriver(browser = "chrome",
                           chromever = "106.0.5249.61",
                           verbose = FALSE,
                           port = free_port())


#all_data <- list()

remDr_indiv <- rsDriver_indiv$client

#remDr_indiv$open()

url_i <- df_meta$url[1]
#url_i <- paste0("https://ehandicap.net/cgi-bin/hcapstat.exe?CID=dgcltd&MID=B361")
#remDr_indiv$navigate(url_i)
remDr_indiv$navigate(url_i)

Sys.sleep(1)

#close server
#remDr_indiv$close()
# saving the webpage

data_table_html_i <- remDr_indiv$getPageSource()

css_selector <- 'body > center > center > center > tt > table > tbody'
df_i <- read_html(data_table_html_i |> unlist()) |> html_element(css = css_selector) |> html_table()
df_i$ID <- "B361"
all_data <- rbindlist(list(all_data, df_i))

write.csv(df_i, "df_i.csv")




# following code recursively downloads the info from each page.

setwd("C:/Users/admin/Downloads/BE_r_session2/df")
#for (ID in df_meta$ID[233:1000]){
for (ID in df_meta$ID){
  # Necessary background stuffs
  url <- paste0("https://ehandicap.net/cgi-bin/hcapstat.exe?CID=dgcltd&MID=",ID)
  
  rsDriver_indiv <- rsDriver(browser = "chrome",
                             chromever = "106.0.5249.61",
                             verbose = FALSE,
                             port = free_port())
  
  remDr_indiv <- rsDriver_indiv$client
  remDr_indiv$navigate(url)
  Sys.sleep(sample.int(1, 1))
  
  data_table_html_i <- remDr_indiv$getPageSource()
  
  css_selector <- 'body > center > center > center > tt > table > tbody'
  df_i <- read_html(data_table_html_i |> unlist()) |> html_element(css = css_selector) |> html_table() |> clean_names()
  df_i$ID <- paste0(ID)
  
  write.csv(df_i, paste0("df_", ID, ".csv"))
  remDr_indiv$close()
}



### merge all the datasets


filenames <- list.files(path="C:/Users/admin/Downloads/BE_r_session2/df", full.names=TRUE)

#read the files in as plaintext
csv_list <- lapply(filenames , readLines)

#remove the header from all but the first file
csv_list[-1] <- sapply(csv_list[-1], "[", 2)

#unlist to create a character vector
csv_list <- unlist(csv_list)

#write the csv as one single file
writeLines(text=csv_list,
           con="all_my_csvs_combined.csv")

#read the csv as one single file
all_my_csvs_combined <- read.csv("all_my_csvs_combined.csv")







