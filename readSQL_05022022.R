library(tidyverse)
library(xlsx)
library(DBI)
library(RMySQL)
library(RMariaDB)
library(lubridate)
library(odbc)
library(RODBC)

conn <- RODBC::odbcConnect(dsn = "RTPHPP1_64Bit", uid = "NATHANC", pwd = "Tracker2022!@#Tracker", believeNRows = FALSE) 

grabTableNames = paste("SELECT table_name from all_tables order by table_name")
grabVWAutomation = paste("select * from VWAutomationData;")
grabSDO_XML_SCHEMAS = paste("select * from SDO_XML_SCHEMAS;")


VWAutomation <- RODBC::sqlQuery(conn, grabVWAutomation) 
SDO_XML_SCHEMAS <- RODBC::sqlQuery(conn, grabSDO_XML_SCHEMAS)
Table_Names <- RODBC::sqlQuery(conn, grabTableNames)

close(conn)

VWAutomation_edit = VWAutomation %>% mutate(
    QCMODELSYSTEM = as.character(QCMODELSYSTEM),
    SAMPLETYPE = as.character(SAMPLETYPE),
    BATCHCOMPLETEDDATE = ymd(BATCHCOMPLETEDDATE)
    ) %>% 
    filter(QCMODELSYSTEM != "", CORETEAM == c("Legacy", "LEGO", "New Content", "New Dye"))


# #Create file name
fileName = paste("C:/Users/10351517/Documents/Stability/getClones/SQL_View_VWAutomation", Sys.Date(), ".xlsx", sep="")
# 
# #Export selectedDF 
openxlsx::write.xlsx(VWAutomation_edit, file = fileName)

#random script

schema_01 <- SDO_XML_SCHEMAS[1,3]
levels(schema_01)
