library(tidyverse) #Pipes and table functions
library(xlsx) #Not sure?
library(openxlsx) #Write out Excel files
library(readxl) #Read in Excel files
library(lubridate)#Change dates to date.objects
library(hablar)

# #Grab Andrew's readout
FERT <- readxl::read_excel("/Users/10351517/Documents/Stability/getClones/FERT AND HALB BATCH PULL 04MAY2022.xlsx",
                            col_names = TRUE,
                            col_types = "text",
                          sheet = 2) 

FERT_summary_table = FERT %>% 
    group_by(`FERT STATUS`) %>% 
    summarise(total.batch = length(unique(`BATCH REQUESTED`)),
              total.HALBS = length(unique(`HALB`)),
              total.FERTs = length(unique(`FERT`))
    )
                                
TSL_table <-  readxl::read_excel("/Users/10351517/Documents/Stability/getClones/completedStudyDB 2022-04-19 _edit.xlsx",
                                 col_names = TRUE,
                                 col_types = "text",
                                 sheet = 1) %>% 
    retype()

TSL_table_edit <- TSL_table %>% 
    mutate("DOM" = openxlsx::convertToDate(DOM),
           "Stability start" = openxlsx::convertToDate(TSL_table$`Stability start`),
           "Stability end" = openxlsx::convertToDate(TSL_table$`Stability end`),
           "Date Testing" = openxlsx::convertToDate(TSL_table$'Date Testing'),
           "DOM_testing" = TSL_table$`Date Testing` - TSL_table$DOM,
           "Start_end_Stability" = TSL_table$`Date Testing` - TSL_table$`Stability start`,
           "End.Incubation_Testing" = TSL_table$`Date Testing` - TSL_table$`Stability end`
           )

TSL_summary <- TSL_table_edit %>% 
    group_by(Year) %>% 
    summarise(Total.Batches = length(unique(BATCHNO))
              )

