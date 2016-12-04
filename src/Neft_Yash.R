#library(moments)
library("moments", lib.loc="C:/Users/ylondhe/Documents/R/win-library/3.3")
library("car", lib.loc="C:/Users/ylondhe/Documents/R/win-library/3.3")

NEFT <- read.csv('NEFT.csv', header = TRUE)

hist(NEFT$InwardValueCrores, breaks = 100, main = "NEFT Inward Values crores")

# Compare transactions and value of transactions
cor(NEFT$InwardTransactions, NEFT$InwardValueCrores)

plot(NEFT$InwardTransactions, NEFT$InwardValueCrores,
     main = "Inward Trans Vs Inward Val NEFT",
     pch=0,
     xlab = "Inward Trans", ylab="Inward Value")
lmFit <- lm(NEFT$InwardTransactions ~ NEFT$InwardValueCrores)
abline(lmFit, col="red")


#summary parameters
summary(NEFT$InwardTransactions)
sd(NEFT$InwardTransactions)
summary(NEFT$InwardValueCrores)
summary(NEFT$OutwardTransactions)
summary(NEFT$OutwardValueCrores)

lmFit2 <- lm(NEFT$InwardTransactions ~ NEFT$InwardValueCrores)



#group by banks
InwardTransPerBank <- aggregate(NEFT$InwardTransactions ~ NEFT$Bank,
          NEFT,
          FUN = sum)
BankData <- c()
numBanks <- nrow(InwardTransPerBank)

colnames(InwardTransPerBank) <- c("Bank", "Total_InwardTransactions")

#InwardTransPerBank <- aggregate(. ~ NEFT$Bank,  NEFT, FUN = sum)

qqPlot(InwardTransPerBank$Total_InwardTransactions)


plot(InwardTransPerBank$Bank, InwardTransPerBank$Total_InwardTransactions,
     main = "Inward Trans Vs Inward Val NEFT",
     pch=0,
     xlab = "Bank", ylab="Inward Value")