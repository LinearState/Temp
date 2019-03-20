install.packages("tm", "SnowballC", "wordcloud", "RcolorBrewer")
install.packages("wordcloud")
install.packages("KoNLP")
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_181')
library(rJava)
library(KoNLP)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
useSejongDic()
a<-read.csv("C:\\Users\\SHJ\\PycharmProjects\\new_blog\\resultDf.txt",sep=";",header = T,na.strings=NA,stringsAsFactors = F)
View(a)
corp<-Corpus(VectorSource(a$TEXT))
corp<-tm_map(corp,PlainTextDocument)
corp<-tm_map(corp, content_transformer(tolower))

str(a$TEXT[1])
data=sapply(a$TEXT[1],extractNoun, USE.NAMES=F) #이건 잘 되는데..
t(data)
str(t(data))
func<-function(chr){
  t(sapply(chr,extractNoun,USE.NAMES = F))
}
data=sapply(a$TEXT,func) #이건 왜 안될까..?
undata<-unlist(data)

wordcloud(corp,max.words=50,min.freq=5,random.order = F,rot.per=0.1,colors=brewer.pal(8,"Dark2"))
