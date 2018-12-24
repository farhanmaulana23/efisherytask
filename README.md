# Farhan's E-Fishery Interview Task
So actually, I want to apologize of the unaccomplished goals. I've tried to

  - Learn Machine Learning course from scratch in under 5 days (but failed to complete)
  - Reaching the deadlines, don't know what to do. Just searched how to deploy Python ML model in a fastest way (yet haven't understand the data)
  - Okay, I think the most optimum way is to just use what capabilities already in mine (with only 1 day left to do all of this). So, the only goals I give, maybe only 2, 3, and 4. (Sorry once again)

# This is actually available too in the slides
First, I explore the data using basic ggplot2. But I have to change it in some way so that R can interpret it.
```sh
#load packages
library(ggplot2)

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

```
Then, look for the bird-eye view of the data
```sh
ggplot(data=train, aes(x = datetime, y = count)) +
      geom_point(alpha = 1/10) +
      labs(title = "Overall distribution of total bicycle rent",
      	x = "Month (2011-2012)",
      	y = "Total bicycle rent")
```
Okay, it seems good. And after I cross-check with only casual/registered data, the trend applies. So I can just use the count data for the sake of simplicity.

My first choice of regression that comes to mind when seeing this data is Poisson regression. So I use it.

```sh
summary(m1 <- glm(count ~ season + holiday + workingday + weather + atemp + humidity + windspeed, family="poisson", data=train))
```

To control for mild violation of the distribution assumption, I checked its robust SE.
```sh
library(sandwich)
cov.m1 <- vcovHC(m1, type="HC0")
std.err <- sqrt(diag(cov.m1))
r.est <- cbind(Estimate= coef(m1), "Robust SE" = std.err,
"Pr(>|z|)" = 2 * pnorm(abs(coef(m1)/std.err), lower.tail=FALSE),
LL = coef(m1) - 1.96 * std.err,
UL = coef(m1) + 1.96 * std.err)
r.est
```
Okay, the result is fine (and included the explanations in the slide)
Yet, I still have to check if the data fit the model using goodness-of-fit chi-squared test.
```sh
with(m1, cbind(res.deviance = deviance, df = df.residual,
  p = pchisq(deviance, df.residual, lower.tail=FALSE)))
 ```
 This is not good, because the result is significant, and it signifies an overdispersion. So.. yeah. That's what can I infer from the data. Sorry if this does not meet your expectations, Mr. Anshory.
 
 But if you may give me chance to learn in E-Fishery, as a 'mahasiswa banting setir' from Microbiology to Data Scientist, I can assure you I will give it all to learn from scratch, like I learn all of this in the last 10 months of my final undergraduate year, or maybe give you some insights based on my Microbiology domain.
 
 Thank you very much for your consideration.
 Farhan

