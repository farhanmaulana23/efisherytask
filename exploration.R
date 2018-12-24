#load packages
library(ggplot2)
library(sandwich)

#load data
train <- read.csv("train.csv", header=TRUE)
test <- read.csv("test.csv", header=TRUE)

#factoring the data
train <- within(train, {
  season <- factor(season, levels=1:4, labels=c("Spring", "Summer", 
                                                     "Fall", "Winter"))
  holiday <- factor(holiday, levels=0:1, labels=c("notholiday", "holiday"))
  workingday <- factor(workingday, levels=0:1, labels=c("nowork", "work"))
  weather <- factor(weather, levels=1:4, labels=c("clear", "cloudy", "lightrain", "heavyrain"))
})

#change time format
train$datetime <- as.character(train$datetime)
train$datetime <- as.Date(train$datetime, format = "%d-%m-%y %H")

#ggplot overall count
ggplot(data=train, aes(x = datetime, y = count)) +
      geom_point(alpha = 1/10) +
      labs(title = "Overall distribution of total bicycle rent",
      	x = "Month (2011-2012)",
      	y = "Total bicycle rent")

#ggplot casual count
ggplot(data=train, aes(x = datetime, y = casual)) +
      geom_point(alpha = 1/10) +
      labs(title = "Overall distribution of casual bicycle rent",
      	x = "Month (2011-2012)",
      	y = "casual bicycle rent")

#ggplot registered count
ggplot(data=train, aes(x = datetime, y = registered)) +
      geom_point(alpha = 1/10) +
      labs(title = "Overall distribution of registered bicycle rent",
      	x = "Month (2011-2012)",
      	y = "registered bicycle rent")

#poisson regression
summary(m1 <- glm(count ~ season + holiday + workingday + weather + atemp + humidity + windspeed, family="poisson", data=train))

#robust SE
cov.m1 <- vcovHC(m1, type="HC0")
std.err <- sqrt(diag(cov.m1))
r.est <- cbind(Estimate= coef(m1), "Robust SE" = std.err,
"Pr(>|z|)" = 2 * pnorm(abs(coef(m1)/std.err), lower.tail=FALSE),
LL = coef(m1) - 1.96 * std.err,
UL = coef(m1) + 1.96 * std.err)
r.est

#check
with(m1, cbind(res.deviance = deviance, df = df.residual,
  p = pchisq(deviance, df.residual, lower.tail=FALSE)))
