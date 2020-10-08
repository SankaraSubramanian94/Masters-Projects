# Read Dataset from csv file
nhl_data <- read.csv("D:/Data_Mining/project/dataset/NHL.csv", skip=0, check.names=FALSE,  stringsAsFactors = FALSE)
head(nhl_data)

str(nhl_data)
nrow(nhl_data)
table(nhl_data$decision)


nhl_data<-nhl_data[!nhl_data$decision=="",]

head(nhl_data)

nhl_data[is.na(nhl_data)]<- 0

nrow(nhl_data)

table(nhl_data$decision)

# For Each Game_Id Decision should contains both L and W:

library(dplyr)
nhl_data_filter<-nhl_data %>% group_by(game_id)%>% filter(n()>2)

nhl_data<-nhl_data[!nhl_data$game_id %in% nhl_data_filter$game_id,]

nhl_data['decision'] <- as.factor(nhl_data$decision)
nrow(nhl_data)

# check for the normalization

round(prop.table(table(nhl_data$decision))*100, digits =1)

summary(nhl_data[c("game_id","player_id","team_id","timeOnIce","assists","goals","pim","shots","saves","powerPlaySaves",
                   "shortHandedSaves","evenSaves","shortHandedShotsAgainst", "evenShotsAgainst","powerPlayShotsAgainst",
                   "savePercentage","powerPlaySavePercentage","evenStrengthSavePercentage")])

# Normalize the data:

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

nhl_data_n<-as.data.frame(lapply(nhl_data[,-16], normalize))
summary(nhl_data_n$powerPlaySaves)

# Data Preparation
nhl_data_train <- nhl_data_n[1:18292,]
nhl_data_test <- nhl_data_n[18293:22866,]

nrow(nhl_data_train)
nrow(nhl_data_test)

# Labels
nhl_data_train_labels <-nhl_data[1:18292, 16]
nhl_data_test_labels <-nhl_data[18293:22866, 16]

str(nhl_data_test_labels)

table(nhl_data_test_labels)
table(nhl_data_train_labels)

# training a model
install.packages("class")
library(class)

# Assumption 1) k=10 - 0.67
nhl_data_test_pred<- knn(train = nhl_data_train, test = nhl_data_test, cl = nhl_data_train_labels, k=10, prob = TRUE)

# Evaluation of Model Performace
install.packages("gmodels")

library(gmodels)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred, prop.chisq = FALSE)


  # Assumption 2) k =135 - 0.67

nhl_data_test_pred2<- knn(train = nhl_data_train, test = nhl_data_test, cl = nhl_data_train_labels, k=135, prob = TRUE)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred2, prop.chisq = FALSE)

# Assumption 2) k =151 - 0.67

nhl_data_test_pred2<- knn(train = nhl_data_train, test = nhl_data_test, cl = nhl_data_train_labels, k=151, prob = TRUE)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred2, prop.chisq = FALSE)

# Assumption 3) k =5 - 0.641

nhl_data_test_pred3<- knn(train = nhl_data_train, test = nhl_data_test, cl = nhl_data_train_labels, k=5, prob = TRUE)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred3, prop.chisq = FALSE)

# Assumption 4) k =100 - 0.68

nhl_data_test_pred3<- knn(train = nhl_data_train, test = nhl_data_test, cl = nhl_data_train_labels, k=100, prob = TRUE)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred3, prop.chisq = FALSE)

# Assumption 4) k =200 - 0.67

nhl_data_test_pred3<- knn(train = nhl_data_train, test = nhl_data_test, cl = nhl_data_train_labels, k=200, prob = TRUE)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred3, prop.chisq = FALSE)

# Usage of z-score normalization

nhl_data_z <- as.data.frame(scale(nhl_data[,-16]))


summary(nhl_data_z$powerPlaySaves)

# Data Prepartion
nhl_data_train_z <- nhl_data_z[1:18292,]
nhl_data_test_z <- nhl_data_z[18293:22866,]

# Assumption 1) k=10 - 0.72
nhl_data_test_pred_z <- knn(train = nhl_data_train_z, test = nhl_data_test_z, cl = nhl_data_train_labels, k=10)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred_z, prop.chisq = FALSE)

# Assumption 2) k =135 - 0.73
nhl_data_test_pred_z2 <- knn(train = nhl_data_train_z, test = nhl_data_test_z, cl = nhl_data_train_labels, k=135)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred_z2, prop.chisq = FALSE)

# Assumption 2) k =151 - 0.74
nhl_data_test_pred_z2 <- knn(train = nhl_data_train_z, test = nhl_data_test_z, cl = nhl_data_train_labels, k=151)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred_z2, prop.chisq = FALSE)
accuracy_151<- (1542+1823)/4574
accuracy_151

# Assumption 3) k =5 - 0.70
nhl_data_test_pred_z3 <- knn(train = nhl_data_train_z, test = nhl_data_test_z, cl = nhl_data_train_labels, k=5)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred_z3, prop.chisq = FALSE)

# Assumption 4) k =100 - 0.73
nhl_data_test_pred_z4 <- knn(train = nhl_data_train_z, test = nhl_data_test_z, cl = nhl_data_train_labels, k=100)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred_z4, prop.chisq = FALSE)

# Assumption 5) k =200 - 0.74
nhl_data_test_pred_z5 <- knn(train = nhl_data_train_z, test = nhl_data_test_z, cl = nhl_data_train_labels, k=200)
CrossTable(x= nhl_data_test_labels, y= nhl_data_test_pred_z5, prop.chisq = FALSE)

