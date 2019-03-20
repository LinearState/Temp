from selenium import webdriver

import csv
import re
from bs4 import BeautifulSoup as bs
import urllib.request
import urllib.parse
import urllib
import random
from time import sleep
import requests
import pyodbc


#url이 정상적이면, html을 반환합니다.
def get_html(url):
    _html = ""
    resp = requests.get(url)
    if resp.status_code == 200:
        _html = resp.text
    return _html

#int1과 int2 사이의 임의의 숫자만큼 쉽니다.
def nap(int1,int2):
    rand=random.randrange(int1,int2)
    sleep(rand)
    print(rand,'초 쉽니다.')

#태그를 제거합니다.
def remove_tag(content):
   cleanr =re.compile('<.*?>')
   cleantext = re.sub(cleanr, '', content)
   return cleantext

#삭제하고자 하는 블로거의 id와 logNo를 받아 url로 변환합니다.
def naver_url(id,logNo) :
    url = 'https://blog.naver.com/PostView.nhn?blogId=' + id + '&logNo=' + logNo
    return url

#list 내에 찾고자 하는 모든 원소들의 위치를 list형식으로 반환합니다.
def all_index(list,search) :
    dup=[]
    for i in range(0,len(list)):
        try:
            ls = list[i:len(list)]
            dup_index = ls.index(search)
            if (not dup_index):
                dup.append(dup_index + i)
        except:
            continue
    return dup

#list에서 delete를 값으로 하는 원소를 모두 제거합니다.
def delete_all(list, delete):
    for i in range(len(all_index(list,delete))):
        list.remove(delete)
    print(len(all_index(list,delete)),'개의 원소가 삭제되었습니다.')
    return list

#크롬드라이버 옵션(Headless)
opt = webdriver.ChromeOptions()
opt.add_argument('headless')
opt.add_argument('window-size=1920x1080')
opt.add_argument('disable-gpu')
opt.add_argument("user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36")
opt.add_argument("lang=ko_KR")
#크롬드라이버 실행
driver = webdriver.Chrome('C:\\Users\\SHJ\Downloads\\chromedriver.exe', chrome_options=opt)



l = open("C:\DataCuk_Project\dup_removed_naver_table2.csv",'r',encoding="utf-8-sig")
link = [] #API로 수집된 링크, 접근 불가능
csvreader = csv.reader(l)

print("... csv에서 목록을 생성하는 중 ...")
for row in csvreader :
    row = str(row)
    # print(row)
    row = row[2:-2]
    if row is not '':
        link.append(row)
    else : continue
print("/////목록 생성 완료/////")

id = ''
logNo = ''
url = ''
# re_ link = 접속 가능한 형태로 가공된 링크
re_link = []

print("... 링크를 변경하는 중 ...")
for row in link :
    for i in re. finditer('Redirect',row):
        id = row[22:i.start()-1]
    for w in re.finditer('logNo=',row):
        logNo = row[w.end():]
    url = naver_url(id,logNo)
    re_link.append(url)
print("/////링크 변경 완료/////")




re_link=delete_all(re_link,naver_url('countryman10','221242779161'))

driver.get('about:blank')
driver.execute_script("Object.defineProperty(navigator, 'plugins', {get: function() {return[1, 2, 3, 4, 5];},});")
driver.implicitly_wait(3)
driver.get('http://naver.com')
driver.quit()

cnt=1
for i in re_link :
    nap(2,5)
    print(cnt,"번째 시행 : ",i)
    URL = i
    html = get_html(URL)
    soup = bs(html, 'html.parser')
    post_area = soup.findAll("div", {'class':'se_component se_paragraph default'})
    if(post_area!=[]): #스마트에디터3 아님
        print('BLOG TYPE : NOT SE3')
        for i in post_area :
            try:
                # text_soup = i.select('p > span')
                text_soup = i.select('p')
                #태그 제거
                cleantext=remove_tag(str(text_soup))
                print(cleantext)
            except:
                print('문제발생')
                continue
    elif(post_area==[]) : #스마트에디터3
        print('BLOG TYPE : 스마트에디터3')
        post_area=soup.findAll('div',{'id':'postViewArea'})
        for i in post_area:
            try:
                select = 'p > span'
                text_soup = i.select(select)
                if (text_soup == []):
                    print('BLOG TYPE : //////////////////////////////////////////////')
                    post_area = soup.findAll("div", {'class': 'se_editView'})
                    print(post_area)
                    for i in post_area:
                        try:
                            select = 'p > span'
                            text_soup = i.select(select)
                            # print(post_area)
                            # 태그 제거
                            cleantext = remove_tag(str(text_soup))
                            print(cleantext)
                        except:
                            print('문제발생')
                            continue
                            # 태그 제거
                cleantext = remove_tag(str(text_soup))
                print(cleantext)
            except:
                print('문제발생')
                continue
    cnt=cnt+1