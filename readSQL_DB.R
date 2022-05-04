library(tidyverse)
library(xlsx)
library(DBI)
library(RMySQL)
library(RMariaDB)
library(lubridate)
library(odbc)

con = dbConnect("RTHPP1",
                user = "NATHANC",
                password = "Tracker2022!@#Tracker",
                port = 7359,
                host = "hpp1db.global.bdx.com",
                dbname = "BD_HPP1"
                )

con2 = DBI::dbConnect(
    odbc::odbc(),
    Driver = "RTHPP1",
    Server = "hpp1db.global.bdx.com",
    UID = "NATHANC",
    PWD = "Tracker2022!@#Tracker",
    Port = 7359
)

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

