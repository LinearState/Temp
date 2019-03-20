import urllib.request
import pyodbc
import json
import csv

con = pyodbc.connect('DRIVER={ODBC Driver 11 for SQL Server};SERVER=.\\SQLEXPRESS;DATABASE=BLOG;UID=sa;PWD=3356')
cursor = con.cursor()

client_id = "rOwTYAzZmmNzFjaBAYxq"
client_secret = "axTJW1VE2r"

#검색어 리스트 생성
kw = open("C:\DataCuk_Project\Keywords.csv",'r',encoding="utf-8-sig")
keywords = []

csvReader = csv.reader(kw)

for row in csvReader:
    keywords.append(row)
print("우리가 검색할 것은")
print(keywords)

#전체 키워드에 대하여 반복
for i in range(len(keywords)) :
    # print(bkey[i])
    search = keywords[i]
    search = str(search)
    encText = urllib.parse.quote_plus(search)
    print(i+1,"번째 검색어 : ",search)
    #각 키워드에 대하여 1000개씩의 검색결과 저장 (네이버 API에서 허용하는 최대 갯수)
    for j in range(10) :
        start = (j*100)+1   #1, 101, 201, ... , 901부터 100개씩 긁어올 것
        display = 100

        url = "https://openapi.naver.com/v1/search/blog?query=" + encText + "&display=" + str(display) + "&start=" + str(start) #json 결과물 받아오기
        # url = "https://openapi.naver.com/v1/search/blog.xml?query=" + encText # xml 결과물 받아오기
        print(url)
        request = urllib.request.Request(url)
        request.add_header("X-Naver-Client-Id", client_id)
        request.add_header("X-Naver-Client-Secret", client_secret)
        response = urllib.request.urlopen(request)

        # tojson = response.json() #xml 출력물을 json으로 변환
        data = json.load(response)
        rescode = response.getcode()

        dlist = data['items']

        if (rescode == 200):
            # response_body = response.read()
            # print(data['items']['description'])
            for x in dlist:
                cursor.execute(
                    '''INSERT INTO  Table2(title, description, bloggername, bloggerlink, postdate, link) VALUES (?, ?, ?,?,?,?)''',
                    str(x['title']), str(x['description']), str(x['bloggername']), str(x['bloggerlink']), str(x['postdate']), str(x['link']))
                cursor.commit()

        else:
            print("Error Code:" + rescode)

cursor.close()