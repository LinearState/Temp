setwd("C:/Users/SHJ/PycharmProjects/new_blog")
a <- read.table("filtered.csv",fileEncoding = "UTF-8",header=T,stringsAsFactors = F, sep =",")
df <- read.csv('1691NOTNULL.csv',header = T,na.strings=NA,stringsAsFactors = F)
rnames<-c()
rnames<-append(rnames,paste("cnt",seq(1,21576),sep="_"))

df$X<-rnames

library(tidyverse)
#b <- select(a,-result)
#b$result<-as.factor(str_trim(a$result))
#summary(b)
#head(b)

#tt<-t(a$X)
#str(tt)
result <- select(a,c(X,result))
#View(result)

resultDf<-merge(df,result,by='X')

resultDf<-filter(resultDf,result!="확인 필요"&result!="미분류")
resultDf$result <- as.factor(resultDf$result)

#resultDf$TEXT<-gsub("[^[:alnum:]///' ]", "",resultDf$TEXT)
#resultDf$TITLE<-gsub("[^[:alnum:]///' ]", "",resultDf$TITLE)

resultDf$TEXT<-gsub("[\n]","",resultDf$TEXT)
resultDf$TEXT<-gsub(",", "",resultDf$TEXT)
resultDf$TITLE<-gsub(",", "",resultDf$TITLE)
resultDf<-filter(resultDf,!(X%in%c("cnt_14956","cnt_17116","cnt_20057","cnt_2867","cnt_6448")))

write.table(resultDf, "C:/Users/SHJ/PycharmProjects/new_blog/resultDf.txt",
            sep=",",
            encoding="UTF-8",
            row.names = F)
summary(resultDf$result)

write.csv(resultDf,"C:/Users/SHJ/PycharmProjects/new_blog/resultDf.csv",
          sep=",",
          row.names=F)
