library(tidyverse)
library(openxlsx)
library(xlsx)
library(readxl)
library(lubridate)


trackingSheet=readxl::read_excel("~/Stability/getClones/Stability.Trackers.Consolidated.2022-04-25.xlsx",
                               sheet = "Sheet 1",
                               col_names = TRUE,
                               col_types = "text"
) 


Summary = trackingSheet %>% 
  group_by(Wave, Team, Year, ) %>% 
  summarize(
    Total.Reagents = n()
  )

fileName =  paste("~/Stability/getClones/Stability.Trackers.Summary.", Sys.Date(), ".xlsx", sep = "")
openxlsx::write.xlsx(Summary, file = fileName)

trackingSheet=readxl::read_excel("~/Stability/getClones/Stability.Trackers.Consolidated.2022-04-25.xlsx",
                                 sheet = "Sheet 1",
                                 col_names = TRUE,
                                 col_types = "text"
)

resultsTrackingSheet=readxl::read_excel("~/Stability/getClones/Stability.Trackers.Consolidated.2022-04-25.xlsx",
                                        sheet = "Sheet 1",
                                        col_names = TRUE,
                                        col_types = "text"
) 