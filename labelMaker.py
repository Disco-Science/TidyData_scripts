# -*- coding: utf-8 -*-


import pandas as pd


TrackingSheet = pd.read_excel("FY22 Stability Tracking Sheet Nathan edit.xlsx", sheet_name="2022 Sample Details", skiprows=1)
labelTemplate = pd.DataFrame(columns = ["1", "2", "3", "4", "5"])
labelsDF = pd.DataFrame(columns = ["1", "2", "3", "4", "5", "6"])
timePoints = ["4C", "25C 0.5yr", "25C 1yr","25C 1.5yr", "25C 2yr","25C 3yr","25C 4yr", "25C 5yr" ]
date = "start: 02/08/22"


for index in TrackingSheet.index:
    
    target = str(TrackingSheet["Target"][index]).strip()
    clone = str(TrackingSheet["Clone"][index]).strip()
    col1 = target[0:8] + " " + clone[0:4]
    
    labelTemplate.loc[index] = [col1, 
                          TrackingSheet["Format"][index],
                          TrackingSheet["Batch Number"][index],
                          TrackingSheet["Sample Concentration (mg/ml)"][index],
                          date,]
                          
for index in labelTemplate.index:

    
    tempDF = pd.DataFrame(columns = ["1", "2", "3", "4", "5", "6"])
    
    if labelTemplate["2"][index] == "Ab-E":
        
        for i in range(5):
        
            
            tempDF.loc[i] = [labelTemplate["1"][index],
                             labelTemplate["2"][index],
                             labelTemplate["3"][index],
                             labelTemplate["4"][index],
                             labelTemplate["5"][index],
                             timePoints[i]]
            
            continue
        
    else:
        
        for i in range(8):
            
            tempDF.loc[i] = [labelTemplate["1"][index],
                             labelTemplate["2"][index],
                             labelTemplate["3"][index],
                             labelTemplate["4"][index],
                             labelTemplate["5"][index],
                             timePoints[i]]
            
            continue
        
    frames = [labelsDF, tempDF]
        
    labelsDF = pd.concat(frames, ignore_index = True, )
            
    tempDF = pd.DataFrame(columns = ["1", "2", "3", "4", "5", "6"])
        
    continue

fileName = "labels.xlsx"

labelsDF.to_excel(fileName, index=False, engine='openpyxl')


        
        
        
        