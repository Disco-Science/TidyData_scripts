#Author: Nathan Choi
#Date: 04/04/2022

#This script is designed for consolidating specific Excel files for the Stability team
#at BD Bioscience Stability Team
#The goal of this script is to consolidate the information between multiple files all 
#referred colloquially within this group as the  "Stability Tracking Files"
#The process will open each file and reformat dates, column names, etc. so that a single dataframe is created 
#then exported out as an excel file

#lib load
library(tidyverse)
library(lubridate) #mdy() for dates formatted in samples2020
library(openxlsx) #convertToDate() for excel serial date format

#Currently three files; 2020 - 2022 tracking files to load
samples2020=readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY20 Stability Tracking Sheet.xlsx",
                          sheet = "2020 Sample Details",
                          skip = 1,
                          col_names = TRUE,
                          col_types = "text"
                          ) 


samples2021=readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY21 Stability Tracking Sheet.xlsx",
                               sheet = "2021 Sample Details",
                               skip = 1,
                               col_names = TRUE,
                               col_types = "text"
                               ) 

samples2022=readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY22 Stability Tracking Sheet.xlsx",
                               sheet = "2022 Sample Details",
                               skip = 1,
                               col_names = TRUE,
                               col_types = "text"
                               ) 

#gsub out spaces in column names and replace with '.'
names(samples2020) = gsub(" ", ".", names(samples2020))
names(samples2021) = gsub(" ", ".", names(samples2021))
names(samples2022) = gsub(" ", ".", names(samples2022))

#Perform standardization of column names with tidyverse::dplyr functions; 2020 file is main culprit for inconsistenty with 2021 and 2022 being mostly the same 
#Perform conversion of character dates to date.class using lubridate and openxslx function calls
#Add in a year to tag source of data row
samples2020=samples2020 %>% filter(!is.na(Clone)) %>% 
    mutate(Date.stability.started=mdy(Date.stability.started),
           `Date.stability.ended.(5.yer.or.2.yer.for.Ab-E).years.(25C)`=mdy(`Date.stability.ended.(5.yer.or.2.yer.for.Ab-E).years.(25C)`),
           Date.of.Manufacture=convertToDate(Date.of.Manufacture),
           Year = rep(2020, length(samples2020[1]))) %>% 
    rename(`Batch.No`= `Batch.#`,
           'Stability.Start.Date' = Date.stability.started,
           'Stability.End.Date.25C' = `Date.stability.ended.(5.yer.or.2.yer.for.Ab-E).years.(25C)`,
           'Isotype' = `Isotype./.Test.or.Mass`,
           'Buffer' = `Buffer.(Optional)`,
           'Proj.or.MNF.No' = `Project.ID/.MN#:`
           )

samples2021=samples2021 %>% filter(!is.na(Clone)) %>%
    mutate(Date.Stability.Started=convertToDate(Date.Stability.Started),
           `Date.Stability.Ended(25C)`=convertToDate(`Date.Stability.Ended(25C)`),
           Date.of.Manufacture=convertToDate(Date.of.Manufacture),
           Year = rep(2021, length(samples2020[1]))) %>% 
    rename(`Batch.No`=Batch.Number,
           'Stability.Start.Date' = Date.Stability.Started,
           'Stability.End.Date.25C' = `Date.Stability.Ended(25C)`,
           'Buffer' = `Buffer.(Optional)`
           ) 

samples2022=samples2022 %>% filter(!is.na(Clone)) %>%
    mutate(Date.Stability.Started=convertToDate(Date.Stability.Started),
           `Date.Stability.Ended(25C)`=convertToDate(`Date.Stability.Ended(25C)`),
           Date.of.Manufacture=convertToDate(Date.of.Manufacture),
           Year = rep(2022, length(samples2020[1]))) %>% 
    rename(`Batch.No`=Batch.Number,
           'Stability.Start.Date' = Date.Stability.Started,
           'Stability.End.Date.25C' = `Date.Stability.Ended(25C)`,
           'Buffer' = `Buffer.(Optional)`
           )

#DPLYR function call to bind rows to combine all files; move 'Year' column to the front of the dataframe
newDF = bind_rows(samples2020,samples2021,samples2022) %>% relocate(Year)

#export data as a filename that includes the date of creation
fileName = paste("~/Stability/getClones/Stability.Trackers.Consolidated.", Sys.Date(), ".xlsx", sep = "")
openxlsx::write.xlsx(newDF, file = fileName)


