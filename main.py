
import pandas as pd

def getSAPDB():

    oraclePD = pd.read_csv("testDB.csv", encoding='latin1')
    return oraclePD

def getPlan():
    
    planDB = pd.read_csv("planDB.csv")
    return planDB

def main():
    
    reagentsDB = getSAPDB()
    stabilityTestingTracker = getPlan()
    print("Complete")

main()
