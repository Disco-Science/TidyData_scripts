library(tidyverse)

cloneDF = readxl::read_excel("~/Code/Projects/Stability/tidyDat/cloneMaster.2022-04-12.xlsx",
                        sheet = "Sheet 1",
                        col_names = TRUE) %>% 
    filter(!is.na(Model.System)) %>%
    mutate(Clone = trimws(Clone, which = "both")) %>%
    mutate(Model.System = trimws(Model.System, which = "both", whitespace = ))

uniqueClones = unique(cloneDF$Clone)

newDF = data.frame(
    Clones = character(0),
    Model.System = character(0)
)



for (i in uniqueClones) {
    
    singleClone = cloneDF %>%
        filter(Clone == i)
    
    string = "not anything"
    
    # for (b in 1:length(singleClone$Clone)) {
    #     
    #     if (singleClone$Year == 2022){
    #         
    #         string = singleClone$Model.System[b]
    #         
    #         break
    #         
    #     } else if (singleClone$Year == 2021) {
    #         
    #     }
    # }
    
    add = data.frame(Clones = i, 
                     Model.System = string)
    
    newDF = rbind(newDF, add)
    
}


