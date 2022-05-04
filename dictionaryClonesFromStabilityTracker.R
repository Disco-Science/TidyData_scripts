library(tidyverse)

cloneDF = readxl::read_excel("~/Code/Projects/Stability/tidyDat/cloneMasterCurated_Filtered.xlsx",
                        sheet = "Sheet 1",
                        col_names = TRUE) %>% 
    filter(!is.na(Model.System)) %>% 
    mutate(Clone = trimws(Clone, which = "both")) %>% 
    mutate(Model.System = trimws(Model.System, which = "both", whitespace = ))

dictionary = c()
dictionary2 = list()
dictionary3 = list()

for (i in 1:length(cloneDF$Clone)) {
    
    dictionary[trimws(paste(cloneDF$Clone[i]), which = "both")] = paste(trimws(cloneDF$Model.System[i], which = "both")) 
    dictionary2[trimws(cloneDF$Clone[i], which = "both")] = trimws(cloneDF$Model.System[i], which = "both")
    dictionary3[cloneDF$Clone[i]] = cloneDF$Model.System[i]
}

stabilityTracker = readxl::read_excel("~/Stability/Wave setup/Sharepoint_Tracking_sheets/FY22 Stability Tracking Sheet.xlsx",
                                      sheet = "2022 Sample Details",
                                      skip = 1,
                                      col_names = TRUE,
                                      col_types = "text"
                                      ) %>%
    mutate(Quarter = factor(Quarter)) %>% 
    filter(Quarter == "Q2")

modelList = c()

for (i in 1:length(stabilityTracker$Clone)) {
    
    key = stabilityTracker$Clone[i]
    # print(key)
    value = as.character(dictionary2[key]) 
    # print(value)
    
    modelList = append(modelList, value)
    
}

df = data.frame('Batch.ID' = stabilityTracker$`Batch Number`, Model.System = modelList)
df = inner_join(df, stabilityTracker, by=c("Batch.ID" = "Batch Number"))

#Create file name
fileName = paste("C:/Users/10351517/Documents/Stability/getClones/modelSystemResultsFY2022Q2", Sys.Date(), ".xlsx", sep="")

#Export selectedDF 
openxlsx::write.xlsx(df, file = fileName)

