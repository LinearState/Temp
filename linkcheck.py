import csv
from bs4 import BeautifulSoup as bs
import urllib.request
import urllib.parse
import urllib
import random
from time import sleep

headers = {'User-Agent' : 'Mozilla/5.0'}

l = open("C:\DataCuk_Project\link.csv",'r',encoding="utf-8")
link = []
csvreader = csv.reader(l)


print("for 진입")

for row in csvreader :
    row = str(row)
    row = row[2:-2]
    if row is not '':
        link.append(row)
    else : continue
print("for 탈출")

# with urllib.request.urlopen('http://blog.naver.com/nuguai?Redirect=Log&amp;logNo=221317048481')as response:
#     html = response.read()
#     soup = bs(html,'html.parser')

deleted = []
remain = []
cnt = 1

for i in link :
    rand=random.randrange(2,6)
    print(rand, "초 쉽니다.")
    sleep(rand)

    try :
        print(cnt,"번째 시행 : ",i)
        cnt=cnt+1
        # print("파싱 시작")
        i = urllib.request.Request(i,headers = headers)
        with urllib.request.urlopen(i)as response:
            html = response.read()
            soup = bs(html,'html.parser')
        # print("태그 탐색")
        test = soup.find_all("frame")
        test = str(test)
        # print("유효성판별")
        if "logNo=null" in test :
            print("삭제된 게시물")
            deleted.append(i)
        else :
            print("정상")
            remain.append(i)
    except urllib.error.URLError :
        print("에러가 발생했었따")
        continue
    except urllib.error.HTTPError as e :
        print(e.code)
    except urllib.error.URLError as e :
        print('URL_Error')

# try :
#     print("테스트 시행 : ")
#     # print("파싱 시작")
#     i = urllib.request.Request("https://hongshinpark.me/2016/04/12/%EC%98%81%ED%99%94%EB%A6%AC%EB%B7%B0-%EC%A0%9C5%EC%B9%A8%EA%B3%B5-the-5th-wave-2016/",headers = headers)
#     with urllib.request.urlopen(i)as response:
#         html = response.read()
#         soup = bs(html,'html.parser')
#         # print("태그 탐색")
#         test = soup.find_all("frame")
#         test = str(test)
#         # print("유효성판별")
#         if "logNo=null" in test :
#             print("삭제된 게시물")
#             deleted.append(i)
#         else :
#             print("정상")
#             remain.append(i)
# except urllib.error.URLError :
#     print("에러가 발생했었따")
# except urllib.error.HTTPError as e :
#     print(e.code)
# except urllib.error.URLError as e :
#     print('URL_Error')


print(deleted)
print(remain)

#프레임 클래스를 찾아 유효하지 않은 페이지 분별
# test = soup.find_all("frame")
# test = str(test)
# if "logNo=null" in test :
#     print("삭제된 게시물")
# else : print("정상")
