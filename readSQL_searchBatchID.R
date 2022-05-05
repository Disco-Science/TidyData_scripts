#Author Nathan Choi; this script is written to pull matching rows (by BATCH.NO) from a MySQL (Oracle) datatable and return that as an xlsx file

library(tidyverse) #Pipes and table functions
library(openxlsx) #Write out Excel files
library(readxl) #Read in Excel files
library(lubridate)#Change dates to date.objects
library(RODBC) #SQL connection
library(hablar)

#Create ODBC connection to Oracle DB

conn <- RODBC::odbcConnect(dsn = "DSN", 
                            uid = "USER", 
                            pwd = "PW", 
                            believeNRows = FALSE) 

#SQL query as a string
grabTableNames = paste("SELECT table_name from all_tables order by table_name")
grabVWAutomation = paste("select * from VWAutomationData;")
grabSDO_XML_SCHEMAS = paste("select * from SDO_XML_SCHEMAS;")


#Run send query to database
VWAutomation <- RODBC::sqlQuery(conn, grabVWAutomation) 
SDO_XML_SCHEMAS <- RODBC::sqlQuery(conn, grabSDO_XML_SCHEMAS)
Table_Names <- RODBC::sqlQuery(conn, grabTableNames)

#Close connection
close(conn)

#Modify table data types
VWAutomation_edit = VWAutomation %>% mutate(
     QCMODELSYSTEM = as.character(QCMODELSYSTEM),
     SAMPLETYPE = as.character(SAMPLETYPE),
     BATCHCOMPLETEDDATE = ymd(BATCHCOMPLETEDDATE)
     ) %>% 
     filter(QCMODELSYSTEM != "", CORETEAM == c("Legacy", "LEGO", "New Content", "New Dye"))


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
    retype() %>% 

    mutate("DOM" = openxlsx::convertToDate(DOM),
           "Stability start" = openxlsx::convertToDate(TSL_table$`Stability start`),
           "Stability end" = openxlsx::convertToDate(TSL_table$`Stability end`),
           "Date Testing" = openxlsx::convertToDate(TSL_table$'Date Testing')
           )

TSL_summary_table = FERT %>% 
    group_by(`FERT STATUS`) %>% 
    summarise(total.batch = length(unique(`BATCH REQUESTED`)),
              total.HALBS = length(unique(`HALB`)),
              total.FERTs = length(unique(`FERT`))
    )

#Perform pull of rows from SQL table where batch numbers match

returnDB = VWAutomation[VWAutomation_edit$BATCHNO %in% FERT$BatchIDrequested,]
 
returnFileName = paste("C:/Users/10351517/Documents/Stability/getClones/VWAutomationa_BatchID_Matches", Sys.Date(), ".xlsx", sep="")
 
openxlsx::write.xlsx(returnDB, file = returnFileName)

