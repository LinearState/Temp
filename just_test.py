import random
from time import sleep
from bs4 import BeautifulSoup as bs
import requests
# import re
# t = 'http://blog.naver.com/duddmsdl94?Redirect=Log&amp;logNo=220894655766'
# for a in re.finditer('Redirect',t) :
#     print(t[22:a.start()-1])
#
# # [.+(logNo=).+]

# a = '멍멍'
# b = '야옹'
# c = '고양이는'+a+'개는'+b
# print(c)

#int1과 int2 사이의 임의의 숫자만큼 쉽니다.
def nap(int1,int2):
    rand=random.randrange(int1,int2)
    sleep(rand)
    print(rand,'초 쉽니다.')

def get_html(url):
    _html = ""
    resp = requests.get(url)
    if resp.status_code == 200:
        _html = resp.text
    return _html

re_link = ['https://blog.naver.com/PostView.nhn?blogId=bluejive1004&logNo=221111476967']
cnt=1
for i in re_link :
    nap(2,5)
    print(cnt,"번째 시행 : ",i)
    cnt= cnt+1
    URL = i
    html = get_html(URL)
    soup = bs(html, 'html.parser')
    post_area = soup.findAll("div", {'class':'se_component se_paragraph default'})#.findall("div",{'class':'se_textView'})
    print(post_area)
    for i in post_area :
        try:
            text_soup = i.findAll("p",{"class":"se_textarea"})
            print(text_soup)
        except:
            print('문제발생')
            continue

#if 스마트에디터3
# 제목 : div class="htitle" -> span class="pcol1 itemSubjectBoldfont"
# 날짜 : p class ="date fil5 pcol2 _postAddDate"
# 주소 : a class='fil5 pcol2'
# 내용 : div id='postViewArea' -> div -> p-> span -> (text)

#스마트 에디터3 (셀렉터 사용)
# 제목 : title_1 > span.pcol1.itemSubjectBoldfont
# 날짜 : printPost1 > tbody > tr > td.bcc > table > tbody > tr > td > p.date.fil5.pcol2._postAddDate
# 주소 : url_tographylogy_{{logNo}} > a
# 내용 : post-view{{logNo}} > p > span
#****주의!!**** : {{logNo}}에는 포스트 로그넘버가 들어가야 함.

#not 스마트에디터3 (se)
# 제목 : div class="se_textView" -> h3 class="se_textarea"->(주석 <!-- --> 제목블라블라 <!-- -->)
# 날짜 : div class='blog2_container' -> span class="se_publishDate pcol2"
# 주소 : ?
# 내용 : div class="se_component se_paragraph default" -> p class="se_textarea"->span

#not 스마트에디터3 (셀렉터 사용)
# 제목 : div.se_editArea > div > div > div > h3
# 날짜 : div.blog2_container > span.se_publishDate.pcol2
# 주소 :
# 내용 : div.se_component_wrap.sect_dsc.__se_component_area > div > div > div > div > div > div > p > span