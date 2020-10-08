# Read data from csv file
horse_result <- read.csv("D:/Data_Mining/project/dataset/race-result-horse.csv", check.names=FALSE)
race_result <- read.csv("D:/Data_Mining/project/dataset/race-result-race.csv", check.names=FALSE)

str(horse_result)
str(race_result)

race_result <- race_result[,5:7]

race_result<- race_result[-2]

# merging 2 dataframes 

horse_race_result <- merge(horse_result, race_result, by = "race_id", all.x = TRUE)

str(horse_race_result)

# Data Cleaning 
library(dplyr)
finishing_positions <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14")

horse_race_result <-horse_race_result %>% filter(horse_race_result$finishing_position %in% finishing_positions)

prop.table(table(droplevels(horse_race_result$finishing_position)))
prop.table(table(droplevels(horse_race_result$finishing_position)))


apply(horse_race_result, 2, function(x) any(is.na(x)))


horse_race_result <- horse_race_result %>%
  mutate_if(is.numeric, funs(ifelse(is.na(.), 0, .)))

horse_race_result$finishing_position<-droplevels(horse_race_result$finishing_position)

table(horse_race_result$result)

apply(horse_race_result, 2, function(x) any(is.na(x)))

print(table(horse_race_result$result))

# Train and test dataset preparation

set.seed(123)

horse_race_sample <- sample(29364, 23492)

str(horse_race_result)

head(horse_race_result)

horse_race_result$finishing_position <- as.integer(horse_race_result$finishing_position)

horse_race_result['result'] = ifelse(horse_race_result$finishing_position %in% c(1,2,3),"Winner","Loser")

horse_race_result$result <- as.factor(horse_race_result$result)

table(horse_race_result$result)

horse_race_result <- horse_race_result[3:21]

str(horse_race_result)

horse_position_train <- horse_race_result[horse_race_sample, ]
horse_position_test <- horse_race_result[-horse_race_sample, ]

prop.table(table(horse_position_test$result))

str(horse_position_train)

horse_position_train[-19]

# Training the Model
install.packages("C50")
library(C50)
str(horse_position_train)
posistion_model <- C5.0(horse_position_train[-19], horse_position_train$result)

plot(posistion_model)

summary(posistion_model)


# Evaluation of Model Performance

horse_position_pred <- predict(posistion_model, horse_position_test)

library(gmodels)
CrossTable(horse_position_test$result, horse_position_pred, prop.chisq = FALSE, 
           prop.c = FALSE, prop.r = FALSE, dnn = c('actual position', 'predicted position'))

# Confusion Matrix 
library(caret)
table(horse_position_pred)

confusionMatrix(horse_position_test$result, horse_position_pred)

# Improving Model Performance
position_model_boost10 <- C5.0(horse_position_train[-19], horse_position_train$result, trials = 10)

plot(position_model_boost10)

position_model_boost10

summary(position_model_boost10)

horse_position_pred_boost10 <- predict(position_model_boost10, horse_position_test)



CrossTable(horse_position_test$result, horse_position_pred_boost10, prop.chisq = FALSE, 
           prop.c = FALSE, prop.r = FALSE, dnn = c('actual position', 'predicted position'))


# Confusion Matrix 
library(caret)
confusionMatrix(horse_position_test$result, horse_position_pred_boost10)
