import re
import os
import pandas as pd
from pandas import DataFrame as df



def cnt_list(route, file_name,ntags):
    list=[]
    r=open(route+"\\"+file_name,'r',encoding='cp949')
    content = r.read()
    p=re.compile("\D+")
    count = p.findall(content)
    for i in range(len(count)) :
        list.append(count[i].strip())
    # print(len(list))
    if len(list) == ntags : return list
    else : return list.append(["NA"]*(ntags-len(list)))

def df_append(route, name_format,data_frame,ntags):
    newDF=df_by_col(ntags)
    for i in range(len(os.walk(route).__next__()[2])):
        print(i+1,"번째 시행")
        file_name = name_format +str(i+1)
        newDF.loc[file_name] = cnt_list(route,file_name,ntags)
    return data_frame.append(newDF)

def df_by_col(ncol):
    newDF=df(columns=["x"+str(j) for j in range(ncol)])
    return newDF

route = 'C:\\Users\\SHJ\\PycharmProjects\\new_blog\\txt\\cnt'
name_format = "cnt_"
ntags=51
counter_df = df_by_col(ntags)
counter_df = df_append(route, name_format, counter_df,ntags)

counter_df.to_csv("cnt_df.csv",mode='w')