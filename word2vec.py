#WORD2VEC 작업은 JUPYTER NOTEBOOK을 이용.
from gensim.models import Word2Vec
import csv
from eunjeon import Mecab
import pandas as pd
import sys
import copy

mecab = Mecab()

#브랜드별 분류
def ext(data,brand):
    d=data[data['result']==brand]
    t=d['TEXT']
    return t
#명사 추출
def get_words(data):
    li=[]
    for i in data:
        w=mecab.nouns(i)
        li.append(w)
    # print(li)
    data=li
    return data
#word2vec 임베딩
def embedding(data):
    embedding_model = Word2Vec(data, size=100, window=2, min_count=50, iter=100, workers=2, sg=1)
    return embedding_model
#유사단어 검색
def check30(embedded,keyword):
    k=keyword
    temp=embedded.most_similar(positive=[k],topn=30)
    # print(temp)
    return temp
def check20(embedded,keyword):
    k=keyword
    temp=embedded.most_similar(positive=[k],topn=20)
    # print(temp)
    return temp
def check10(embedded,keyword):
    k=keyword
    temp=embedded.most_similar(positive=[k],topn=10)
    # print(temp)
    return temp
data=pd.read_csv("resultDf3.csv",nrows=3042,index_col=0,encoding='cp949')

print("///브랜드별 분류 중...///")
all=data['TEXT']
naver=ext(data,'네이버')
kakao=ext(data,'카카오')
skt=ext(data,'SKT')
lg=ext(data,'LG')
kt=ext(data,'KT')

print("///브랜드별 단어 추출 중...///")
all = get_words(all)
naver = get_words(naver)
kakao = get_words(kakao)
skt = get_words(skt)
kt = get_words(kt)
lg = get_words(lg)

print("///추출된 단어로 word2vec 임베딩 중...///")
all_emb=embedding(all)
na_emb=embedding(naver)
ka_emb=embedding(kakao)
sk_emb=embedding(skt)
lg_emb=embedding(lg)
kt_emb=embedding(kt)
print(kt_emb)

rabelled_data=pd.read_csv('rabelled_words.csv',encoding='cp949',header=0)
print("///검색할 단어 목록 생성중...///")
key={'음성인식':[],
   '기타 편의기능':[],
   '앱-기기 연동':[],
   '디자인':[],
   '가격':[],
   '음악':[],
   '정보제공':[],
   '사운드':[],
   '휴대성':[]
   }

all_words=copy.deepcopy(key)
na_words=copy.deepcopy(key)
ka_words=copy.deepcopy(key)
sk_words=copy.deepcopy(key)
kt_words=copy.deepcopy(key)
lg_words=copy.deepcopy(key)

for i in range(len(rabelled_data)):
    categ=rabelled_data.iloc[i,0]
    words=rabelled_data.iloc[i,1]
    name=str(categ)
    key[name].append(words)

print("///검색할 단어 목록은 아래와 같음///")
for i in key :
    print(i)
    print(key[i])

print("///검색 시작///")

datalist={'전체':all_emb,
          '네이버':na_emb,
          '카카오':ka_emb,
          'SKT':sk_emb,
          'KT':kt_emb,
          'LG':lg_emb
          }

df30=pd.DataFrame(columns=['brand','category','words','emotion'])
for brand, vector in datalist.items():
    print(brand,"탐색중...")
    if brand=='전체': b=0
    elif brand=='네이버': b=1
    elif brand=='카카오': b=2
    elif brand=='SKT' : b=3
    elif brand=='KT' : b=4
    elif brand=='LG' : b=5
    for category, words in key.items():
        cnt=0
        for w in words :
            print(category, ":", cnt, "번째 요소 :", w)
            if category=='디자인':c=0
            elif category=='가격':c=1
            elif category == '사운드':c = 2
            elif category == '휴대성':c=3
            elif category =='음성인식':c=4
            elif category =='앱-기기 연동':c=5
            elif category =='음악':c=6
            elif category =='정보제공':c=7
            elif category =='기타 편의기능':c=8
            df30 = df30.append({
                "brand": b,
                "category": c,
                "words": (w, 1.0),
                "emotion": 999
            }, ignore_index=True)
            try:
                l=check30(vector,w)
                for i in l :
                    df30=df30.append({
                        "brand":b,
                        "category":c,
                        "words":i,
                        "emotion":999
                    },ignore_index=True)
            except Exception as ex:
                # print('에러가 발생했습니다.',ex)
                pass
            cnt+=1
# df30.to_csv("brand_words_df30.csv",mode='w')
# df20=pd.DataFrame(columns=['brand','category','words','emotion'])
# for brand, vector in datalist.items():
#     print(brand,"탐색중...")
#     if brand=='전체': b=0
#     elif brand=='네이버': b=1
#     elif brand=='카카오': b=2
#     elif brand=='SKT' : b=3
#     elif brand=='KT' : b=4
#     elif brand=='LG' : b=5
#     for category, words in key.items():
#         cnt=0
#         for w in words :
#             print(category, ":", cnt, "번째 요소 :", w)
#             if category=='디자인':c=0
#             elif category=='가격':c=1
#             elif category == '사운드':c = 2
#             elif category == '휴대성':c=3
#             elif category =='음성인식':c=4
#             elif category =='앱-기기 연동':c=5
#             elif category =='음악':c=6
#             elif category =='정보제공':c=7
#             elif category =='기타 편의기능':c=8
#             df20 = df20.append({
#                 "brand": b,
#                 "category": c,
#                 "words": (w, 1.0),
#                 "emotion": 999
#             }, ignore_index=True)
#             try:
#                 l=check20(vector,w)
#                 for i in l :
#                     df20=df20.append({
#                         "brand":b,
#                         "category":c,
#                         "words":i,
#                         "emotion":999
#                     },ignore_index=True)
#             except Exception as ex:
#                 print('에러가 발생했습니다.',ex)
#                 pass
#             cnt+=1
# df20.to_csv("brand_words_df20.csv",mode='w')
# df10=pd.DataFrame(columns=['brand','category','words','emotion'])
# for brand, vector in datalist.items():
#     print(brand,"탐색중...")
#     if brand=='전체': b=0
#     elif brand=='네이버': b=1
#     elif brand=='카카오': b=2
#     elif brand=='SKT' : b=3
#     elif brand=='KT' : b=4
#     elif brand=='LG' : b=5
#     for category, words in key.items():
#         cnt=0
#         for w in words :
#             print(category, ":", cnt, "번째 요소 :", w)
#             if category=='디자인':c=0
#             elif category=='가격':c=1
#             elif category == '사운드':c = 2
#             elif category == '휴대성':c=3
#             elif category =='음성인식':c=4
#             elif category =='앱-기기 연동':c=5
#             elif category =='음악':c=6
#             elif category =='정보제공':c=7
#             elif category =='기타 편의기능':c=8
#             df10 = df10.append({
#                 "brand": b,
#                 "category": c,
#                 "words": (w, 1.0),
#                 "emotion": 999
#             }, ignore_index=True)
#             try:
#                 l=check10(vector,w)
#                 for i in l :
#                     df10=df10.append({
#                         "brand":b,
#                         "category":c,
#                         "words":i,
#                         "emotion":999
#                     },ignore_index=True)
#             except Exception as ex:
#                 print('에러가 발생했습니다.',ex)
#                 pass
#             cnt+=1
# df10.to_csv("brand_words_df10.csv",mode='w')