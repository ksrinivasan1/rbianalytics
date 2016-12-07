library(ggplot2)

#Kartik's analysis 
#source(file = paste(workingDirectory, "/RbiNeft.R") )

# TxnValue By year
tapply(neftData$TotalTxnVal, neftData$Year, summary)
tapply(neftData$TotalTxnVal, neftData$Year, mean)
tapply(neftData$TotalTxnVal, neftData$Year, sd)
# Txns By year
tapply(neftData$TotalTxns, neftData$Year, summary)
tapply(neftData$TotalTxns, neftData$Year, mean)
tapply(neftData$TotalTxns, neftData$Year, sd)

# By month
tapply(neftData$TotalTxnVal, neftData$Month, summary)
tapply(neftData$TotalTxnVal, neftData$Month, mean)
tapply(neftData$TotalTxnVal, neftData$Month, sd)


myPlot <- ggplot2::ggplot(data=neftData, aes(x=Month, y=TotalTxns))
myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())


myPlot <- ggplot2::ggplot(data=neftData, aes(x=Month, y=TotalTxnVal))
myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Month) + theme(axis.text.x=element_blank())


#myPlot <- ggplot2::ggplot(data=neftData, aes(x=MonthAndYear, y=TotalTxns))
#myPlot + geom_point(shape=1,alpha=1/10) + facet_wrap(~Bank) + theme(axis.text.x=element_blank())
