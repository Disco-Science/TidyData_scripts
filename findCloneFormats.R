library(tidyverse)
library(xlsx)
library(openxlsx)

stabilityTracker = readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY22 Stability Tracking Sheet.xlsx",
                                      sheet = "2022 Sample Details",
                                      skip = 1,
                                      col_names = TRUE,
                                      col_types = "text"
) 

cloneList = unique(stabilityTracker$Clone)
returnDF = stabilityTracker[1,]

for (i in cloneList) {
  
  totalReagents = filter(stabilityTracker, Clone == i) %>%
      select(Clone, Team) 
  
  countReagents = length(totalReagents$Clone)
  
  if (countReagents >= 5) {
    
    assign(i,
           filter(stabilityTracker, Clone == i) %>%
             mutate(`Date of Manufacture` = convertToDate(`Date of Manufacture`)
             )
    )
    
    returnDF =  rbind(returnDF, filter(stabilityTracker, Clone == i))
      
  }
  
  else {
    
    invisible()
    
  }
  
}

returnDF = returnDF %>% mutate(
  `Date of Manufacture` = convertToDate(`Date of Manufacture`),
  `Date Stability Started` = convertToDate(`Date Stability Started`),
  `Date Stability Ended(25C)` = convertToDate(`Date Stability Ended(25C)`)
)

fileName = paste("FileName", Sys.Date(), ".xlsx", sep="")

#Export selectedDF 
openxlsx::write.xlsx(returnDF, file = fileName)
