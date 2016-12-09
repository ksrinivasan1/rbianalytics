library(ggplot2)
library(car)
library(moments)
library(gridExtra)
setwd("D:/Personal/GMITE/BI_Git/trunk")

source(file = paste(getwd(), "/src/RbiNeft.R", sep = "") )

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
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000)) + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank()) + labs(x="Month", y="Number of Transactions\n (millions)")
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000)) + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank()) + labs(x="Month", y="Value of Transactions\n (millions)")
grid.arrange(plot1, plot2, ncol=2)
#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxnVal))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

#myPlot <- ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=AvgTxnVal))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())

# By month and broken up by bank type to see how number of transactions have played over months
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxns, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=TotalTxnVal, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Month, y=AvgTxnVal, fill=Type)) + geom_bar(stat="sum")

#Over months
#by number of transactions
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") + labs(x="Month", y="Number of Transactions\n (millions)")
#by value of transactions
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + labs(x="Month", y="Value of Transactions\n (millions)")
grid.arrange(plot1, plot2, nrow=2)

#################YASH STARTS ###########################
# i think avg is better here
# try above and then try below
# in above since we dont have data of nov n dec, it doesnt look correct
# average handles missing data issue.

neftTransPerSectorMonth <- aggregate(neftDataMerged[,9:10],list(neftDataMerged$Sector, neftDataMerged$Month),sum)
colnames(neftTransPerSectorMonth) <- c("Sector", "Month", "TotalTrans", "TotalTransVal")

#avg transaction value per month`
avgTransVals <- numeric()
for(i in 1:nrow(neftTransPerSectorMonth)){
  curRow <- neftTransPerSectorMonth[i,]
  if(curRow[3]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[4]/curRow[3])
  }
}

neftTransPerSectorMonth$AvgTransValue <- as.numeric(avgTransVals)

ggplot2::ggplot(data=neftTransPerSectorMonth, aes(x=factor(Month, levels = month.abb), y=AvgTransValue, fill = Sector)) + geom_bar(stat="sum") + labs(x="Month", y="Avg Transaction Value\n(millions)", title="Average number of transactions per month") + theme(plot.title = element_text(hjust = 0.5))

## group transactions per year and plot a normal distribution
neftTransPerYear <- aggregate(neftDataMerged[,9:10],list(neftDataMerged$Year),sum)
avgTransVals <- numeric()
for(i in 1:nrow(neftTransPerYear)){
  curRow <- neftTransPerYear[i,]
  if(curRow[2]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[3]/curRow[2])*1000000
  }
}

neftTransPerYear$AvgTransValue <- as.numeric(avgTransVals)

qP <- qqPlot(neftTransPerYear$AvgTransValue, 
        main = "Normality of Average Transaction Value Per Year",
        xlab = "Normality", ylab = "Average Transaction Value Per Year",
        col.lines = "blue"
       )

cat("\nSkewness is",skewness(neftTransPerYear$AvgTransValue))
summary(neftTransPerYear$AvgTransValue)


################YASH ENDS ####################


#Over months and over the years
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) +  labs(x="Year", y="Number of Transactions\n(millions)")
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) +  labs(x="Year", y="Value of Transactions\n(millions)")
grid.arrange(plot1, plot2, ncol=2)
# By year and broken up by bank type to see how number of transactions have increased over years
plot1 <-ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") +  labs(x="Year", y="Number of Transactions/n(millions)") 
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + labs(x="Year", y="Value of Transactions/n(millions)")
grid.arrange(plot1, plot2, ncol=2)
#ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxnVal, fill=Type)) + geom_bar(stat="sum")
#ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=AvgTxnVal, fill=Type)) + geom_bar(stat="sum")

# By month and broken up by bank type to see how number of transactions have played over months
# ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns, fill=Filtered)) + geom_bar(stat="sum") 
