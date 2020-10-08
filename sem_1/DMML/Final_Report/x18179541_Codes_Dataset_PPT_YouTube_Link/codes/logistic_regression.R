# Read Dataset from csv file
nhl_log <- read.csv("D:/Data_Mining/project/dataset/NHL.csv", skip=0, check.names=FALSE,  stringsAsFactors = FALSE)
head(nhl_log)

str(nhl_log)
names(nhl_log)

table(nhl_log$powerPlayShotsAgainst)
# Data preparartion 
nhl_log<-nhl_log[!nhl_log$decision=="",]

head(nhl_log)

nhl_log[is.na(nhl_log)]<- 0

library(dplyr)
nhl_log_filter<-nhl_log %>% group_by(game_id)%>% filter(n()>2)

nhl_log<-nhl_log[!nhl_log$game_id %in% nhl_log_filter$game_id,]

nhl_log['decision'] <- as.factor(nhl_log$decision)
table(nhl_log$decision)
summary(nhl_log)

# Normalization using z-score

nhl_log_z <- as.data.frame(scale(nhl_log[,-16]))

summary(nhl_log_z)

# Visualize data as bar chart numeric variable split into bins

graphics.off()
par("mar")

par(mar=c(1,1,1,1))
par(mfrow=c(1,18))
for(i in 1:18){
  hist(nhl_log_z[,i], main=names(nhl_log_z)[i])
}

# Visualization using box plot

par(mfrow=c(1,18))
for(i in 1:18){
  boxplot(nhl_log_z[,i], main=names(nhl_log_z)[i])
}

# check for unique values
sapply(nhl_log, function(x)length(unique(x)))
 
#Missing  Value Map - No missing data
library(Amelia)
missmap(nhl_log, main = "Missing Values Vs Observed")

# corerplot plot
library(corrplot)
correlations <- cor(nhl_log_z)

corrplot(correlations)

# find correlation between independent variables
pairs(nhl_log_z, col=nhl_log$decision)


# Density distribution 
library(caret)

x<- nhl_log_z[,1:18]
y<- nhl_log[,16]


scales <- list(x=list(relation="free"), y=list(relation="free"))

featurePlot(x=x, y=y, plot="density", scales=scales)

# logistic regression for over all model
glm.fit<- glm(decision~ ., data= nhl_log, family = binomial)
gm.null <- glm(decision~ 1, data= nhl_log, family = binomial)
1-logLik(glm.fit)/logLik(gm.null)
summary(glm.fit)

glm.probs <- predict(glm.fit, type = "response")
glm.probs[1:5]

# Prediction based on all independent variables
glm.pred<- ifelse(glm.probs>0.5, "W","L")
attach(nhl_log)
table(glm.pred, decision)

mean(glm.pred==decision) # 0.751

# logistic regression by training and testing the datasets

nhl_log_train <- nhl_log[1:18292,]
nhl_log_test <- nhl_log[18293:22866,]

head(nhl_log_train)

glm.fit.train<- glm(decision~. -powerPlayShotsAgainst, data=nhl_log_train, family = "binomial")
gm.fit.null <- glm(decision~ 1, data= nhl_log_train, family = "binomial")
1-logLik(glm.fit.train)/logLik(gm.fit.null)

summary(glm.fit.train)

glm.probs.train <- predict(glm.fit.train, newdata = nhl_log_test, type="response")

glm.pred.train <- ifelse(glm.probs.train>0.5, "W", "L")

decision_test <- nhl_log_test$decision
table(glm.pred.train,decision_test)

mean(glm.pred.train==decision_test) # 0.758

CrossTable(x= decision_test, y= glm.pred.train, prop.chisq = FALSE)
