# Read Dataset from csv file
tweets <- read.csv("D:/Data_Mining/project/dataset/TweetsNBA.csv", skip=0, check.names=FALSE,  stringsAsFactors = FALSE)

str(tweets)

# selecting text, source and language

library(dplyr)

tweets_naive_bayes <- tweets %>% 
  select(text,source,lang)
str(tweets_naive_bayes)

# text analytics only for english language

tweets_naive_bayes<- tweets_naive_bayes[(tweets_naive_bayes$lang=='en'),]

str(tweets_naive_bayes)
table(tweets_naive_bayes$lang)

# New Column name mobile_phone

tweets_naive_bayes<-mutate(tweets_naive_bayes, mobile_phone = ifelse(grepl("Twitter for Android",source),"Android",
                                                      ifelse(grepl("Twitter for iPhone",source),"iPhone","others")))

table(tweets_naive_bayes$mobile_phone)

tweets_naive_bayes<- tweets_naive_bayes[(tweets_naive_bayes$mobile_phone =="Android") | (tweets_naive_bayes$mobile_phone =="iPhone"),]

# Converting predictor column to factor

head(tweets_naive_bayes)
str(tweets_naive_bayes)

tweets_naive_bayes['mobile_phone']<- as.factor(tweets_naive_bayes$mobile_phone)

table(tweets_naive_bayes$mobile_phone)

tweets_naive_bayes <- tweets_naive_bayes[,c("text","mobile_phone")]

# Cleaning and Standardization using tm NLP package
install.packages("tm")
library(tm)
tweet_corpus <- VCorpus(VectorSource(tweets_naive_bayes$text))

print(tweet_corpus)

inspect(tweet_corpus[1:2])

as.character(tweet_corpus[[1]])

tweet_corpus_clean <- tm_map(tweet_corpus, content_transformer(tolower))
as.character(tweet_corpus_clean[[2]])

tweet_corpus_clean <- tm_map(tweet_corpus_clean, removeNumbers)
tweet_corpus_clean <- tm_map(tweet_corpus_clean, removeWords, stopwords())
tweet_corpus_clean <- tm_map(tweet_corpus_clean, removePunctuation)

as.character(tweet_corpus_clean[[2]])

#toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

#tweet_corpus_clean <- tm_map(tweet_corpus_clean, toSpace, "\n")


install.packages("SnowballC")
library(SnowballC)
tweet_corpus_clean <- tm_map(tweet_corpus_clean, stemDocument)
tweet_corpus_clean <- tm_map(tweet_corpus_clean, stripWhitespace)

tweet_dtm <- DocumentTermMatrix(tweet_corpus_clean)

tweet_dtm

# Combined method
tweet_dtm2 <- DocumentTermMatrix(tweet_corpus, control = list(tolower=TRUE, removeNumbers=TRUE, stopwords=TRUE, 
                                                             removePunctuation=TRUE, stemDocument=TRUE))

tweet_dtm2

# Train and Testing the data
# dtm train and test:
tweet_dtm_train <- tweet_dtm[1:24137,]
tweet_dtm_test <- tweet_dtm[24138:32182,]

# raw data train and test
tweet_raw_train <- tweets_naive_bayes[1:24137,]
tweet_raw_test <- tweets_naive_bayes[24138:32182,]

# corpus train and test
tweet_corpus_train <- tweet_corpus_clean[1:24137]
tweet_corpus_test <- tweet_corpus_clean[24138:32182]

prop.table(table(tweet_raw_train$mobile_phone))

prop.table(table(tweet_raw_test$mobile_phone))

# Word Cloud
install.packages("wordcloud")
library(wordcloud)
wordcloud(tweet_corpus_train, min.freq=10, random.order =FALSE)

# subset:
android<- subset(tweet_raw_train, mobile_phone == "Android")
iPhone<- subset(tweet_raw_train, mobile_phone == "iPhone")

wordcloud(android$text, max.words=40, scale = c(3, 0.5))

wordcloud(iPhone$text, max.words=40, scale = c(3, 0.5))


findFreqTerms(tweet_dtm_train, 10)

# Dictionary function
Dictionary <- function(x) {
  if( is.character(x) ) {
    return (x)
  }
  stop('x is not a character vector')
}

#  Creating dictionary with words more than 10
tweets_dict <- Dictionary(findFreqTerms(tweet_dtm_train,10))

tweets_train <- DocumentTermMatrix(tweet_corpus_train, list(dictionary=tweets_dict))
tweets_test <- DocumentTermMatrix(tweet_corpus_test, list(dictionary=tweets_dict))

tweets_test

convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1), labels = c("No", "Yes"))
  return(x)
}

tweets_train <- apply(tweets_train, MARGIN = 2, convert_counts)
tweets_test <- apply(tweets_test, MARGIN = 2, convert_counts)

#Training a model
install.packages("e1071")

library(e1071)
tweets_classifier <- naiveBayes(tweets_train, tweet_raw_train$mobile_phone)

tweets_test_pred <- predict(tweets_classifier, tweets_test)

install.packages("gmodels")
library(gmodels)
CrossTable(tweets_test_pred, tweet_raw_test$mobile_phone, 
           prop.chisq = FALSE, prop.t = FALSE,
           dnn = c('predicted','actual'))

tweets_classifier2 <- naiveBayes(tweets_train, tweet_raw_train$mobile_phone, laplace = 2)
tweets_test_pred2 <- predict(tweets_classifier2, tweets_test)

CrossTable(tweets_test_pred2, tweet_raw_test$mobile_phone, 
           prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE,
           dnn = c('predicted','actual'))


# Calculating Sensitivity, Specificity, Accuracy, F-value using Formula
sens<- 919/(919+1013)

sens

spec<- 4386/(1727+4386)
spec

acc<- (919+4386)/(919+1013+1727+4386)
acc

prec <- 919/(919+1727)
prec

f<- (2*prec*sens)/(prec+sens)
f

# predict probability for AUC ROC

predicted_prob <- predict(tweets_classifier, tweets_test, type= "raw",)

predicted_prob <- predict(tweets_classifier2, tweets_test, type= "raw",)

head(predicted_prob)

install.packages("ROCR")
library(ROCR)

# predicting iPhone as true positive probabilities
pred <- prediction(predictions = predicted_prob[,2], labels = tweet_raw_test$mobile_phone)

perf<- performance(pred, measure="tpr", x.measure = "fpr")

plot(perf, main = "ROC curve for iPhone filter", col="blue", lwd=3)
abline(a=0, b=1, lwd =2, lty=2)
perf.auc <- performance(pred, measure = "auc")

str(perf.auc)

unlist(perf.auc@y.values)
