import pandas as pd

#필터링 함수 정의
def brand_filter(target_list, compared_list, brand):
    rs = "미분류"
    is_nc = False
    brand_match = False
    for i in target_list:
        # print("타겟 =",i)
        key=str(i)              #한 개의 비교대상을 추출
        for w in nc :
            # print("필요조건 비교쌍 : ",w,'-',key)
            if key == w :       #미리 지정해둔 필요조건을 충족하면
                # print("필요조건 충족!")
                is_nc = True    #is_nc값을 True로 변환
                rs="확인 필요"
                # t.sleep(3)

        for j in range(len(compared_list)):
            for words in compared_list[j] :
                # print("검색조건 비교쌍 : ",words,'-',key)
                if key == words:
                    temp=brand[j]
                    brand_match = True
                    # print("검색조건 충족!")
                    # t.sleep(3)
                    break  # 그리고 탈출
        # print("필요조건 충족 여부 : ",is_nc)
        # print("검색조건 충족 여부 : ",brand_match)
        if is_nc :
            if is_nc == brand_match :
                # print("2차검증:",brand_match)
                print(temp)
                rs = temp
                # t.sleep(0.3)
                return rs
        # t.sleep(5)
    return rs  #선별결과를 string로 반환

#데이터 로딩 및 결측치 제거
data=pd.read_csv("cnt_df.csv",index_col=0)
data = data[data.x0 == data.x0]
DF = data.drop('x50',axis=1)
DF.to_csv("rm_cnt.csv",mode="w")
print(DF)

#검색조건 정의
nc=['인공지능','비서','인공','지능','인공지능','자연어','음성인식','음성','인식','AI','스마트'] #하나이상 만족 공통 필요조건
naver = ['네이버프랜즈','네이버프렌즈','friends','웨이브','wave','클로바','클로버','clova','샐리']
skt = ['누구','누구스피커','NUGU','아리','아리야','아리아']
kt = ['기가지니','기가지니1','지니','기가지니2','지니2','지니야']
kakao = ['카카오미니','헤이카카오','카카오야','카카오MINI','KAKAO미니','미니']
lg = ['씽큐','하이엘지','hilg','하이lg','허브','씽큐허브']

#검색조건 search로 통합
search=[]
search.append(naver)
search.append(skt)
search.append(kt)
search.append(kakao)
search.append(lg)

#브랜드 네임택 및 결과 저장용 리스트 생성
brand = ['네이버','SKT','KT','카카오','LG']
result = []

#메인 기능 실행
for x in range(DF.shape[0]):              #모든 각 행에 대하여
    target = DF.iloc[x].tolist()          #리스트(target)로 변환한 것을 가지고
    # target = DF.iloc[x].values
    result.append(brand_filter(target,search,brand))  #브랜드 선별한다.
print(result)
print("result의 길이는:",len(result))
print("DF의 길이는:", DF.shape[0])

#기존 데이터프레임과 결합 및 결과물 확인
pd.options.mode.chained_assignment = None
DF["result"]=result
DF.to_csv("filtered.csv",mode='w')
print(DF)
nbrand = dict()
for i in brand :
    nbrand[i]=len(DF["result"==i])
print(nbrand)




