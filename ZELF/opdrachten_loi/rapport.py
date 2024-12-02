import sqlite3
from collections import defaultdict
db = sqlite3.connect("C:\\Users\gjenn\OneDrive\Desktop\opdrachten_loi\Webwinkel.db")
cur = db.cursor()
cur.execute('''SELECT Besteldatum, Achternaam, B.Bestelnr, A.Artikelnr, Aantal, Prijs
FROM Bestellingen AS B, Klanten AS K, Bestelregels AS R, Artikelen AS A
WHERE B.Klantnr = K.Klantnr
AND B.Bestelnr = R.Bestelnr
AND R.Artikelnr = A.Artikelnr;
''')
rapport0 = cur.fetchall()
#print(len(rapport0))
'''nu alle bestellingen van 2014 eruit filteren'''
rapport1=[]
for item in rapport0:
    if item[0][0:4] == '2014':
        rapport1.append(item)

'''per bestelnr gaan we nu de het totaal aantal artikelen en de prijs uitrekenen'''
      
rapport2Aantal = defaultdict(int)
rapport2Prijs = defaultdict(float)
rapport2Datum={}
rapport2Naam={}
for Bdat, Anaam, Bnr, Anr, Aant, Prijs in rapport1:
    rapport2Aantal[Bnr] += int(Aant)
    rapport2Prijs[Bnr] += float(Aant)*float(Prijs)
    rapport2Datum[Bnr] = Bdat
    rapport2Naam[Bnr] = Anaam

'''Nu kunnen we het gewenste rapport uitprinten'''
print('Besteldatum', '\t\t', 'Klantnaam', '\t', 'Aantal art.', '\t', 'Prijs')
[print('-', end = '') for x in range(70)]
print('\n')
for x, y  in rapport2Aantal.items():
    if len(rapport2Naam[x])<15:
        s='\t\t'
    else:
          s='\t'  
    print(rapport2Datum[x], end = '\t')
    print(rapport2Naam[x], end = s)
    print(rapport2Aantal[x], end = '\t')
    print(round(rapport2Prijs[x],2))
