#Load libs
library(tidyverse)
library(stringr)
library(openxlsx) #convertToDate() for excel serial date format


#Read output from consolidated Stability tracking sheets
table = readxl::read_excel("C:/Users/10351517/Documents/Stability/getClones/searchableDF.xlsx",
                                       col_names = TRUE,
                                       col_types = "text"
) 

#Mutate to convert Excel serial data into Date class objects
table = table %>% 
    mutate(Date.of.Manufacture = convertToDate(Date.of.Manufacture),
           Stability.Start.Date = convertToDate(Stability.Start.Date),
           Stability.End.Date.25C = convertToDate(Stability.End.Date.25C)
           )

#Read in CAPA clones and metadata
clones = readxl::read_excel("C:/Users/10351517/Documents/Stability/getClones/Find/CAPA_search.xlsx",
                            col_names = TRUE,
                            col_types = "text"
)

#Filter out Stability.End.Date.25C that are older than 3 weeks from current date
dateScreenedDF = table %>% filter(Stability.End.Date.25C >= Sys.Date() - 21 | is.na(Stability.End.Date.25C))

#Create index of only unique clone names from capa list 
cloneID = unique(clones$ID)

#Empty df to be appended
selectedDF = data.frame()

#Empty list to create dictionary of clone:CAPA remark
CAPA_dict = list()

#for loop to create a dictionary
for (i in 1:length(clones$ID)) {
    
    key = clones$ID[i]
    value = clones$Listing[i]
    
    CAPA_dict[key] = value

    }

#Loop through cloneID index
for(i in 1:length(cloneID)) {
    #for each item in cloneID list use the cloneID string identification to find index logic within datescreenedDF$Clone column 
    index = grep(cloneID[i], dateScreenedDF$Clone)
    #subset risk level based on clone through CAPA_dictionary
    risk.Level = CAPA_dict[cloneID[i]]
    #subset using index to create new dataframe and add in risk.Level 
    newDF = dateScreenedDF[index,] %>% filter(Team == "LEGO" | Team == "LEGO ATO-MTS") %>% mutate(Risk.Level = CAPA_dict[cloneID[i]])
    #rowbind to new dataframe
    selectedDF = bind_rows(selectedDF,newDF)
}

#Rearrange columns
selectedDF = selectedDF[,c(1,2,7,8,4,11,42,10,1,6,5)]

#Create file name
fileName = paste("C:/Users/10351517/Documents/Stability/getClones/LEGO_CAPA_Matches_test", (Sys.Date()-21), "_", Sys.Date(), ".xlsx", sep="")

#Export selectedDF 
openxlsx::write.xlsx(selectedDF, file = fileName)
