library(tidyverse)

demo<-read.csv(file='~/Desktop/NYCDSA/R/Shiny_Project/App/demo.csv',stringsAsFactors = FALSE)
demo = demo %>%
  filter(Year=='2019') %>%
  group_by(DBN)