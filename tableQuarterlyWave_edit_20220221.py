# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd

oracleDB = pd.read_csv("testDB.csv", encoding='latin1')
planDB = pd.read_csv("planDB.csv")
sampleList = planDB['Batch Number']    

index = 0 # index position tracker for oracleDB
matchIndexPositionOnOracleDB = []
batchID_NoMatches = []
posMatch = 0
labelDF = pd.DataFrame()

for sampleBatchID in sampleList:
    
    # print(sampleBatchID)
    
    for SAP_BatchID in oracleDB['BATCHNO']:
        
        if sampleBatchID == SAP_BatchID:
            
            posMatch = 1
            matchIndexPositionOnOracleDB.append(index)
            index = index + 1
            
            continue
        
        else:
            
            index = index + 1
            
            continue
        
    if posMatch == 0:
            
        batchID_NoMatches.append(sampleBatchID)
        
    else:
            
        posMatch = 0
        
    index = 0 
    
    continue


for indexPosition in matchIndexPositionOnOracleDB:
    
    labelDF = labelDF.append(oracleDB.iloc[[indexPosition]])

modelSystemsWithValues = len(matchIndexPositionOnOracleDB) - labelDF['QCMODELSYSTEM'].isna().sum() # check sum for model systems

print("Complete")




