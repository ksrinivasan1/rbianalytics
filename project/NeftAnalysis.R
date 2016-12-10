library(ggplot2)
library(car)
library(moments)
library(gridExtra)

#Set up the current working directory of the script
# or set using the GUI functionality of R Studio
# example: setwd("D:/Personal/GMITE/BI_Git/trunk/project")
setwd("<TODO>")   

#source the data file to load the data
source(file = "NeftData.R" )

# Plot Histogram of Total Number of Transactions
cat("\nGraph 1: Frequency of Total Value of Transactions")
hist(neftDataMerged$TotalTxnVal/1000,
     main = "Frequency of Total Value of Transactions",
     xlab = "Total Transaction Value\n(thousands)",
     breaks = 100,
     col = colors()[30:50])


# Summary Measures By year
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Year, summary)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Year, mean)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Year, sd)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Year, summary)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Year, mean)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Year, sd)

# Summary Measures By month
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Month, summary)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Month, mean)
tapply(neftDataMerged$TotalTxnVal, neftDataMerged$Month, sd)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Month, summary)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Month, mean)
tapply(neftDataMerged$TotalTxns, neftDataMerged$Month, sd)


# Find the summary measures of the Avg Transaction Value per Year
summary(neftTransPerYear$AvgTransValue)
cat("\nSkewness: ",skewness(neftTransPerYear$AvgTransValue))
cat("\nStandard Deviation: ",sd(neftTransPerYear$AvgTransValue))

# Plot Normal Distribution of Average Value of Transactions Per Year
cat("\nGraph 2: Normality of Average Value of Transactions Per Year")
qP <- qqPlot(neftTransPerYear$AvgTransValue, 
             main = "Normality of Average Transaction Value Per Year",
             xlab = "Normality", ylab = "Average Transaction Value Per Year",
             col.lines = "blue"
)


# Plot Average Value of transactions by Month and stack sector wise
cat("\nGraph 3 Bar-Graph of the Average Value of Transactions month-wise and then arranged as per the Bank Sector")
ggplot2::ggplot(data=neftTransPerSectorMonth, aes(x=factor(Month, levels = month.abb), y=AvgTransValue, fill = Sector)) + geom_bar(stat="sum") + labs(x="Month", y="Avg Transaction Value\n(millions)", title="Average Value of Transactions per month") + theme(plot.title = element_text(hjust = 0.5))


# Plot Number/Value of transactions By month
cat("\nGraph 4 Plot of Total Number of Transactions/Total Value of Transactions by each month")
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000)) + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank()) + labs(x="Month", y="Number of Transactions\n (millions)")
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000)) + geom_point(shape=1,alpha=1/10) + facet_wrap(~factor(Month, levels = month.abb)) + theme(axis.text.x=element_blank()) + labs(x="Month", y="Value of Transactions\n (millions)")
grid.arrange(plot1, plot2, ncol=2)

# Plot Number/Value of transactions By year and stack sector wise
cat("\nGraph 5: Sector-wise Annual No. of Transactions/Value of Transactions month wise Bank Sector")
plot1 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) +  labs(x="Year", y="Number of Transactions\n(millions)")
plot2 <- ggplot2::ggplot(data=neftDataMerged, aes(x=factor(Month, levels = month.abb), y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_wrap(~Year) + theme(axis.text.x=element_blank()) +  labs(x="Year", y="Value of Transactions\n(millions)")
grid.arrange(plot1, plot2, ncol=2)

# Plot by year and broken up by bank sector to see how number of transactions have increased over years
cat("\nGraph 6 Graph of the Total Number of Transactions year-wise grouped by the Bank Sector")
ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxns/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_grid(. ~ Sector) + labs(x="Year", y="Number of Transactions\n(millions)") 

cat("\nGraph 7 Graph of the Total Value of Transactions year-wise grouped by the Bank Sector")
ggplot2::ggplot(data=neftDataMerged, aes(x=Year, y=TotalTxnVal/1000000, fill=Sector)) + geom_bar(stat="sum") + facet_grid(. ~ Sector)  + labs(x="Year", y="Value of Transactions\n(millions)")
