# Korean language operations 
install.packages("KoNLP", repos = "http://cran.us.r-project.org") #HannNanum
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_181')
library(KoNLP)
library(rvest)
useNIADic()

#메모리 정리
rm(list=ls());gc()

# extract Noun
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

Encoding(review.corpus)

#Daum movie reviews 
install.packages("rvest")
library(rvest)
library(tm)
memory.size()
memory.limit()
memory.limit(10000)
memory.limit()
all.reviews <- read.csv("C:\\Users\\SHJ\\PycharmProjects\\new_blog\\UTFresultDf.csv",stringsAsFactors=F,
                        encoding="CP949") 
all.reviews <- all.reviews$TEXT
head(all.reviews,1)
#all.reviews <- repair_encoding(all.reviews)
review.corpus <- Corpus(VectorSource(all.reviews))
review.corpus <- tm_map(review.corpus, stripWhitespace)
review.corpus <- tm_map(review.corpus, removeNumbers)
review.corpus <- tm_map(review.corpus, removePunctuation)
str(review.corpus)

#install.packages(c("BH","biglm")); 
#library(devtools); devtools::install_github('kaneplusplus/bigmemory',local=T)
#install.packages("bigmemory", repos="http://R-Forge.R-project.org")
#library(bigmemory)
#install.packages("biganalytics")
#library(biganalytics)
install.packages("slam")
library(slam)

options(mc.cores=1)

tdm <- TermDocumentMatrix(review.corpus,control=list(tokenize=extractNoun,wordLengths=c(2,Inf))) #korean 
Encoding(tdm$dimnames$Terms) = 'utf-8'
View(tdm)
rm(list=c('review.corpus','all.reviews'));gc()
tdm
#Encoding(tdm$dimnames$Terms)='UTF-8'
tdm<-removeSparseTerms(tdm, sparse=0.8)
tdm.matrix <- as.matrix(tdm)
dim(tdm.matrix)
#row.names(tdm.matrix)<-iconv(row.names(tdm.matrix),localeToCharset()[1],"UTF-8")
row.names(tdm.matrix)[1:100]
View(tdm)
#co-occurence matrix with Daum movie reviews 
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count,decreasing=T)
word.order[1:20]
rownames(tdm.matrix)[word.order[1:20]]
freq.words <- tdm.matrix[word.order[1:20],]
co.matrix <- freq.words %*% t(freq.words)

# visualize co-occurence matrix 
install.packages("qgraph", repos = "http://cran.us.r-project.org") #install XQuartz independently, http://www.xquartz.org for mac os 
library(qgraph)
View(co.matrix)
par(family="NanumGothic") #for mac os 
qgraph(co.matrix,diag=F,labels=rownames(co.matrix),layout="spring",edge.color="red")