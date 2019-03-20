getwd()
setwd("C:\\Users\\SHJ\\Downloads")
a<-read.csv("wordlist.csv",header=T,stringsAsFactors = F)
head(a)
a<-a$cnouns
head(a)
install.packages("quanteda")
library(quanteda)
??kwic
kwic(a,'라이언')
b<-read.csv('resultDf3.csv',header=T,stringsAsFactors = F)
head(b)
str(b)
summary(b)
c<-select(b,X,TEXT,result)
?select
library(dplyr)
summary(c)
kwic(review.corpus,'라이언')
reviews<-c$TEXT

View(review.corpus)

Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_181')
library(KoNLP)
library(rvest)
library(stringr)
useNIADic()

ko.words.noun <- function(doc){
  d <- as.character(doc)
  pos <- extractNoun(d)
}

# extract noun, adjective, and verb 
ko.words <- function(doc){
  d <- as.character(doc)
  pos <- paste(SimplePos22(d))
  extracted <- str_match(pos, '([가-힣]+)/[NP]')  
  keyword <- extracted[,2]
  keyword[!is.na(keyword)]
}


#Daum movie reviews 
library(rvest)
library(tm)
all.reviews<-reviews
review.corpus <- Corpus(VectorSource(all.reviews))
review.corpus <- tm_map(review.corpus, stripWhitespace)
review.corpus <- tm_map(review.corpus, removeNumbers)
review.corpus <- tm_map(review.corpus, removePunctuation)
str(review.corpus)

noun<-ko.words(review.corpus)


head(review.corpus)
