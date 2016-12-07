
#Set up the current working directory.
#workingDirectory <- "/Users/ksrinivasan/Desktop/GMITE/Assignments/Statistics/final/rbianalytics/"
#sourceDirectory  <- paste(workingDirectory, "/src/")
#dataDirectory    <- paste(workingDirectory, "/data/")
#setwd(dirname(dataDirectory))

setwd("/Users/ksrinivasan/Desktop/GMITE/Assignments/Statistics/final/rbianalytics/")

# load up the bank classifications from working directory
bankClsfn <- c()
bankClsfn <- readxl::read_excel(path = "data/Classification.xlsx", sheet = "To_compare")

# create the data set (neftData) using all the annual data.
neftData  <- c()
fileNames <- c( "data/yearwise/2009.xlsx", "data/yearwise/2010.xlsx", "data/yearwise/2011.xlsx", "data/yearwise/2012.xlsx")
for(i in 1:length(fileNames)) {
  #Specifically load only the NEFT Sheets
  annualData  <- readxl::read_excel(path =fileNames[i], sheet = "NEFT")
  neftData    <- rbind(neftData, annualData)
}

# enhance the data set with some custom fields.
monthAndYear  <- c()
totalTxns     <- c()
totalTxnValue <- c()
for(i in 1:length(neftData$OutwardTransactions)) {
  monthAndYear [ i ]  <- paste(neftData$Month [ i ] , neftData$Year [ i ], sep = " ")
  totalTxns    [ i ]  <- neftData$OutwardTransactions[ i ]  + neftData$InwardTransactions[ i ]
  totalTxnValue[ i ]  <- neftData$OutwardValueMillions[ i ] + neftData$InwardValueMillions[ i ]
}
neftData$MonthAndYear <- monthAndYear
neftData$TotalTxns    <- totalTxns
neftData$TotalTxnVal  <- totalTxnValue

# join the bank data with classifications so we can get clean bank name and type
neftDataMerged <- merge(neftData, bankClsfn, by="Bank")
head(neftDataMerged)

