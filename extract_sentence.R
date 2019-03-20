rm(list=ls());gc()
setwd("d:/new_blog")

library(doParallel)

library(readAny)
alls<-read.any("all_sentence.csv",header=TRUE,encoding = 'utf-8')
lgs<-read.any("lg_sentence.csv",header=TRUE,encoding = 'utf-8')
sks<-read.any("sk_sentence.csv",header=TRUE,encoding = 'utf-8')
kts<-read.any("kt_sentence.csv",header=TRUE,encoding = 'utf-8')
kakaos<-read.any("kakao_sentence.csv",header=TRUE,encoding = 'utf-8')
navers<-read.any("naver_sentence.csv",header=TRUE,encoding = 'utf-8')
alls$key<-as.character(alls$key)
alls$sentences<-as.character(alls$sentences)
lgs$key<-as.character(lgs$key)
lgs$sentences<-as.character(lgs$sentences)
kts$key<-as.character(kts$key)
kts$sentences<-as.character(kts$sentences)
sks$key<-as.character(sks$key)
sks$sentences<-as.character(sks$sentences)
navers$key<-as.character(navers$key)
navers$sentences<-as.character(navers$sentences)
kakaos$key<-as.character(kakaos$key)
kakaos$sentences<-as.character(kakaos$sentences)
gc()
memory.limit()
# memory.limit(8000)
head(alls['sentences'])

extraction<-function(key,text){
  splited<-strsplit(text,split="\\.|\\!|\\?|~")[[1]]
  sentense<-splited[grep(key,splited)[1]]
  return(trimws(sentense))
}
# 
# main<-function(dt){
#   system.time(temp<-
#                 foreach(x=1:nrow(dt),.combine=c)%dopar%{
#                   text<-dt$sentences[x];
#                   key<-dt$key[x];
#                   temp<-extraction(key,text)
#                 })
#   return(temp)
# }
# main(alls[c(1:5),])
registerDoParallel(cores=6)


system.time(temp<-
              foreach(x=1:nrow(alls),.combine=c)%dopar%{
                text<-alls$sentences[x];
                key<-alls$key[x];
                temp<-extraction(key,text)
              })
alls$sentences<-temp[1:length(temp)]
write.csv(alls,"alls_sentence.csv")

system.time(temp<-
              foreach(x=1:nrow(sks),.combine=c)%dopar%{
                text<-sks$sentences[x];
                key<-sks$key[x];
                temp<-extraction(key,text)
              })
sks$sentences<-temp[1:length(temp)]
write.csv(sks,"sks_sentence.csv")
system.time(temp<-
              foreach(x=1:nrow(kts),.combine=c)%dopar%{
                text<-kts$sentences[x];
                key<-kts$key[x];
                temp<-extraction(key,text)
              })
kts$sentences<-temp[1:length(temp)]
write.csv(kts,"kts_sentence.csv")
system.time(temp<-
              foreach(x=1:nrow(lgs),.combine=c)%dopar%{
                text<-lgs$sentences[x];
                key<-lgs$key[x];
                temp<-extraction(key,text)
              })
lgs$sentences<-temp[1:length(temp)]
write.csv(lgs,"lgs_sentence.csv")

system.time(temp<-
              foreach(x=1:nrow(kakaos),.combine=c)%dopar%{
                text<-kakaos$sentences[x];
                key<-kakaos$key[x];
                temp<-extraction(key,text)
              })
kakaos$sentences<-temp[1:length(temp)]
write.csv(kakaos,"kakaos_sentence.csv")
system.time(temp<-
              foreach(x=1:nrow(navers),.combine=c)%dopar%{
                text<-navers$sentences[x];
                key<-navers$key[x];
                temp<-extraction(key,text)
              })
navers$sentences<-temp[1:length(temp)]
write.csv(navers,"navers_sentence.csv")

print("ëª¨ë“  ?ž‘?—…?´ ??‚¬?Šµ?‹ˆ?‹¤. PCë¥? ì¢…ë£Œ?•˜?…”?„ ì¢‹ìŠµ?‹ˆ?‹¤.")
