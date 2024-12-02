# Bereken de mediaan van een reeks getallen in een tekstbestand

# Functie gemiddelde berekent het gemiddelde van de getallen in een list
def gemiddelde (getallen):
    som = 0
    for getal in getallen:
        som += float(getal)

    try:
        gemiddelde = float(som)/len(getallen)
        return gemiddelde
    except ZeroDivisionError:
        return None

# Functie mediaan berekent de mediaan van de getallen in een list
def mediaan (getallenreeks):
    # De getallen moeten op volgorde staan, dus list eerst sorteren
    getallenreeks.sort()
    if len (getallenreeks)%2 == 0:
        # Bij even aantal getallen het gemiddelde van de middelste 2 nemen
        i = len (getallenreeks)//2 - 1
        mediaan = gemiddelde (getallenreeks[i:i+2])
    else:
        # Bij oneven aantal getallen het middelste getal nemen
        i = (len (getallenreeks)//2)
        mediaan = getallenreeks[i]
    return mediaan

def lees_bestand (fname):
    getallen = [regel.strip() for regel in open(fname)]
    return getallen

getallen_in_str = lees_bestand ('getallen.txt')
getallen_in = [float(x) for x in getallen_in_str]
m = mediaan (getallen_in)
print ("De mediaan van deze", len(getallen_in), "getallen is", m, ".")
