rm(list=ls());gc()
getwd()
setwd("D:\\new_blog")


b<-read.csv('resultDf3.csv',header=T,stringsAsFactors = F)

b$result <- as.factor(b$result)

if(!require(dplyr)){
  install.packages("dplyr")
}
library(dplyr)

#원문 분배
all<-b
kt<-filter(b,result=="KT")
sk<-filter(b,result=="SKT")
lg<-filter(b,result=="LG")
naver<-filter(b,result=="네이버")
kakao<-filter(b,result=="카카오")

#감사합니다. 한글찾아주는 리더기.
if(!require(devtools))install.packages("devtools")
library(devtools)
if(!require(readAny)){
  install_github("plgrmr/readAny",force=T)
};library(readAny)
if(!require(stringi))install.packages("stringi")
library(stringi)
wdtable<-read.any('brand_words_df.csv',header=TRUE,encoding = 'utf-8')
head(wdtable)

library(stringr)
wdtable$words<-gsub("[^ ㄱ-ㅣ가-힣]+","",wdtable$words)
wdtable$words<-gsub(" ","",wdtable$words)

summary(wdtable)
wdtable<-filter(wdtable,nchar(wdtable$words)>1)
wdtable<-select(wdtable,-X)
wdtable$brand<-as.factor(wdtable$brand)
wdtable$category<-as.factor(wdtable$category)
#{wdtable 자료 설명}

#BRAND Category
#0 all
#1 네이버
#2 카카오
#3 skt
#4 kt
#5 lg

#Word Category
#0 디자인
#1 가격
#2 사운드
#3 휴대성
#4 음성인식
#5 앱-기기 연동
#6 음악
#7 정보제공
#8 기타 편의기능

summary(wdtable$category)

if(!require(quanteda)){
  install.packages("quanteda")
}
library(quanteda)

finder<-function(brand,word,cat){
  temp<-kwic(brand$TEXT,word,window=5)
  rst<-paste(temp[['pre']],temp[['keyword']],temp[['post']])
  category<-rep(cat,length(rst))
  key<-rep(word,length(rst))
  sentences<-rst
  result<-data.frame(category,key,sentences)
  return(result)
}

allk<-filter(wdtable,wdtable$brand==0)
naverk<-filter(wdtable,wdtable$brand==1)
kakaok<-filter(wdtable,wdtable$brand==2)
skk<-filter(wdtable,wdtable$brand==3)
ktk<-filter(wdtable,wdtable$brand==4)
lgk<-filter(wdtable,wdtable$brand==5)

#ext<-function(brand,key_df,result){
#  cnt=1
#  temp=""
#  for(x in 1:nrow(key_df)){
#    result$word[cnt]<-key_df$words[x]
#    result$sentense[cnt]<-finder(brand,key_df$words[x])
#  }
#}
# ext<-function(brand,key_df){
#   temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
#   for(x in 1:nrow(key_df)){
#     cat<-key_df$category[x]
#     k<-key_df$words[x]
#     temp<-rbind(temp,finder(brand,k,cat))
#   }
#   return(temp)
# }
# summary(lgk)

# word<-rep(NA,10000)
# sentense<-rep(NA,10000)

# alls=data.frame(word,sentense)
# navers=data.frame(word,sentense)
# kakaos=data.frame(word,sentense)
# sks=data.frame(word,sentense)
# kts=data.frame(word,sentense)
# lgs=data.frame(word,sentense)
# summary(lg)


# all_result<-ext(all,allk)
# naver_result<-ext(naver,naverk)
# kakao_result<-ext(kakao,kakaok)
# skt_result<-ext(skt,sktk)
# kt_result<-ext(kt,ktk)
# system.time(lg_result<-ext(lg,lgk))
# View(alls)

if(!require(parallel)){
  install.packages("parallel")
};library(parallel)
if(!require(doParallel)){
  install.packages("doParallel")
};library(doParallel)
registerDoParallel(cores=8)
memory.limit()
# memory.limit(16000)
rm(b)
rm(wdtable)
?rm
gc()
ls()
# rm(list=c("kakao",'kakaok','kt','ktk','lg','lgk','naver','naverk','sk','skk'))

temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
system.time(temp<-
              foreach(x=1:nrow(allk),.combine=rbind,.packages="quanteda")%dopar%{
                cat<-allk$category[x];
                k<-allk$words[x];
                temp<-finder(all,k,cat)})
all_result<-temp
# write.csv(all_result,"all_sentence.csv")


temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
system.time(temp<-
              foreach(x=1:nrow(kakaok),.combine=rbind,.packages="quanteda")%dopar%{
                cat<-kakaok$category[x];
                k<-kakaok$words[x];
                temp<-finder(kakao,k,cat)})
kakao_result<-temp
head(kakao_result)
# write.csv(kakao_result,"kakao_sentence.csv")

# rm(list=c("all","allk","kakao","kakaok"))
# rm(list=c("kakao_result"))
temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
system.time(temp<-
              foreach(x=1:nrow(ktk),.combine=rbind,.packages="quanteda")%dopar%{
                cat<-ktk$category[x];
                k<-ktk$words[x];
                temp<-finder(kt,k,cat)})
kt_result<-temp
head(kt_result)
# write.csv(kt_result,"kt_sentence.csv")
# rm(list=c("kt","ktk","kt_result"))

temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
system.time(temp<-
              foreach(x=1:nrow(naverk),.combine=rbind,.packages="quanteda")%dopar%{
                cat<-naverk$category[x];
                k<-naverk$words[x];
                temp<-finder(naver,k,cat)})
naver_result<-temp
# write.csv(naver_result,"naver_sentence.csv")
# rm(list=c("naver","naverk","naver_result"))

temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
system.time(temp<-
              foreach(x=1:nrow(skk),.combine=rbind,.packages="quanteda")%dopar%{
                cat<-skk$category[x];
                k<-skk$words[x];
                temp<-finder(sk,k,cat)})
sk_result<-temp
# write.csv(sk_result,"sk_sentence.csv")
# rm(list=c("sk","skk","sk_result"))

temp<-data.frame(category=integer(0),key=character(0),sentences=character(0))
system.time(temp<-
              foreach(x=1:nrow(lgk),.combine=rbind,.packages="quanteda")%dopar%{
                cat<-lgk$category[x];
                k<-lgk$words[x];
                temp<-finder(lg,k,cat)})
lgt_result<-temp
lg_result<-lgt_result
# write.csv(lg_result,"lg_sentence.csv")

# setwd("C:\\Users\\SHJ\\PycharmProjects\\new_blog")
write.csv(all_result,"all_sentence.csv")
write.csv(kakao_result,"kakao_sentence.csv")
write.csv(lg_result,"lg_sentence.csv")
write.csv(kt_result,"kt_sentence.csv")
write.csv(sk_result,"sk_sentence.csv")
write.csv(naver_result,"naver_sentence.csv")

View(lg_result)
