import sqlite3
from collections import defaultdict
db = sqlite3.connect("C:\\Users\gjenn\OneDrive\Desktop\opdrachten_loi\chinook.db")
cur = db.cursor()
cur.execute('''SELECT i.TrackId, i.Quantity, t.TrackId, t.AlbumId, a.AlbumId,
a.ArtistId, aa.ArtistId, aa.Name, a.Title
FROM invoice_items AS i, tracks AS t, albums AS a, artists AS aa
WHERE i.TrackId = t.TrackId
AND t.AlbumId = a.AlbumId
AND a.ArtistId = aa.ArtistId;
''')
fulltable = cur.fetchall()

'''een tabel maken hoevaak ieder album beluisterd is,
    en een aparte tabel maken met de artiest en titel van ieder album'''
albumIdQuantity = defaultdict(int)
albumIdNameTitle={}
for iTrackId, Quantity, tT, tAlbumId, aA, aArtistId, aaA, Name, Title in fulltable:
    albumIdQuantity[tAlbumId] += int(Quantity)
    albumIdNameTitle[tAlbumId] = (Name, Title)

'''Zet de dictionary albumIdQuantity om in een list en orden die van groot naar klein'''
AQList = [(id, quantity) for id, quantity in albumIdQuantity.items()]
AQList.sort(reverse=True, key = lambda a: a[1]) 

'''Print de eerste 10 items uit'''
print('Rangnummer','\t','Artiest','\t\t\t','Titel album','\t\t\t\t\t','Aantal keer beluisterd')
[print('-', end = '') for x in range(121)]
print('\n')
for i in range(10):
    print(i+1, '\t\t', end='')
    albumId = AQList[i][0]
    name = albumIdNameTitle[albumId][0]
    print(name, end='')
    [print(' ', end = '') for x in range(32-len(name))]
    title = albumIdNameTitle[albumId][1]
    print(title, end='')
    [print(' ', end = '') for x in range(52-len(title))]    
    print(albumIdQuantity[albumId])