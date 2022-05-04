library(tidyverse)
library(xlsx)
library(DBI)
library(RMySQL)
library(RMariaDB)
library(lubridate)
library(odbc)
library(RODBC)

# conn <- RODBC::odbcConnect(dsn = "RTPHPP1_64Bit", uid = "NATHANC", pwd = "Tracker2022!@#Tracker") 



sqlData = read.table(file = "~/Code/Projects/Databases/SQL_DB/Data_tables/VWAutomationData_HPP1_04062022.csv",
                     sep = ",",
                     header = TRUE,
                     encoding = "UTF-8",
                     na.strings = "") %>%
    mutate(QCMODELSYSTEM = as.character(QCMODELSYSTEM),
           SAMPLETYPE = as.character(SAMPLETYPE),
           BATCHCOMPLETEDDATE = dmy(BATCHCOMPLETEDDATE))
    # filter(QCMODELSYSTEM != "", CORETEAM == c("Legacy", "LEGO", "New Content", "New Dye"))


clone_Model = list()
    
for (i in 1:length(sqlData$PROJECTID)) {
    
    clone_Model[as.character(sqlData$SAPCLONENAME[i])] = as.character(sqlData$QCMODELSYSTEM[i])
    
}

clone_Model = data.frame(Clone = names(clone_Model), Model.System = unlist(clone_Model))

# #Create file name
fileName = paste("C:/Users/10351517/Documents/Stability/getClones/SQL_Model_Systems_test", Sys.Date(), ".xlsx", sep="")
# 
# #Export selectedDF 
openxlsx::write.xlsx(clone_Model, file = fileName)

