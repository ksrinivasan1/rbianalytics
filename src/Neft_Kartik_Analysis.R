library(ggplot2)

#Kartik's analysis 
#source(file = paste(workingDirectory, "/RbiNeft.R") )

# Txn Info By year
tapply(neftDataMerged$TotalTxnVal, neftData$Year, summary)
tapply(neftDataMerged$TotalTxnVal, neftData$Year, mean)
tapply(neftDataMerged$TotalTxnVal, neftData$Year, sd)
tapply(neftDataMerged$TotalTxns, neftData$Year, summary)
tapply(neftDataMerged$TotalTxns, neftData$Year, mean)
tapply(neftDataMerged$TotalTxns, neftData$Year, sd)

# Txn Info By month
tapply(neftDataMerged$TotalTxnVal, neftData$Month, summary)
tapply(neftDataMerged$TotalTxnVal, neftData$Month, mean)
tapply(neftDataMerged$TotalTxnVal, neftData$Month, sd)
tapply(neftDataMerged$TotalTxns, neftData$Month, summary)
tapply(neftDataMerged$TotalTxns, neftData$Month, mean)
tapply(neftDataMerged$TotalTxns, neftData$Month, sd)

# By month
#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxns))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxnVal))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=AvgTxnVal))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

# By month and broken up by bank type to see how number of transactions have played over months
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxns, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxnVal, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=AvgTxnVal, fill=Type)) + geom_bar(stat="sum")

#Over months
ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = monthNames), y=TotalTxns, fill=Type)) + geom_bar(stat="sum")

#Over months and over the years
ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = monthNames), y=TotalTxns, fill=Type)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) 

# By year and broken up by bank type to see how number of transactions have increased over years
ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxnVal, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=AvgTxnVal, fill=Type)) + geom_bar(stat="sum")

# By month and broken up by bank type to see how number of transactions have played over months
# ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns, fill=Filtered)) + geom_bar(stat="sum") 
