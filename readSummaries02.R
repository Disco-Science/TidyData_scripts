library(openxlsx)
library(xlsx)
library(tidyverse)
library(openxlsx)
library(readxl)

#This process takes specifically the file in PATH and compiles them into a single file


# PATH = "~/Stability/Analysis/Summaries/edits/FY21 Summary Sheet Wave (9, 11, & D) edit 041522.xlsx"
FILES = list.files(path = "~/Stability/Analysis/Summaries/Files_for_reading/", 
                   full.names = TRUE,
                   )

# sheets = readxl::excel_sheets(path = PATH)
dump = data.frame()

for(file in FILES) {
    
    name = paste("df", sep = "")
    assign(name, readxl::read_excel(path = file,
                                    sheet = 1,
                                    col_names = TRUE,
                                    col_types = "text")
    )
    
    dump = bind_rows(dump, 
                     get(name))

}


# for(sheet in sheets) {
#     
#   name = paste("df", sheet, sep = "")
#   assign(name, readxl::read_excel(path = PATH,
#                                   sheet = sheet,
#                                   col_names = TRUE,
#                                   col_types = "text",)
#                     )
#   
#   dump = bind_rows(dump, get(name))
#   rm(name)
# }



# rm(sheets, PATH, sheet, name, file)



openxlsx::write.xlsx(dump, file = "~/Stability/getClones/summariesWrapped.xlsx")


