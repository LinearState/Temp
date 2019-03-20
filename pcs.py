import pandas as pd
import math as m


import urllib.request
import sys
import ast
import timeit

alls = pd.read_csv("alls_sentence.csv", encoding='cp949')
navers = pd.read_csv("navers_sentence.csv", encoding='cp949')
kakaos = pd.read_csv("kakaos_sentence.csv", encoding='cp949')
sks = pd.read_csv("sks_sentence.csv", encoding='cp949')
kts = pd.read_csv("kts_sentence.csv", encoding='cp949')
lgs = pd.read_csv("lgs_sentence.csv", encoding='cp949')

alld = alls.drop_duplicates(["category", "sentences"])
naverd = navers.drop_duplicates(["category", "sentences"])
kakaod = kakaos.drop_duplicates(["category", "sentences"])
skd = sks.drop_duplicates(["category", "sentences"])
ktd = kts.drop_duplicates(["category", "sentences"])
lgd = lgs.drop_duplicates(["category", "sentences"])

# print(len(alld) / 2 / 60 / 60)  # 20개 누적 46시간 (각 2.3시간)
# print(len(naverd) / 2 / 60 / 60)  # 10개 누적 5.08시간 (30분)
# print(len(kakaod) / 2 / 60 / 60)  # 10개 누적 21.5시간 (각 2시간)
# print(len(skd) / 2 / 60 / 60)  # 10개 누적 22.2시간 (각 2.2시간)
# print(len(ktd) / 2 / 60 / 60)  # 10개 누적 8.58시간 (각 1시간)
# print(len(lgd) / 2 / 60 / 60)  # 2개 누적 2.41시간 (각 1시간)

# n개로 나눈다.
def cut4(data):
    n = 4
    ds1 = m.ceil(len(data) / n * 1)
    ds2 = m.ceil(len(data) / n * 2)
    ds3 = m.ceil(len(data) / n * 3)
    ds4 = m.ceil(len(data) / n * 4)
    return [ds1, ds2, ds3, ds4]



def enc(key):
    byte = len(key.encode('utf-8'))
    nword = len(key.split())
    if byte > 14 and nword > 1:
        encText = urllib.parse.quote(key)
        return encText
    else:
        print("검색어의 길이가 너무 짧습니다."); return 0


def request(encText):
    if encText == 0:
        return {"senti_valence": "NA", "senti_score": "NA", "senti_score2": "NA", "senti_score3": "NA"}
    URL = "http://api.openhangul.com/hjlee.php?user_id=hjlee&text=" + encText
    request = urllib.request.Request(URL)
    try:
        response = urllib.request.urlopen(request)
    except:
        print("에러 발생"); return {"senti_valence": "NA", "senti_score": "NA", "senti_score2": "NA", "senti_score3": "NA"}
    rescode = response.getcode()
    if (rescode == 200):
        response_body = response.read()
        res = response_body.decode('utf-8')
        res = ast.literal_eval(res)
        #     print(res)
        return res
    else:
        print("Error Code:" + rescode)
        return {"senti_valence": "NA", "senti_score": "NA", "senti_score2": "NA", "senti_score3": "NA"}


def main(dataframe, start_num):
    dataframe["senti"] = "NA"
    dataframe["score1"] = "NA"
    dataframe["score2"] = "NA"
    dataframe["score3"] = "NA"

    for i in range(len(dataframe)):
        # k = i + start_num  # r에서 생성된 df이므로, index가 1부터 시작합니다.
        print('(', i+1, '/', len(dataframe), ')')
        start = timeit.default_timer()
        key = dataframe.iloc[i, 4]
        encText = enc(key)
        req = request(encText)
        dataframe.iloc[i, 5] = req['senti_valence']
        dataframe.iloc[i, 6] = req['senti_score']
        dataframe.iloc[i, 7] = req['senti_score2']
        dataframe.iloc[i, 8] = req['senti_score3']
        end = timeit.default_timer()
        print("응답 소요 시간 : ",end-start)
    print("결과물입니다")
    print(dataframe)

allc = cut4(alld)
naverc = cut4(naverd)
kakaoc = cut4(kakaod)
skc = cut4(skd)
ktc = cut4(ktd)
lgc = cut4(lgd)


# PC NUMBER
# 0 = 연구실(교수님) 데스크톱 ('D:\Hyungju')
# 1 = 교수님 맥북 
# 2 = 연구실(영준) 데스크톱
# 3 = 태블릿PC

def pc(pc_num):
    if pc_num==0:
        allstart=0
        naverstart=0
        kakaostart=0
        skstart=0
        ktstart=0
        lgstart=0

    else :
        allstart=allc[pc_num-1]
        naverstart=naverc[pc_num-1]
        kakaostart=kakaoc[pc_num-1]
        skstart=skc[pc_num-1]
        ktstart=ktc[pc_num-1]
        lgstart=lgc[pc_num-1]
    allend = allc[pc_num]
    naverend = naverc[pc_num]
    kakaoend = kakaoc[pc_num]
    skend = skc[pc_num]
    ktend = ktc[pc_num]
    lgend = lgc[pc_num]

    all = alld.iloc[allstart:allend,]
    naver = naverd.iloc[naverstart:naverend, ]
    kakao = kakaod.iloc[kakaostart:kakaoend, ]
    sk = skd.iloc[skstart:skend, ]
    kt = ktd.iloc[ktstart:ktend, ]
    lg = lgd.iloc[lgstart:lgend, ]

    main(all,allstart)
    main(naver,naverstart)
    main(kakao,kakaostart)
    main(sk,skstart)
    main(kt,ktstart)
    main(lg,lgstart)


pc(0)


# def testpc(pc_num):
#     test = lgd.iloc[0:20, ]
#     testc = cut4(test)
#     if pc_num==0:
#         teststart=0
#
#     else :
#         teststart=testc[pc_num-1]
#
#     testend = testc[pc_num]
#     t = test.iloc[teststart:testend,]
#     main(t,teststart)
#
# testpc(0)
# testpc(1)
# testpc(2)
# testpc(3)
