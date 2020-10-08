# Data from previous dataset is used
tree_horse_race_result<-horse_race_result

str(tree_horse_race_result)

# converting factors to integer and character

tree_horse_race_result$horse_name <- as.character(tree_horse_race_result$horse_name)
tree_horse_race_result$horse_id <- as.character(tree_horse_race_result$horse_id)
tree_horse_race_result$jockey <- as.character(tree_horse_race_result$jockey)
tree_horse_race_result$trainer <- as.character(tree_horse_race_result$trainer)
tree_horse_race_result$actual_weight <- as.integer(tree_horse_race_result$actual_weight)
tree_horse_race_result$declared_horse_weight <- as.integer(tree_horse_race_result$declared_horse_weight)
tree_horse_race_result$draw <- as.integer(tree_horse_race_result$draw)
tree_horse_race_result$length_behind_winner <- as.integer(tree_horse_race_result$length_behind_winner)
tree_horse_race_result$finish_time <- as.integer(tree_horse_race_result$finish_time)
tree_horse_race_result$win_odds <- as.integer(tree_horse_race_result$win_odds)

tree_horse_race_result <- tree_horse_race_result[-2:-5]


str(tree_horse_race_result)

tree_horse_race_result['result'] = as.integer(tree_horse_race_result$result)

table(tree_horse_race_result$result)


hist(tree_horse_race_result$result)

# test and train Model
nrow(tree_horse_race_result)

horse_race_sample_tree <- sample(29364, 22023)

horse_position_train_tree <- tree_horse_race_result[horse_race_sample_tree, ]
horse_position_test_tree <- tree_horse_race_result[-horse_race_sample_tree, ]

table(horse_position_test_tree$result)


head(horse_position_train_tree)

# Train and predicting the model
install.packages("rpart")
library(rpart)

tree_horse_race_result_tree <- rpart(result ~., data = horse_position_train_tree)

summary(tree_horse_race_result_tree)

# Visualize decison tree

install.packages("rpart.plot")
library(rpart.plot)
rpart.plot(tree_horse_race_result_tree, digits=3)

rpart.plot(tree_horse_race_result_tree, digits=4, fallen.leaves = TRUE, type = 3, extra = 101)

# Evaluation Model performance
tree_horse_race_result_tree_perf <- predict(tree_horse_race_result_tree, horse_position_test_tree)
summary(tree_horse_race_result_tree_perf)
summary(horse_position_test_tree$result)



table(horse_position_test_tree$result) #-8166
table(tree_horse_race_result_tree_perf) #8166

str(tree_horse_race_result_tree_perf)
str(horse_position_test_tree)

# convert the value above 1.5 to 2 to 2:
tree_horse_race_result_tree_perf<- ifelse(tree_horse_race_result_tree_perf<=1.5,1,2)


# confusion Matrix

confusionMatrix(
  factor(tree_horse_race_result_tree_perf, levels = 1:2), factor(horse_position_test_tree$result, levels = 1:2))

# Correlation
cor(tree_horse_race_result_tree_perf, horse_position_test_tree$result)

# Mean absolute error

MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

#observed MAE in rpart:
MAE(tree_horse_race_result_tree_perf, horse_position_test_tree$result)

mean(horse_position_test_tree$result)

#Actual MAE
MAE(1.152094,horse_position_test_tree$result)


library(gmodels)
CrossTable(horse_position_test_tree$result, tree_horse_race_result_tree_perf, prop.chisq = FALSE, 
           prop.c = FALSE, prop.r = FALSE, dnn = c('actual position', 'predicted position'))

confusionMatrix(horse_position_test_tree$result,tree_horse_race_result_tree_perf)


# Improve Model performance

install.packages("RWeka")
library(RWeka)

m.M5P<- M5P(result ~., data = horse_position_train_tree)

m.M5P

summary(m.M5P)
m.M5P

p.M5P <- predict(m.M5P, horse_position_test_tree)

summary(p.M5P)


cor(p.M5P, horse_position_test_tree$result)

#observed MAE in M5P:
MAE(p.M5P,horse_position_test_tree$result)

# GBM

table(horse_position_train_tree$result)

str(horse_position_train_tree)

#horse_position_train_tree_z <- as.data.frame(scale(horse_position_train_tree[,-15]))

horse_position_train_tree['result']<- ifelse(horse_position_train_tree$result==1,0,1)

library(gbm)
set.seed(1)
boost.horse_posistion <- gbm(horse_position_train_tree$result ~., data = horse_position_train_tree, distribution="bernoulli", n.trees = 5000, interaction.depth = 4)

boost.horse_posistion

summary(boost.horse_posistion)

par(mfrow =c(1,2))
plot(boost.horse_posistion ,i="length_behind_winner")
plot(boost.horse_posistion ,i="running_position_4")

yhat.boost.horse_posistion=predict (boost.horse_posistion ,newdata =horse_position_test_tree,
                    n.trees =5000)

plot(yhat.boost.horse_posistion)

str(yhat.boost.horse_posistion)

str(horse_position_test_tree$result)

# Mean Square Error - 1.000103
mean((yhat.boost.horse_posistion-horse_position_test_tree$result)^2)

# Boosting the model further
boost.horse_posistion <- gbm(result ~., data = horse_position_train_tree, distribution="bernoulli", n.trees = 5000, interaction.depth = 4, 
                             shrinkage =0.2, verbose =F, n.minobsinnode = 20)

yhat.boost.horse_posistion=predict (boost.horse_posistion ,newdata =horse_position_test_tree,
                                    n.trees =5000, type = "response")

outputDataSet = data.frame("result" = horse_position_test_tree$result,
                           "ProbabilityOfResponse" = yhat.boost.horse_posistion)

summary(boost.horse_posistion, plot= FALSE)
# Mean Square Error - 1.001649
mean((yhat.boost.horse_posistion-horse_position_test_tree$result)^2)

# MAE - 1.000553
MAE(yhat.boost.horse_posistion,horse_position_test_tree$result)

# LogLoss Binary Evaluation:
gbmWithCrossValidation = gbm(formula = result ~ .,
                             distribution = "bernoulli",
                             data = horse_position_train_tree,
                             n.trees = 5000,
                             shrinkage = .2,
                             n.minobsinnode = 200, 
                             cv.folds = 5,
                             n.cores = 1)

bestTreeForPrediction = gbm.perf(gbmWithCrossValidation)

gbmHoldoutPredictions = predict(object = gbmWithCrossValidation,
                                newdata = horse_position_train_tree,
                                n.trees = bestTreeForPrediction,
                                type = "response")


gbmHoldoutPredictions
