library(dplyr)
rm(list=ls());gc()
setwd("C://Users//SHJ//Downloads")
a<-read.csv('word1000.csv',header=T,stringsAsFactors = F)

atf<-a$tf
atfidf<-a$tfidf

under2cutter<-function(data){
  temp<-nchar(data)>=2&nchar(data)<10
  data[temp]
}

atf<-Filter(function(x){nchar(x)>=2&nchar(x)<10}, atf)
atfidf<-Filter(function(x){nchar(x)>=2&nchar(x)<10}, atfidf)
wordlist<-c(atf,atfidf)


Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_181')
library(KoNLP)
library(stringr)
useNIADic()

extract.words <- function(doc){
  d <- as.character(doc)
  pos <- paste(SimplePos22(d))
  extracted1 <- str_match(pos, '([가-힣]+)/[NC]')
  extracted2 <- str_match(pos, '([가-힣]+)/[PA]')
  extracted3 <- str_match(pos, '([a-zA-Z]+)/[NC]')
  extracted <- c(extracted1[,2], extracted2[,2], extracted3[,2])
  extracted[!is.na(extracted)]
}

tiny.words<-function(x){
  x[grepl("nugu",x)]<-"누구"
  x[grepl("ai",x)]<-"인공지능"
  x[grepl("미니",x)]<-"카카오미니"
  x[grepl("음성",x)]<-"음성인식"
  x[grepl("인식",x)]<-"음성인식"
  x[grepl("스마트씽큐",x)]<-"씽큐"
  x[]
  x
}

mergeUserDic(data.frame(c("인공지능","ai","블루투스","스피커","nugu","NUGU","스마트","멜론","아리"),rep("ncn")))
addchar<-"가"
addword<-paste(wordlist,addchar,sep="")
nouns<-extract.words(addword)
View(nouns)
cnouns<-under2cutter(nouns)
str(cnouns)
cnouns<-tiny.words(cnouns)
duptable<-data.frame(table(cnouns))

library(plyr)
duptable<-duptable[order(-duptable$Freq),]
View(duptable)
write.csv(duptable,"wordlist.csv")

pos<-addword
extracted1 <- str_match(pos, '([가-힣]+)/[NC]')
extracted2 <- str_match(pos, '([가-힣]+)/[PA]')
extracted3 <- str_match(pos, '([a-zA-Z]+)/[NC]')
extracted <- c(extracted1[,2], extracted2[,2], extracted3[,2])
View(extracted)
