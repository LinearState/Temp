import pandas as pd

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

alld.head(10)