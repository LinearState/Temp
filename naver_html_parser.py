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
    text=''
    for i in content:
        cleaner = i.text.strip()
        if (cleaner != ''):
            text=text+' '+cleaner
    return text

#블로거의 id와 게시글의 logNo를 받아 url로 변환합니다.
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

#list에서 삭제하고자 하는 원소의 값을 모두 제거합니다.
def delete_all(list, delete):
    for i in range(len(all_index(list,delete))):
        list.remove(delete)
    print(len(all_index(list,delete)),'개의 원소가 삭제되었습니다.')
    return list




headers = {'User-Agent' : 'Mozilla/5.0'}

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


#ODBC 연결
database = 'NAVER'
id = 'sa'
pw = '3356'
con = pyodbc.connect('DRIVER={ODBC Driver 11 for SQL Server};SERVER=.\\SQLEXPRESS;DATABASE='+database+';UID='+id+';PWD='+pw)
cursor = con.cursor()

import datetime

try:
    cnt=1
    for i in range(len(re_link)) :
        nap(2,5)
        print(cnt,"번째 시행 : ",re_link[i])
        URL = re_link[i]
        #저장될 항목들 ... (HTML, 제목, 날짜, 주소, 내용)
        html = get_html(URL)
        title=''
        date=''
        link=str(URL)
        text=''

        soup = bs(html, 'html.parser')
        post_area = soup.findAll("div", {'class':'se_component se_paragraph default'})
        if(post_area!=[]): #스마트에디터3 아님
            print('BLOG TYPE : NOT SE3')
            date_soup = soup.select('span.se_publishDate',)
            title_soup = soup.select('div.se_editArea > div > div > div > h3')
            title = remove_tag(title_soup)
            date = remove_tag(date_soup)
            date = re.sub('. ', '-', date)

            for i in post_area :
                try:
                    text_soup = i.select('p')
                    cleantext = remove_tag(text_soup)   #태그 제거
                    text = text+' '+cleantext

                except Exception as ex:
                    print('문제발생 : ',ex)
                    continue

        elif(post_area==[]) : #스마트에디터3
            print('BLOG TYPE : 스마트에디터3')
            post_area=soup.findAll('div',{'id':'postViewArea'})
            date_soup = soup.select('p.date')
            title_soup = soup.select('span.pcol1.itemSubjectBoldfont')
            title = remove_tag(title_soup)
            date = remove_tag(date_soup)
            date = re.sub('. ', '-', date)

            for i in post_area:
                try:
                    select = 'p'
                    text_soup = i.select(select)
                    if (text_soup == []):
                        print('탐색 수준을 낮춥니다.')
                        for i in post_area:
                            select = 'div'
                            text_soup = i.select(select)
                    cleantext = remove_tag(text_soup)   # 태그 제거
                    text = text + ' ' + cleantext

                except Exception as ex:
                    print('문제발생 : ',ex)
                    continue

        cursor.execute(
            '''INSERT INTO DATA1(HTML, title, date, link, text, savetime) VALUES (?, ?, ?, ?, ?,?)''',
            str(html), str(title), str(date), link, str(text), datetime.datetime.now()
        )
        cursor.commit()
        cnt=cnt+1
finally:
    cursor.close()