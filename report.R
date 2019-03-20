rm(list=ls());gc()
setwd("V:\\new_blog\\sentence\\senti")

library(doParallel)
library(dplyr)
library(readAny)
library(data.table)
all0<-fread("all_senti_0.csv",header=TRUE,encoding = 'UTF-8')
all1<-fread("all_senti_1.csv",header=TRUE,encoding = 'UTF-8')
all2<-fread("all_senti_2.csv",header=TRUE,encoding = 'UTF-8')
all3<-fread("all_senti_3.csv",header=TRUE,encoding = 'UTF-8')
a<-rbind(all0,all1)
b<-rbind(all2,all3)
all<-rbind(a,b)
rm(list=c('all0','all1','all2','all3'))


kakao0<-fread("kakao_senti_0.csv",header=TRUE,encoding = 'UTF-8')
kakao1<-fread("kakao_senti_1.csv",header=TRUE,encoding = 'UTF-8')
kakao2<-fread("kakao_senti_2.csv",header=TRUE,encoding = 'UTF-8')
kakao3<-fread("kakao_senti_3.csv",header=TRUE,encoding = 'UTF-8')
a<-rbind(kakao0,kakao1)
b<-rbind(kakao2,kakao3)
kakao<-rbind(a,b)
rm(list=c('kakao0','kakao1','kakao2','kakao3'))

naver0<-fread("naver_senti_0.csv",header=TRUE,encoding = 'UTF-8')
naver1<-fread("naver_senti_1.csv",header=TRUE,encoding = 'UTF-8')
naver2<-fread("naver_senti_2.csv",header=TRUE,encoding = 'UTF-8')
naver3<-fread("naver_senti_3.csv",header=TRUE,encoding = 'UTF-8')
a<-rbind(naver0,naver1)
b<-rbind(naver2,naver3)
naver<-rbind(a,b)
rm(list=c('naver0','naver1','naver2','naver3'))

sk0<-fread("sk_senti_0.csv",header=TRUE,encoding = 'UTF-8')
sk1<-fread("sk_senti_1.csv",header=TRUE,encoding = 'UTF-8')
sk2<-fread("sk_senti_2.csv",header=TRUE,encoding = 'UTF-8')
sk3<-fread("sk_senti_3.csv",header=TRUE,encoding = 'UTF-8')
a<-rbind(sk0,sk1)
b<-rbind(sk2,sk3)
sk<-rbind(a,b)
rm(list=c('sk0','sk1','sk2','sk3'))

kt0<-fread("kt_senti_0.csv",header=TRUE,encoding = 'UTF-8')
kt1<-fread("kt_senti_1.csv",header=TRUE,encoding = 'UTF-8')
kt2<-fread("kt_senti_2.csv",header=TRUE,encoding = 'UTF-8')
kt3<-fread("kt_senti_3.csv",header=TRUE,encoding = 'UTF-8')
a<-rbind(kt0,kt1)
b<-rbind(kt2,kt3)
kt<-rbind(a,b)
rm(list=c('kt0','kt1','kt2','kt3'))

lg0<-fread("lg_senti_0.csv",header=TRUE,encoding = 'UTF-8')
lg1<-fread("lg_senti_1.csv",header=TRUE,encoding = 'UTF-8')
lg2<-fread("lg_senti_2.csv",header=TRUE,encoding = 'UTF-8')
lg3<-fread("lg_senti_3.csv",header=TRUE,encoding = 'UTF-8')
a<-rbind(lg0,lg1)
b<-rbind(lg2,lg3)
lg<-rbind(a,b)
rm(list=c('lg0','lg1','lg2','lg3'))
rm(list=c('a','b'))
gc()
memory.limit(8000)

print(nrow(all))
all<-na.omit(all)
print(nrow(all))

print(nrow(kakao))
kakao<-na.omit(kakao)
print(nrow(kakao))

print(nrow(naver))
naver<-na.omit(naver)
print(nrow(naver))

print(nrow(sk))
sk<-na.omit(sk)
print(nrow(sk))

print(nrow(kt))
kt<-na.omit(kt)
print(nrow(kt))

print(nrow(lg))
lg<-na.omit(lg)
print(nrow(lg))

all$category<-as.factor(all$category)
all$senti<-as.factor(all$senti)
kakao$category<-as.factor(kakao$category)
kakao$senti<-as.factor(kakao$senti)
naver$category<-as.factor(naver$category)
naver$senti<-as.factor(naver$senti)
sk$category<-as.factor(sk$category)
sk$senti<-as.factor(sk$senti)
kt$category<-as.factor(kt$category)
kt$senti<-as.factor(kt$senti)
lg$category<-as.factor(lg$category)
lg$senti<-as.factor(lg$senti)

all<-subset(all,select=-(V1:X))
kakao<-subset(kakao,select=-(V1:X))
naver<-subset(naver,select=-(V1:X))
sk<-subset(sk,select=-(V1:X))
kt<-subset(kt,select=-(V1:X))
lg<-subset(lg,select=-(V1:X))

summary(all)
prop.table(table(all$category))*100

"
0디자인
1가격
2사운드
3휴대성
4음성인식
5앱-기기 연동
6음악
7정보제공
8기타 편의기능
"
library(plyr)

all$category<-mapvalues(all$category,from=c('0','1','2','3','4','5','6','7','8'),
                            to=c('디자인','가격','사운드','휴대성','음성인식','앱-기기연동','음악','정보제공','기타편의기능'))
kakao$category<-mapvalues(kakao$category,from=c('0','1','2','3','4','5','6','7','8'),
                        to=c('디자인','가격','사운드','휴대성','음성인식','앱-기기연동','음악','정보제공','기타편의기능'))
naver$category<-mapvalues(naver$category,from=c('0','1','2','3','4','5','6','7','8'),
                        to=c('디자인','가격','사운드','휴대성','음성인식','앱-기기연동','음악','정보제공','기타편의기능'))
sk$category<-mapvalues(sk$category,from=c('0','1','2','3','4','5','6','7','8'),
                        to=c('디자인','가격','사운드','휴대성','음성인식','앱-기기연동','음악','정보제공','기타편의기능'))
kt$category<-mapvalues(kt$category,from=c('0','1','2','3','4','5','6','7','8'),
                        to=c('디자인','가격','사운드','휴대성','음성인식','앱-기기연동','음악','정보제공','기타편의기능'))
lg$category<-mapvalues(lg$category,from=c('0','1','2','3','4','5','6','7','8'),
                        to=c('디자인','가격','사운드','휴대성','음성인식','앱-기기연동','음악','정보제공','기타편의기능'))

# c(lg)a<-function(df){
#   a<-prop.table(table(df$senti))*100
#   print(a[1:2])
#   b<-a[1]+a[2]
#   print(b)
# }
# c(all)
# c(kakao)
# c(naver)
# c(sk)
# c(kt)


func<-function(df,brand){
  t<-prop.table(table(df$category))
  t<-as.data.table(t)
  colnames(t)<-c("category","value")
  brand<-rep(brand,nrow(t))
  n<-max(length(t),length(brand))
  # if(nrow(t)<n){
  #   category
  # }
  # t(rbind.fill.matrix(matrix(x,nrow=1),matrix(y,nrow=1))) 
  # result <- t(rbind.fill.matrix(t(matrix(brand,nrow=1)),t(matrix(t,nrow=2))))
  result<-cbind(brand,t)
  return(result)
}
q<-func(all,"ALL")
w<-func(kakao,"KAKAO")
e<-func(naver,'NAVER')
r<-func(sk,'SK')
a<-func(kt,'KT')
s<-func(lg,'LG')
print(prop.table(table(lg$category)))
View(s)
print(s)
head(s)
class(q)
tmp<-rbind(q,w,e,r,a,s)
View(tmp)

cr <- function(brand, cat){
  ratio <- nrow(brand[category==cat])/nrow(brand)
  return(ratio)
}


library(ggplot2)
ce<-ddply(tmp,"brand",transform,percent=value/sum(value))
ggplot(ce,aes(x=brand,y=percent,fill=category))+geom_bar(stat='identity')

all_polar<-filter(all, senti!="중립")
kakao_polar<-filter(kakao, senti!="중립")
naver_polar<-filter(naver, senti!="중립")
sk_polar<-filter(sk, senti!="중립")
kt_polar<-filter(kt, senti!="중립")
lg_polar<-filter(lg, senti!="중립")

#주성분 분석을 위해 senti값을 숫자로 변환해준다.
all_polar$senti<-mapvalues(all_polar$senti,from=c('긍정','부정','중립'),
                        to=c(1,0,NA))
kakao_polar$senti<-mapvalues(kakao_polar$senti,from=c('긍정','부정','중립'),
                           to=c(1,0,NA))
naver_polar$senti<-mapvalues(naver_polar$senti,from=c('긍정','부정','중립'),
                           to=c(1,0,NA))
sk_polar$senti<-mapvalues(sk_polar$senti,from=c('긍정','부정','중립'),
                           to=c(1,0,NA))
kt_polar$senti<-mapvalues(kt_polar$senti,from=c('긍정','부정','중립'),
                           to=c(1,0,NA))
lg_polar$senti<-mapvalues(lg_polar$senti,from=c('긍정','부정','중립'),
                           to=c(1,0,NA))
#R에서 factor를 numeric으로 변환하기 위해서는 character로 변환하는 중간과정이 필요.
all_polar$senti<-as.numeric(as.character(all_polar$senti))
kakao_polar$senti<-as.numeric(as.character(kakao_polar$senti))
naver_polar$senti<-as.numeric(as.character(naver_polar$senti))
sk_polar$senti<-as.numeric(as.character(sk_polar$senti))
kt_polar$senti<-as.numeric(as.character(kt_polar$senti))
lg_polar$senti<-as.numeric(as.character(lg_polar$senti))

brand=rep("kakao",nrow(kakao_polar))
kakao_polar<-cbind(brand,kakao_polar)
brand=rep("naver",nrow(naver_polar))
naver_polar<-cbind(brand,naver_polar)
brand=rep("sk",nrow(sk_polar))
sk_polar<-cbind(brand,sk_polar)
brand=rep("kt",nrow(kt_polar))
kt_polar<-cbind(brand,kt_polar)
brand=rep("lg",nrow(lg_polar))
lg_polar<-cbind(brand,lg_polar)


#####################

all_score<-group_by(all_polar,category)%>%
  transmute(senti=mean(senti))
all_score<-distinct(all_score)
all_score<-as.data.frame(all_score)

kakao_score<-group_by(kakao_polar,category)%>%
  transmute(senti=mean(senti))
kakao_score<-distinct(kakao_score)
kakao_score<-as.data.frame(kakao_score)

naver_score<-group_by(naver_polar,category)%>%
  transmute(senti=mean(senti))
naver_score<-distinct(naver_score)
naver_score<-as.data.frame(naver_score)

sk_score<-group_by(sk_polar,category)%>%
  transmute(senti=mean(senti))
sk_score<-distinct(sk_score)
sk_score<-as.data.frame(sk_score)

kt_score<-group_by(kt_polar,category)%>%
  transmute(senti=mean(senti))
kt_score<-distinct(kt_score)
kt_score<-as.data.frame(kt_score)

lg_score<-group_by(lg_polar,category)%>%
  transmute(senti=mean(senti))
lg_score<-distinct(lg_score)
lg_score<-as.data.frame(lg_score)


# category="평균"
# 
# senti=mean(all_polar$senti)
# new<-data.frame(category,senti)
# all_score<-rbind(all_score,new)
# 
# senti=mean(kakao_polar$senti)
# new<-data.frame(category,senti)
# kakao_score<-rbind(kakao_score,new)
# 
# senti=mean(naver_polar$senti)
# new<-data.frame(category,senti)
# naver_score<-rbind(naver_score,new)
# 
# senti=mean(sk_polar$senti)
# new<-data.frame(category,senti)
# sk_score<-rbind(sk_score,new)
# 
# senti=mean(kt_polar$senti)
# new<-data.frame(category,senti)
# kt_score<-rbind(kt_score,new)
# 
# senti=mean(lg_polar$senti)
# new<-data.frame(category,senti)
# lg_score<-rbind(lg_score,new)


all_score<-as_tibble(all_score)
kakao_score<-as_tibble(kakao_score)
naver_score<-as_tibble(naver_score)
sk_score<-as_tibble(sk_score)
kt_score<-as_tibble(kt_score)
lg_score<-as_tibble(lg_score)

tall<-t(all_score)
colnames(tall)<-tall[1,]
tall<-tall[2,]
tkakao<-t(kakao_score)
colnames(tkakao)<-tkakao[1,]
tkakao<-tkakao[2,]
tnaver<-t(naver_score)
colnames(tnaver)<-tnaver[1,]
tnaver<-tnaver[2,]
tsk<-t(sk_score)
colnames(tsk)<-tsk[1,]
tsk<-tsk[2,]
tkt<-t(kt_score)
colnames(tkt)<-tkt[1,]
tkt<-tkt[2,]
tlg<-t(lg_score)
colnames(tlg)<-tlg[1,]
tlg<-tlg[2,]
#Transposed LG의 결측값을 NA로 대체하고, 인덱스 정렬.
tlg<-c(tlg[1],tlg[2],tlg[3],tlg[4],"NA",tlg[5],tlg[6],"NA","NA")
names(tlg)<-names(tall)

temp<-rbind(tall,tkakao)
temp<-rbind(temp,tnaver)
temp<-rbind(temp,tsk)
temp<-rbind(temp,tkt)
temp<-rbind(temp,tlg)
# rownames(temp)<-c("all","kakao","naver","sk","kt","lg")
rownames(temp)<-c("all","kakao","naver","sk","kt","lg")

brand.mean.all<-temp

library(gplots)
library(RColorBrewer)
storage.mode(brand.mean.all)<-"numeric"
# brand.mean<-brand.mean[2:6,]
brand.mean<-brand.mean.all[2:6,]

test<-as.data.frame(brand.mean)
test$ratio1=c(cr(kakao,'음성인식'),cr(naver,'음성인식'),cr(sk,'음성인식'),cr(kt,'음성인식'),cr(lg,'음성인식'))
test$ratio2=c(cr(kakao,'기타편의기능'),cr(naver,'기타편의기능'),cr(sk,'기타편의기능'),cr(kt,'기타편의기능'),cr(lg,'기타편의기능'))
test$ratio3=c(cr(kakao,'앱-기기연동'),cr(naver,'앱-기기연동'),cr(sk,'앱-기기연동'),cr(kt,'앱-기기연동'),cr(lg,'앱-기기연동'))
test$ratio4=c(cr(kakao,'디자인'),cr(naver,'디자인'),cr(sk,'디자인'),cr(kt,'디자인'),cr(lg,'디자인'))
test$ratio5=c(cr(kakao,'가격'),cr(naver,'가격'),cr(sk,'가격'),cr(kt,'가격'),cr(lg,'가격'))
test$ratio6=c(cr(kakao,'음악'),cr(naver,'음악'),cr(sk,'음악'),cr(kt,'음악'),cr(lg,'음악'))
test$ratio7=c(cr(kakao,'정보제공'),cr(naver,'정보제공'),cr(sk,'정보제공'),cr(kt,'정보제공'),cr(lg,'정보제공'))
test$ratio8=c(cr(kakao,'사운드'),cr(naver,'사운드'),cr(sk,'사운드'),cr(kt,'사운드'),cr(lg,'사운드'))
test$ratio9=c(cr(kakao,'휴대성'),cr(naver,'휴대성'),cr(sk,'휴대성'),cr(kt,'휴대성'),cr(lg,'휴대성'))
plot(음성인식~ratio1,data=test,xlim=c(0.05,0.2),ylim=c(0.7,0.85),col=as.factor(rownames(test)))
text(음성인식~ratio1,data=test,label=rownames(test),cex=1,pos=2)

plot(기타편의기능~ratio2,data=test,xlim=c(0.07,0.2),ylim=c(0.7,0.85),col=as.factor(rownames(test)))
text(기타편의기능~ratio2,data=test,label=rownames(test),cex=1,pos=2)

colnames(test)[3]="앱기기연동"
plot(앱기기연동~ratio3,data=test,xlim=c(0.1,0.2),ylim=c(0.7,0.85),col=as.factor(rownames(test)))
text(앱기기연동~ratio3,data=test,label=rownames(test),cex=1,pos=2)

plot(디자인~ratio4,data=test,xlim=c(0.1,0.17),ylim=c(0.73,0.85),col=as.factor(rownames(test)))
text(디자인~ratio4,data=test,label=rownames(test),cex=1,pos=2)

plot(가격~ratio5,data=test,xlim=c(0.03,0.1),ylim=c(0.7,0.85),col=as.factor(rownames(test)))
text(가격~ratio5,data=test,label=rownames(test),cex=1,pos=2)

plot(음악~ratio6,data=test,xlim=c(0.06,0.11),ylim=c(0.7,0.9),col=as.factor(rownames(test)))
text(음악~ratio6,data=test,label=rownames(test),cex=1,pos=2)

plot(정보제공~ratio7,data=test,xlim=c(0.1,0.2),ylim=c(0.73,0.83),col=as.factor(rownames(test)))
text(정보제공~ratio7,data=test,label=rownames(test),cex=1,pos=2)

plot(사운드~ratio8,data=test,xlim=c(0.06,0.1),ylim=c(0.7,0.8),col=as.factor(rownames(test)))
text(사운드~ratio8,data=test,label=rownames(test),cex=1,pos=2)

plot(휴대성~ratio9,data=test,xlim=c(0.02,0.06),ylim=c(0,1),col=as.factor(rownames(test)))
text(휴대성~ratio9,data=test,label=rownames(test),cex=1,pos=2)



heatmap.2(as.matrix(brand.mean),
          cellnote=round(as.matrix(brand.mean),3),
          notecex=3.0,
          notecol="black",
          col=brewer.pal(9,"GnBu"),
          trace='none',key=FALSE,
          dend='none',
          main="\n\n\n\n\nBrand Attributes")#색이 진할수록 높은 평점
??heatmap.2

#결측치로 인해 LG는 분석에서 제외
brand.mean = brand.mean.all[2:5,]
brand.mu.pc<-prcomp(brand.mean,scale=F)
summary(brand.mu.pc)
biplot(brand.mu.pc,main="Brand Positioning",cex=c(2,0.7))

screeplot(brand.mu.pc,type="line",main='Scree Plot')

library(caret)
load = brand.mu.pc$rotation
sorted.loadings1 = load[order(load[,1]),1]
sorted.loadings2 = load[order(load[,1]),2]
xlabs = "Variable Loadings"
par(new=F)
dotplot(sorted.loadings1,main="Loaings Plot for PC1",xlab=xlabs,cex=1.5,col="red",xlim=c(-1,1))
dotplot(sorted.loadings2,main="Loaings Plot for PC2",xlab=xlabs,cex=1.5,col="red",xlim=c(-1,1))

summary(brand.mu.pc)
biplot(brand.mu.pc,main="Brand Positioning",cex=c(2,0.7))
print(brand.mu.pc)


#Apply the Varimax Rotation
brand.mu.va = varimax(brand.mu.pc$rotation[,1:3])

print(brand.mu.va)
biplot(brand.mu.va$loadings)

install.packages('psych')
library(psych)
brand.mu.va <- principal(brand.mean,nfactors=5,rotate='varimax')
brand.mu.va
biplot(brand.mu.va,cex=c(2,0.7))
