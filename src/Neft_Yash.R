library(moments)
library(car)
library(ggplot2)
#library("moments")
#library("car")

workingDir = paste(getwd(),"/src/", sep = "")
#Kartik's analysis 
source(file = paste(workingDir, "RbiNeft.R", sep = "") )

#histogram of raw data.. may not be required
hist(neftDataMerged$InwardValueMillions, 
     breaks = 100,
     main = "NEFT Inward Values millions",
     col = colors()[30:50])


########################BY BANK TYPE#######################################
#group by bank type
TotalTransPerBankType <- aggregate(neftDataMerged[,9:10],list(neftDataMerged[,12]),sum)
colnames(TotalTransPerBankType) <- c("BankType", "TotalTrans", "TotalTransVal")
bp <- barplot(TotalTransPerBankType$TotalTransVal,
              main = "Plot of total trans by bank type",
              xlab = "Bank Type",
              ylab = "Total Transaction Value"
              )

xLabel <- c()
for(i in 1:nrow(TotalTransPerBankType)){
  xLabel[i] <- TotalTransPerBankType[i,1]
}

text(bp,par("usr")[3],labels = xLabel, srt = 45, adj = 1.2, cex=0.80, xpd = TRUE)


#avg transaction value per bank type
avgTransVals <- numeric()
for(i in 1:nrow(TotalTransPerBankType)){
  curRow <- TotalTransPerBankType[i,]
  if(curRow[2]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[3]/curRow[2])*1000000
  }
}

TotalTransPerBankType$AvgTransValue <- as.numeric(avgTransVals)

bp <- barplot(TotalTransPerBankType$AvgTransValue,
              main = "Plot of avg trans by bank type",
              xlab = "Bank Type",
              ylab = "Total Transaction Value"
)

xLabel <- c()
for(i in 1:nrow(TotalTransPerBankType)){
  xLabel[i] <- TotalTransPerBankType[i,1]
}

text(bp,par("usr")[3],labels = xLabel, srt = 45, adj = 1.2, cex=0.80, xpd = TRUE)


####################BY MONTH-YEAR####################################

#group by monthyear
TotalTransPerMonthYear <- aggregate(neftDataMerged[,9:10],list(neftDataMerged[,8]),sum)
colnames(TotalTransPerMonthYear) <- c("MonthYear", "TotalTrans", "TotalTransVal")
yearsFactor <- factor(substring(TotalTransPerMonthYear$MonthYear,5,8))
monthsFactor <- factor(substring(TotalTransPerMonthYear$MonthYear,1,3),  levels = month.abb)
SortedTransPerMonthAndYear <- TotalTransPerMonthYear[order(yearsFactor, monthsFactor),]

#plot bar graph of transactions per month-year
bp <- barplot(SortedTransPerMonthAndYear$TotalTransVal,
              main = "Plot of total trans per month-year ",
              xlab = "Month-Year",
              ylab = "Total Transaction Value",
              col = rainbow(20))

xLabel <- c()
for(i in 1:nrow(SortedTransPerMonthAndYear)){
  xLabel[i] <- SortedTransPerMonthAndYear[i,1]
}

text(bp,par("usr")[3],labels = xLabel, srt = 45, adj = 1.2, cex=0.80, xpd = TRUE)


#avg transaction value per month-year
avgTransVals <- numeric()
for(i in 1:nrow(SortedTransPerMonthAndYear)){
  curRow <- SortedTransPerMonthAndYear[i,]
  if(curRow[2]==0){
    avgTransVals[i] <- 0
  } else {
    avgTransVals[i] <- (curRow[3]/curRow[2])*1000000
  }
}

SortedTransPerMonthAndYear$AvgTransValue <- as.numeric(avgTransVals)

#draw qqPlot 
qqPlot(SortedTransPerMonthAndYear$AvgTransValue,
       main = "Normality of average trans value per month-year",
       ylab = "Average Transaction Value"
       )
cat("\n Skewness is ", skewness(SortedTransPerMonthAndYear$AvgTransValue))


######################### FIND YOY INCREASE PER YEAR #############

#group by year
TotalTransPerYear <- aggregate(neftDataMerged[,9:10],list(neftDataMerged[,7]), sum)
colnames(TotalTransPerYear) <- c("Year", "TotalTrans", "TotalTransVal")

MeanTransPerYear <- aggregate(neftDataMerged[,9:10],list(neftDataMerged[,7]), mean)
colnames(MeanTransPerYear) <- c("Year", "MeanTrans", "MeanTransVal")

#plot a line graph of total transactions per year
#the x axis does not show correctly
lp <- plot(TotalTransPerYear$Year,
     TotalTransPerYear$TotalTransVal/1000000, type = "o", 
     main = "Plot of total transaction value per year",
     xlab = "Year", ylab = "Total Transactions (in millions)", 
     cex = 1, pch = 2 )


totalTransVal <- TotalTransPerYear$TotalTransVal
totalTrans <- TotalTransPerYear$TotalTrans
numYears <- nrow(TotalTransPerYear)
yoyTransVal <- c()
yoyTrans <- c()

for(i in 1:numYears-1){
  yoyTransVal[i] <- (totalTransVal[i+1]  - totalTransVal[i])/totalTransVal[i]
  yoyTrans[i] <- (totalTrans[i+1]  - totalTrans[i])/totalTrans[i]
}
yoyTransVal[numYears] <- 0
yoyTrans[numYears] <- 0

TotalTransPerYear$TransChange <- yoyTrans
TotalTransPerYear$TransValChange <- yoyTransVal


# try to find a better method to do above
#TotalTransPerYear$Growth <- within(TotalTransPerYear, ave(TotalTransPerYear$TotalTransVal, Year, 
#                            FUN=function(x) c(NA, 100*diff(x)/x[-length(x),])))


#plot a line graph of change in total transactions per year
#the x axis does not show correctly
lp <- plot(TotalTransPerYear$Year,
           TotalTransPerYear$TransValChange *100, type = "o", 
           main = "Plot of total transaction value per year",
           xlab = "Year", ylab = "Total Transactions (in millions)", 
           cex = 1, pch = 2 )