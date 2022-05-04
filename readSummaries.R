library(openxlsx)
library(xlsx)
library(tidyverse)
library(openxlsx)

#This process takes specifically the file in PATH and compiles them into a single file
#This is not a reproducible process and do not use for any other file. 

PATH = "~/Stability/Analysis/Summaries/edits/Age of Samples FY20 04072022.xlsx"

dump = data.frame()

for(i in 1:11) {
  
  file = PATH
  name = paste("df", i, sep = "")
  assign(name, readxl::read_excel(path = file,
                                  sheet = i,
                                  col_names = TRUE,
                                  col_types = "text",)
                    )
  
  dump = bind_rows(dump, get(name))
  
}


colheaders = names(dump)

openxlsx::write.xlsx(dump, file = "./fy2020CompiledSummary.xlsx")


