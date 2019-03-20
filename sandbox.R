t<-c("컴퓨터는 수치 연산을 위해 설계되었다. 컴퓨터 발명 초기에는 문자를 표현해야 하는 요구가 없었다.","그러나 곧 문자를 표현해야 하는 요구가 발생했다. 이기종 컴퓨터끼리 문자 데이터를 교환하기 위해서는 표준이 필요하다.")
t
t<-Corpus(VectorSource(t))
inspect(t)
tdmm<-TermDocumentMatrix(t,control=list(tokenize=ko.words.noun,wordLengths=c(2,Inf)))
as.matrix(tdmm)
