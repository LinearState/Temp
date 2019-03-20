rm(list=ls());gc()

a<-read.csv("C:\\Users\\SHJ\\PycharmProjects\\new_blog\\resultDf.csv",encoding="",stringsAsFactors = F)
alltext<-a$TEXT
summary(alltext)


Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_181')
library(KoNLP)
nrow(a)
library(rvest)
alltext<-repair_encoding(alltext)
View(alltext)

text1<-alltext[1:1000]
text1<-paste(text1,collapse=" ")
data1<-sapply(text1,extractNoun,USE.NAMES=F)
undata1<-unlist(data1)

text2<-alltext[1001:2000]
text2<-paste(text2,collapse=" ")
data2<-sapply(text2,extractNoun,USE.NAMES=F)
undata2<-unlist(data2)

text3<-alltext[2001:3000]
text3<-paste(text3,collapse=" ")
data3<-sapply(text3,extractNoun,USE.NAMES=F)
undata3<-unlist(data3)

text4<-alltext[3001:3491]
text4<-paste(text4,collapse=" ")
data4<-sapply(text4,extractNoun,USE.NAMES=F)
undata1<-unlist(data4)


undata1=filter(undata1,nchar(undata1)>=2)

undata1[2]
nchar(undata1[2])

summary(data1)

alltext<-paste(alltext,collapse=" ")


#useSejongDic()

data=sapply(alltext,extractNoun,USE.NAMES=F)
