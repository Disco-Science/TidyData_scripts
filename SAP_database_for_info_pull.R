library(tidyverse)
library(readxl)
library(xlsx)
library(openxlsx)
library(ggplot2)

VWAutomationDB = read.csv("~/Code/Projects/Databases/SQL_DB/Data_tables/VWAutomationData_HPP1_04202022.csv") %>% 
  mutate(BATCHNO = as.character(BATCHNO))

listOfBatchIDs = read_excel("/Users/10351517/Documents/batchID.Test.04182022.xlsx",
                  col_names = TRUE,
                  col_types = "text") %>% 
  unique()



completed_studies = read_excel("/Users/10351517/Documents/Stability/Analysis/Summaries/Manual consolidation/Summary_manual_04182022.xlsx",
                             col_names = TRUE,
                             col_types = "text")

completed_studies = completed_studies %>% 
  mutate('DOM' = openxlsx::convertToDate(completed_studies$DOM),
         'Stability start' = openxlsx::convertToDate(completed_studies$`Stability start`),
         'Stability end' = openxlsx::convertToDate(completed_studies$`Stability end`),
         'Date Testing' = openxlsx::convertToDate(completed_studies$`Date Testing`)
         )


vector01 = completed_studies %>% 
  mutate('TAT_DOM_Testing' = (completed_studies$`Date Testing` - completed_studies$DOM)
  )

vector01 = vector01$TAT_DOM_Testing

completed_studies = completed_studies %>% 
  mutate('TAT_DOM_Testing' = (completed_studies$`Date Testing` - completed_studies$DOM)
         )

col_names_SAP = c("BATCHNO", "TARGETSPECIES", "HOSTSPECIES", "HVCHAIN", "LTCHAIN", "MATERIALNUMBER", "BATCHCOMPLETEDDATE")

returnDB = VWAutomationDB[VWAutomationDB$BATCHNO %in% listOfBatchIDs$BATCHNO,] %>% 
  select(all_of(col_names_SAP)) # %>%
  # bind_rows(listOfBatchIDs[!(listOfBatchIDs$BATCHNO %in% VWAutomationDB$BATCHNO),])

returnDB = merge(returnDB, completed_studies, by.x = "BATCHNO", by.y = "Batch ID", all.y = TRUE)

fileName = paste("~/Stability/getClones/completedStudyDB", Sys.Date(), "test.xlsx")

# graph = ggplot(completed_studies, aes(x = TAT_DOM_Testing))
# 
# graph + geom_histogram()
# 
# openxlsx::write.xlsx(returnDB, file = fileName)

# corr = ggplot(completed_studies, 
#               aes(x = as.numeric(TAT_DOM_Testing), 
#                   y = as.numeric(completed_studies$`Projected Shelf Life (days)`)
#                   ), na.omit()
#               )
# 
# corr + geom_point() 

#Grab clone unique clones
listOfClones = read_excel("/Users/10351517/Documents/Stability/getClones/completedStudyDB 2022-04-19 _edit.xlsx",
                          col_names=TRUE,
                          col_types = "text",
) %>% 
  select("Clone") %>% 
  unique()

for(clone in listOfClones$Clone) {
  
  test = filter(VWAutomationDB, SAPCLONENAME == clone)
  
  if(is.na(test$SAPCLONENAME[1])) {
    text = paste(clone, "is here", sep = " ")
  }
  else {
    text = paste(clone, "is NOT here", sep = " ")
  }
  
  print(text)
  
}
