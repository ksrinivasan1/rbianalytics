library(ggplot2)
library(car)
library(moments)
library(gridExtra)
setwd("D:/Personal/GMITE/BI_Git/trunk")

source(file = paste(getwd(), "/src/RbiNeft.R", sep = "") )


#### Creating Data copy of Transactions Per Sector Month #### 
neftTransPerSectorMonth <- aggregate(neftDataMerged[,9:10],list(neftDataMerged$Sector, neftDataMerged$Month),sum)
colnames(neftTransPerSectorMonth) <- c("Sector", "Month", "TotalTrans", "TotalTransVal")

#calculate avg transaction value per month
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


#### Creating Data copy of Transactions Per Year #### 
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

# store the averages into a new column
neftTransPerYear$AvgTransValue <- as.numeric(avgTransVals)


################## Start Plotting Data ####################

# Plot Histogram of Total Number of Transactions
hist(neftDataMerged$TotalTxnVal/1000,
     main = "Frequency of Total Value of Transactions",
     xlab = "Total Transaction Value\n(thousands)",
     breaks = 100,
     col = colors()[30:50])


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



# Plot Normal Distribution of Average Value of Transactions Per Year
qP <- qqPlot(neftTransPerYear$AvgTransValue, 
             main = "Normality of Average Transaction Value Per Year",
             xlab = "Normality", ylab = "Average Transaction Value Per Year",
             col.lines = "blue"
)

# Find the summary measures of the Avg Transaction Value per Year
summary(neftTransPerYear$AvgTransValue)
cat("\nSkewness: ",skewness(neftTransPerYear$AvgTransValue))
cat("\nStandard Deviation: ",sd(neftTransPerYear$AvgTransValue))


# Plot Average Value of transactions by Month and stack sector wise
ggplot2::ggplot(data=neftTransPerSectorMonth, aes(x=factor(Month, levels = month.abb), y=AvgTransValue, fill = Sector)) + geom_bar(stat="sum") + labs(x="Month", y="Avg Transaction Value\n(millions)", title="Average Value of Transactions per month") + theme(plot.title = element_text(hjust = 0.5))


# Plot Number/Value of transactions By month
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000)) + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank()) + labs(x="Month", y="Number of Transactions\n (millions)")
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000)) + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank()) + labs(x="Month", y="Value of Transactions\n (millions)")
grid.arrange(plot1, plot2, ncol=2)

# Plot Number/Value of transactions By year and stack sector wise
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) +  labs(x="Year", y="Number of Transactions\n(millions)")
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) +  labs(x="Year", y="Value of Transactions\n(millions)")
grid.arrange(plot1, plot2, ncol=2)

# Plot by year and broken up by bank sector to see how number of transactions have increased over years
ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_grid(. ~ Sector) + labs(x="Year", y="Number of Transactions\n(millions)") 
ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_grid(. ~ Sector)  + labs(x="Year", y="Value of Transactions\n(millions)")
