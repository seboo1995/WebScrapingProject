library(jsonlite)
library(tidyverse)
library(data.table)
nasa_api_key <- read_file("NASA_API_KEY")
nasa_api_key <- gsub("[\r\n]", "", nasa_api_key)

bla <- "https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-09&end_date=2015-09-12&api_key=SajYkcAscUCLe1aKfyVzVERuqraOgPO25szfKnvE"

temp <- fromJSON(bla)




kk <- rbindlist(c(temp$near_earth_objects$`2015-09-11`,temp$links))



get_asteriod_data_from_nasa <- function(start_date,end_date){

url <- paste0("https://api.nasa.gov/neo/rest/v1/feed?start_date=",start_date,"&end_date=",end_date,"&api_key=",nasa_api_key)
print(url)
data <- fromJSON(url)
temp <- rbindlist(data)
View(temp)



#creating empty dataframe to store my data
#df <- data.table()
# the object data has multiple objects nested, but the data is in the data frame: near_earth_objects
# I know that lapply could be used here, but the data is not big, so it does not make a difference
# also there is a list of objects inside the near_earth_objects which I want to make the table normalized, so the elements of the list that is nested will be now shown in different columns



#for(x in data$near_earth_objects){
#  df_temp <- as.data.table(x)
#  #creating column that I will append to the df_temp object
#  col_close_approcah <- as.data.table(flatten(x$close_approach_data[1]))
  #cbind them together
#  df_temp <- cbind(df_temp,col_close_approcah)
  
  
  
#bind it to the final table.  
#df <- rbind(df,df_temp)
  

View(df)

names(df)

#dropping the column with the list and the miles and feet, because there is already data with meters
df_new <- df %>%
  select(-close_approach_data)%>%
  select(-contains("miles")) %>%
  select(-contains("feet")) %>%
  select(-close_approach_date)%>%
  select(id,close_approach_date_full,
         name,
         miss_distance.kilometers,
         relative_velocity.kilometers_per_hour,
         estimated_diameter.meters.estimated_diameter_min,
         is_potentially_hazardous_asteroid,
         everything())
ncol(df_new)
View(df_new)

#I thought if the asteriod is fast and big it will be more dangerous for Earth, but it turns out its not
ggplot(df_new,aes(x = log(as.numeric(estimated_diameter.meters.estimated_diameter_max)),y=log(as.numeric(relative_velocity.kilometers_per_hour)),color=is_potentially_hazardous_asteroid))+
  geom_point()


#some futher cleaning is required



print(df_new)
#saveRDS(df_new,file = "asteriod")



}
get_asteriod_data_from_nasa(start_date = "2015-09-09",end_date="2015-09-12")


