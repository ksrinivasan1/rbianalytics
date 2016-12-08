library(ggplot2)

#Kartik's analysis 
#source(file = paste(workingDirectory, "/RbiNeft.R") )

# Txn Info By year
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Year, summary)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Year, mean)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Year, sd)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Year, summary)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Year, mean)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Year, sd)

# Txn Info By month
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Month, summary)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Month, mean)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Month, sd)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Month, summary)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Month, mean)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Month, sd)

# By month
myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns))
myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank())

#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxnVal))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=AvgTxnVal))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

# By month and broken up by bank type to see how number of transactions have played over months
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxns, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxnVal, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=AvgTxnVal, fill=Type)) + geom_bar(stat="sum")

#Over months
ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns, fill=Sector)) + geom_bar(stat="sum")

#################YASH STARTS ###########################
# i think avg is better here
# try above and then try below
# in above since we dont have data of nov n dec, it doesnt look correct
# average handles missing data issue.

TotalTransPerMonth <- aggregate(neftDataMerged[,9:10],list(neftDataMerged$Sector, neftDataMerged$Month),sum)
colnames(TotalTransPerMonth) <- c("Sector", "Month", "TotalTrans", "TotalTransVal")

#avg transaction value per month`
avgTransVals <- numeric()
for(i in 1:nrow(TotalTransPerMonth)){
  curRow <- TotalTransPerMonth[i,]
  if(curRow[3]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[4]/curRow[3])*1000000
  }
}

TotalTransPerMonth$AvgTransValue <- as.numeric(avgTransVals)

ggplot2::ggplot(data=TotalTransPerMonth, aes(x=factor(Month, levels = month.abb), y=AvgTransValue, fill = Sector)) + geom_bar(stat="sum")


################YASH ENDS ####################


#Over months and over the years
ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) 

# By year and broken up by bank type to see how number of transactions have increased over years
ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns, fill=Sector)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxnVal, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=AvgTxnVal, fill=Type)) + geom_bar(stat="sum")

# By month and broken up by bank type to see how number of transactions have played over months
# ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns, fill=Filtered)) + geom_bar(stat="sum") 
