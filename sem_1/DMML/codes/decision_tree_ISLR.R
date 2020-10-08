install.packages("tree")
install.packages("ISLR")
library(tree)
library(ISLR)

# Reuse the data from decision tree 
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

str(tree_horse_race_result)
# Building basic tree 

tree_horse_race_result_1 <- tree(finishing_position ~., tree_horse_race_result)
summary(tree_horse_race_result_1)
plot(tree_horse_race_result_1)
text(tree_horse_race_result_1, pretty = 1)
tree_horse_race_result_1

set.seed(2)

# test and train Model
# Before Pruning
horse_race_sample <- sample(29364, 23492)

horse_position_train_tree <- tree_horse_race_result[horse_race_sample, ]
horse_position_test_tree <- tree_horse_race_result[-horse_race_sample, ]


tree_horse_race_result_2 <- tree(finishing_position ~., horse_position_train_tree)

summary(tree_horse_race_result_2)

tree_predict <- predict(tree_horse_race_result_2, horse_position_test_tree, type = "class" )

table(tree_predict, horse_position_test_tree$finishing_position)

# Pruning Process
set.seed(3)
cv.tree_horse_race_result_1 =cv.tree(tree_horse_race_result_1 ,FUN=prune.misclass )
names(cv.tree_horse_race_result_1)

cv.tree_horse_race_result_1

par(mfrow =c(1,2))
plot(cv.tree_horse_race_result_1$size, cv.tree_horse_race_result_1$dev, type="b")

plot(cv.tree_horse_race_result_1$k, cv.tree_horse_race_result_1$dev, type="b")

prune.tree_horse_race_result_1 = prune.misclass(tree_horse_race_result_2, best = 9)
plot(prune.tree_horse_race_result_1)
text(prune.tree_horse_race_result_1, pretty = 0)

tree_predict_prune <- predict(prune.tree_horse_race_result_1, horse_position_test_tree, type = "class" )
table(tree_predict_prune, horse_position_test_tree$finishing_position)

