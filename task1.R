
#importing rvest
library(rvest)

#This is a function that gets news titles and dates when the articles were published from BBC.com



#my_function takes two arguments of key_word and number of pages
get_pages <- function(key_word,num_of_pages){
#trimming function
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

first_part_url <- "https://www.bbc.co.uk/search/more?page="
#i need to add the plus sign in the url instead of spaces
search_term <- gsub(" ","+",key_word)

second_part_url <- paste0("&q=",search_term,"&filter=news&suggid")
#empty vector of titles
titles_v <- vector(mode = "character")
#empty vector for dates
dates_v <- vector(mode="character")


for(i in seq(1:num_of_pages)){
#forming url
fin_url <- paste0(first_part_url,i,second_part_url)
#getting the page
page <- read_html(fin_url)
#getting the titles from the page
titles <- page %>%
  html_nodes("a") %>%
  html_text() %>%
  trim()
#appending the titles in the vector
titles_v <- append(titles_v,titles)
#getting the dates from the page
date <- page %>%
  html_nodes(".top .display-date") %>%
  html_text()%>%
  trim()
#appending the dates
dates_v <- append(dates_v,date)

}
#I always had problems when I got empty elements, so I am filtering them out
column_titles <- titles_v[!titles_v==""]
#creating empty data frame
df <- data.frame()
#cbinding titles and dates
df <- cbind(column_titles,dates_v)

View(df)
}


#testing the function
get_pages("climate change",2)
