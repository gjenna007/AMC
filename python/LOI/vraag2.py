import sqlite3
import os
path = 'C:\\\\Users\\gjenn\\OneDrive\\Desktop\\opdrachten_loi\\'
#Connect met de database
db = sqlite3.connect(path + 'chinook.db')
cur = db.cursor()
def maakNieuwePlaylist (cur, db):
    cur.execute('''
    SELECT PlaylistId, Name
    FROM playlists;
    ''')
    playlists = cur.fetchall()
    names = [x[1] for x in playlists]
    ids = [x[0] for x in playlists]
    #Maak een nieuwe playlist aan
    while True:
        newPlaylist = input('Geef de naam van de nieuwe playlist\n')
        if newPlaylist in names:
            print('Deze playlist bestaat al')
        else:
            newPlaylistId = max(ids) + 1
            cur.execute('''
            INSERT INTO playlists
            VALUES (?,?);
            ''',(newPlaylistId, newPlaylist))
            db.commit()
            break 
    return(newPlaylistId)

def checkOccurrences(cur,line):
    offset = 0 #Omdat het bestand heel groot kan zijn lezen we het in per 1000 regels
    songList = []
    while True:
        #Lees de volgende blok van 1000 tracks uit de database in
        cur.execute('''SELECT t.TrackId, t.Name, t.AlbumId, al.AlbumId, al.ArtistId,
        ar.ArtistId, ar.Name
        FROM tracks AS t, albums AS al, artists AS ar
        WHERE t.AlbumId = al.AlbumId
        AND al.ArtistId = ar.ArtistId
        LIMIT 1000 OFFSET ?;
        ''',(offset,))         
        #Maak nu een lijst van alle tracks waarvan de naam hetzelfde begint
        if cur.fetchone() is None:
            break #Er is niets ingelezen, dus we hebben de hele database gehad
        else:
            offset += 1000
            while True:
                track = cur.fetchone()
                if track is None:#Het einde van het blok is bereikt
                    break
                elif track[1].startswith(line):
                    songList.append((track[0], track[1], track[6]))
    return (songList)
        
if __name__ == "__main__":    
    #Gebruiker om te importeren lijst vragen net zolang tot hij geldige bestandsnaam ingeeft
    while True:
        nieuweLijst = input('Geef de naam van het te importeren bestand\n')
        isFile = os.path.isfile(path + nieuweLijst)
        #Als bestand niet bestaat, geef foutmelding en vraag opnieuw
        if isFile == False:
            print('Bestand niet gevonden')
        else: break
    newPlaylistId = maakNieuwePlaylist (cur, db) 
    
    #Open het bestand met de playlist
    file1 = open(nieuweLijst, 'r')
    print('---Start import playlist---')
    while True:
        #Lees de volgende regel uit het bestand met de playlist
        line = file1.readline()
        if not line:
            break#Als de regel leeg is, zijn we klaar
        line  = line.strip()
        songList = checkOccurrences(cur, line)
                    
        #Als er geen tracks zijn , print dan een mededeling en continue
        if len(songList) == 0:
            print(f'---Geen tracks gevonden voor {line}---')
            continue
        #(Als het meer dan 1 zijn, print dan keuzemenuutje af en pas weg te schrijven data aan
        elif len(songList) > 1:
            print('Maak een keuze uit de volgende tracks')
            for i in range(len(songList)):
                print(i+1,'\t', songList[i][1], '\t', songList[i][2])
            keuze = int(input('Uw keuze:\t'))
        else: keuze = 1
        #Schrijf de juiste data weg
        cur2 = db.cursor()
        cur2.execute('''
        INSERT INTO playlist_track
        VALUES (?,?);
        ''',(newPlaylistId, songList[keuze-1][0]))
        db.commit()    
    file1.close()
    print('---Import van playlist gereed---')