rm(list = ls())     # clear objects 

#Set up the working directory.
#setwd("/Users/ksrinivasan/Desktop/GMITE/Assignments/Statistics/final/rbianalytics/")
#setwd("D:/Personal/GMITE/BI_Git/trunk")

# load up the bank classifications from working directory
bankClsfn <- c()
bankClsfn <- readxl::read_excel(path = "data/Classification.xlsx", sheet = "To_compare")

# create the data set (neftData) using all the annual data - each excel contains data worth an year.
neftData  <- c()
fileNames <- c( "data/yearwise/2009.xlsx", "data/yearwise/2010.xlsx", "data/yearwise/2011.xlsx", "data/yearwise/2012.xlsx",
                "data/yearwise/2013.xlsx", "data/yearwise/2014.xlsx", "data/yearwise/2015.xlsx", "data/yearwise/2016.xlsx")
for(i in 1:length(fileNames)) {
  annualData  <- readxl::read_excel(path =fileNames[i], sheet = "NEFT")   #Specifically load only the NEFT Sheets
  neftData    <- rbind(neftData, annualData)
}

# enhance the data set with some custom fields (monthAndYear, Totaltxns, totalvalue).
monthAndYear  <- c()
totalTxns     <- c()
totalTxnValue <- c()
for(i in 1:length(neftData$OutwardTransactions)) {
  monthAndYear [ i ]  <- paste(neftData$Month [ i ] , neftData$Year [ i ], sep = " ")
  totalTxns    [ i ]  <- neftData$OutwardTransactions  [ i ] + neftData$InwardTransactions [ i ]
  totalTxnValue[ i ]  <- neftData$OutwardValueMillions [ i ] + neftData$InwardValueMillions[ i ]
}
neftData$MonthAndYear <- monthAndYear
neftData$TotalTxns    <- totalTxns
neftData$TotalTxnVal  <- totalTxnValue
# join the bank data with classifications so we can get clean bank name and type
neftDataMerged <- merge(neftData, bankClsfn, by="Bank")

#head(neftDataMerged)

