#참고 링크 : http://datamining.dongguk.ac.kr/lectures/2018-1/bigdata/5_tm%ED%8C%A8%ED%82%A4%EC%A7%80%EB%A5%BC_%EC%9D%B4%EC%9A%A9%ED%95%9C_%ED%85%8D%EC%8A%A4%ED%8A%B8%EB%A7%88%EC%9D%B4%EB%8B%9D.pdf


install.packages('KoNLP')
install.packages("stringr")
install.packages('tm')
useNIADic()

library(KoNLP)
library(stringr)
library(tm)

df <- read.csv('1691NOTNULL.csv',header = T,na.strings=NA,stringsAsFactors = F)
str(df)
summary(df)
colSums(is.na(df))

# df$TEXT <- trimws(df$TEXT,which="both")
# df$TITLE <- trimws(df$TITLE,which="both")
# df$POST_DATE <- trimws(df$POST_DATE, which="both")

trimws(df$TEXT[1])
#크롤링 텍스트를 .txt파일로 저장
position = "C:/Users/SHJ/PycharmProjects/new_blog/txt/"
for(i in 1:nrow(df)){
  pos = paste(position,i,'.txt',sep="")
  write.table(trimws(df$TEXT[i]),pos,
              quote=F,
              row.names=F,
              col.names=F,
              append=T,
              na='NA')
}

posts <- VCorpus(DirSource("txt",pattern="txt"))
meta(posts[[2]])
content(posts[[1]])
for(i in seq_along(posts)){
  posts[[i]]$content <- paste(posts[[i]]$content,collapse=" ")
}
posts[[1]]$content
posts <- tm_map(posts, removePunctuation)
posts[[1]]$content
posts = tm_map(posts, stripWhitespace)
posts[[1]]$content
rm_posts <- tm_map(posts, removeWords, stopwords('english'))
install.packages('SnowballC')
library(SnowballC)
rm_posts <- tm_map(rm_posts, stemDocument)

str(rm_posts[[21000]])
str(posts[[21000]])
a<-rm_posts$content
filter(rm_posts,rm_post[content])
cot <- extractNoun(a)
str(cot)

for(i in seq(length(rm_posts))){
  cot <-sapply(rm_posts[[i]]$content,extractNoun)
}
str(rm_posts)

 for(i in seq(length(rm_posts))){
  print(i)
}

noun_posts <- tm_map(rm_posts, removeWords, stopwords('Korean'))

