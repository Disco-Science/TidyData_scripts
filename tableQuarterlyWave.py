# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
import pandas as pd

oracleDB = pd.read_csv("testDB.csv", encoding='latin1')
planDB = pd.read_csv("planDB.csv")
sampleList = planDB['Batch Number']    

index = 0 # index position tracker for oracleDB
matches = []
noMatches = []
posMatch = 0
labelDF = pd.DataFrame()

for sampleBatchID in sampleList:
    
    for SAP_BatchID in oracleDB['BATCHNO']:
        
        if sampleBatchID == SAP_BatchID:
            
            posMatch = 1
            matches.append(index)
            index = index + 1
            
            continue
        
        else:
            
            index = index + 1
            
            continue
    
    if posMatch == 0:
        
        noMatches.append(sampleBatchID)
        
    else:
        
        posMatch = 0
        
    index = 0 
    
    continue


for indexPosition in matches:
    
    labelDF = labelDF.append(oracleDB.iloc[[indexPosition]])

modelSystemsWithValues = len(matches) - labelDF['QCMODELSYSTEM'].isna().sum() # check sum for model systems

sampleBatchID = 999
SAP_BatchID = 999
indexPosition = 999

print("Complete")

labelsCSV = pd.DataFrame()


