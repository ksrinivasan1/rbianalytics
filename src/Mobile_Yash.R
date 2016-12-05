#library(moments)
library("moments", lib.loc="C:/Users/ylondhe/Documents/R/win-library/3.3")
library("car", lib.loc="C:/Users/ylondhe/Documents/R/win-library/3.3")

Mobile <- read.csv('Mobile.csv', header = TRUE)

# Compare transactions and value of transactions
cor(Mobile$Transactions, Mobile$ValueInThousands)

plot(Mobile$Transactions, Mobile$ValueInThousands,
     main = "Trans Vs Val Mobile",
     pch=0,
     xlab = "Trans", ylab="Value")
lmFit <- lm(Mobile$Transactions  ~ Mobile$ValueInThousands)
abline(lmFit, col="red")


#summary parameters
summary(Mobile$Transactions)
sd(Mobile$Transactions)
summary(Mobile$ValueInThousands)
sd(Mobile$ValueInThousands)

#group by banks
TransPerBank <- aggregate(. ~ Mobile$Bank,
                                Mobile,
                                FUN = sum)
TransPerBank$Bank <- NULL
TransPerBank$Month <- NULL
TransPerBank$Year <- NULL

colnames(TransPerBank) <- c("Bank")

#TransPerBank <- aggregate(. ~ Mobile$Bank,  Mobile, FUN = sum)

qqPlot(TransPerBank$Total_Transactions)


plot(TransPerBank$Total_Transactions, TransPerBank$Total_Value,
     main = "Transactions Vs  Val Mobile",
     pch=0,
     xlab = "Transactions", ylab="Total Value")

lmFit2 <- lm(TransPerBank$Total_Transactions  ~ TransPerBank$Total_Value)
abline(lmFit2, col="red")

cor(TransPerBank$Total_Transactions, TransPerBank$Total_Value)