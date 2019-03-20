from konlpy.tag import Okt as tw
from collections import Counter
import codecs
import pandas as pd

def get_tags(text, ntags=50):
    spliter=tw()    #konlpy의 twitter객체
    nouns = spliter.nouns(text) #nouns함소를 통해 text에서 명사만 분리/추출
    count = Counter(nouns)  #counter객체를 생성하고 참조변수 nouns 할당
    return_list = []    #명사 빈도수 저장할 변수
    for n, c in count.most_common(ntags) :
        temp = {'tag':n, 'count':c}
        return_list.append(temp)
        # most_common 메소드는 정수를 입력받아 객체 안의 명사중 빈도수
        # 큰 명사부터 순서대로 입력받은 정수 갯수만큼 저장되어있는 객체 반환
        # 명사와 사용된 갯수를 return_list에 저장합니다.
    return return_list

def main(route, file_name, noun_count):
    text_file_name = file_name+'.txt'
    output_file_name = route+'\\cnt\\cnt_'+file_name  #결과물 저장 경로
    open_text_file = open(route+text_file_name,'r',-1,"CP949")   #분석할 파일을 open
    text = open_text_file.read()
    tags = get_tags(text, noun_count)
    open_text_file.close()  #파일 close
    open_output_file = open(output_file_name, 'w', -1, 'CP949')
    for tag in tags :
        noun = tag['tag']
        count = tag['count']
        open_output_file.write('{}{}\n'.format(noun, count))#결과 저장
    open_output_file.close()


for i in range(1,21576+1) :
    main('C:\\Users\\SHJ\\PycharmProjects\\new_blog\\txt\\', str(i), 50)
    print(i,'번째 시행')

# result = pd.read_csv('C:\\Users\\SHJ\\PycharmProjects\\new_blog\\text', encoding='CP949')
# print(result)

# l = open("C:\DataCuk_Project\dup_removed_naver_table2.csv",'r',encoding="utf-8-sig")
# csvreader = csv.reader(l)
#
#
# print("... csv에서 목록을 생성하는 중 ...")
# for row in csvreader :
#     row = str(row)
#     # print(row)
#     row = row[2:-2]
#     if row is not '':
#         link.append(row)
#     else : continue
# print("/////목록 생성 완료/////")