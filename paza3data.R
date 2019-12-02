library(rvest)
url_root <- "https://www.pazar3.mk/ads/skopje?Page="
df <- data.frame()
for(i in seq(1:20)){
vector_temp <- NULL
url <- paste0(url_root,i)
print(url)
page <- read_html(url)
title <- page %>%
  html_nodes(".result-content div:nth-of-type(4) a.Link_vis") %>%
  html_text()

links <- page %>%
  html_nodes(".result-content div:nth-of-type(4) a.Link_vis") %>%
  html_attr("href")
links <- paste0("https://www.pazar3.mk/",links)

prices <- page %>%
  html_nodes(".result-content div:nth-of-type(4) p") %>%
  html_text()

time <- page %>%
  html_nodes(".result-content div:nth-of-type(4) span.pull-right") %>%
  html_text()

extra_info <- page %>%
  html_nodes(".result-content div:nth-of-type(4) a.link-html5") %>%
  html_text()

df_temp <- t(rbind(title,links,prices,time,extra_info))

df <- rbind(df,df_temp)  
}

View(df)
