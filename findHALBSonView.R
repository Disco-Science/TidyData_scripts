library(tidyverse)
library(xlsx)
library(lubridate)
library(hablar)

sqlData <- readxl::read_excel("~/Stability/getClones/SQL_View_VWAutomation2022-05-04.xlsx",
                   col_names = TRUE,
                   col_types = "text",
                   sheet = 1) %>% 
    retype()


newDF <- sqlData %>% 
    mutate(QCMODELSYSTEM = as.character(QCMODELSYSTEM),
           SAMPLETYPE = as.character(SAMPLETYPE),
           BATCHCOMPLETEDDATE = ymd(openxlsx::convertToDate(BATCHCOMPLETEDDATE)
                                    )
           )

targets <- readxl::read_excel("~/Code/Projects/Stability/tidyDat/formatClones_NANIX.xlsx",
                      col_names = TRUE,
                      col_types = "text",
                      sheet = 1)


halbs = data.frame()

for (i in 1:length(targets$Format)) {
    
    for (j in 1:length(targets$Clone)) {
        
        test <- filter(newDF, FORMAT == targets$Format[i], SAPCLONENAME == targets$Clone[j])
        
        halbs = rbind(test, halbs)
    }
    
}


fileName = paste("C:/Users/10351517/Documents/Stability/getClones/HALBfor10x10", Sys.Date(), ".xlsx", sep="")

openxlsx::write.xlsx(halbs, file = fileName)

