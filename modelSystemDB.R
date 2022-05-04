#Author: Nathan Choi
#Date: 04/01/2022

# This script is written to support the Stability team at BD Bioscience 
# The goal is to take multiple Excel files with some similar features 
# and consolidate them into a single data.frame() before being exported as an Excel file


#Lib loads
library(tidyverse)

#Load files; read sheet for models only; 2020 file is different from 2021 and 2022
modelSys2020=readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY20 Stability Tracking Sheet.xlsx",
                                sheet = "2020 Modelsystem infor use only",
                                skip = 1,
                                col_names = TRUE,
                                col_types = "text"
) %>% mutate(Year = 2020)



modelSys2021=readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY21 Stability Tracking Sheet.xlsx",
                                sheet = "2021 Model Systems",
                                
                                col_names = TRUE,
                                col_types = "text"
) %>% mutate(Year = 2021)


modelSys2022=readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY22 Stability Tracking Sheet.xlsx",
                                sheet = "2022 Model Systems",
                                
                                col_names = TRUE,
                                col_types = "text"
) %>% mutate(Year = 2022)

#gsub out empty space in column headers with '.'
names(modelSys2020) = gsub(" ", ".", names(modelSys2020))
names(modelSys2021) = gsub(" ", ".", names(modelSys2021))
names(modelSys2022) = gsub(" ", ".", names(modelSys2022))

#Extracting two columns as denoted below and creating a single column called 'Model.System' for only 2020 sheet
modelSys2020 = modelSys2020 %>% 
    mutate(Model.System = paste(`Model.system.(Provided.by.Mary)`,";",`Model.system.confirmed.by.Saloni./.tester`))

#Subset columns 'Clone' & 'Model.System' and filter out any with 0 value; why zero I don't know
dfClones2020 = modelSys2020[,c("Clone","Model.System", "Year")] %>% filter(Clone != 0) 
dfClones2021 = modelSys2021[,c("Clone","Model.System", "Year")] %>% filter(Clone != 0)
dfClones2022 = modelSys2022[,c("Clone","Model.System", "Year")] %>% filter(Clone != 0)

#Create a single df
dfClonesModelSys = bind_rows(dfClones2020,dfClones2021,dfClones2022)

fileName = ("~/Code/Projects/Stability/tidyDat/cloneMaster.")
#Write out consolidated clone names dataframe out
openxlsx::write.xlsx(dfClonesModelSys, file = paste(fileName, Sys.Date(), ".xlsx", sep = ""))
