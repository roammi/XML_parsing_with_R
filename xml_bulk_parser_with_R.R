library(xml2)
library(tidyverse)
library(XML)
library("methods")
library(RCurl)
library(bitops)

# 0. Bulk load xmls ----
all_files_xml <- list.files("C:/address/",  # replace with address
                            recursive = FALSE, full.names = TRUE, 
                            include.dirs = FALSE, pattern = "*.xml")

# 1. Function to parse ----
# needs to be modified according to each XML case, XML files have different schemas

xfiles <- function(x){
  data <- xmlParse(x) # error aqui fue
  rootnode <- xmlRoot(data)
  # Note: the root node should be modified based on your requirements 
  table <- tibble(column=character(),value=character())
  z<- xmlSize(rootnode)-5
    for (i in 0:z) {
    a <- xmlSApply(rootnode[[5+i]][[1]], xmlValue)
    b <- xmlSApply(rootnode[[5+i]][[4]], xmlValue)
    table <- table %>% add_row(column=a[[1]], value = b[[1]] )
  }  
  return(table)
}

# 2. apply function to all XML files ----
library(purrr)
df <- map_df(all_files_xml,xfiles)

# 3. export to xlsx ----
getwd()
setwd("C:/address")
write_excel_csv2(x = df, path = "file.xls") 
