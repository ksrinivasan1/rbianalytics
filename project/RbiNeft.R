# clear objects 
rm(list = ls())     

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

# Creating Data copy of Transactions Per Sector Month
neftTransPerSectorMonth <- aggregate(neftDataMerged[,9:10],list(neftDataMerged$Sector, neftDataMerged$Month),sum)
colnames(neftTransPerSectorMonth) <- c("Sector", "Month", "TotalTrans", "TotalTransVal")

#calculate average transaction value
avgTransVals <- numeric()
for(i in 1:nrow(neftTransPerSectorMonth)){
  curRow <- neftTransPerSectorMonth[i,]
  if(curRow[3]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[4]/curRow[3])
  }
}

# store the averages into a new column
neftTransPerSectorMonth$AvgTransValue <- as.numeric(avgTransVals)


# Creating Data copy of Transactions Per Year 
neftTransPerYear <- aggregate(neftDataMerged[,9:10],list(neftDataMerged$Year),sum)
colnames(neftTransPerSectorMonth) <- c("Year", "TotalTrans", "TotalTransVal")

#calculate average transaction value
avgTransVals <- numeric()
for(i in 1:nrow(neftTransPerYear)){
  curRow <- neftTransPerYear[i,]
  if(curRow[2]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[3]/curRow[2])*1000000
  }
}

# store the averages into a new column
neftTransPerYear$AvgTransValue <- as.numeric(avgTransVals)
