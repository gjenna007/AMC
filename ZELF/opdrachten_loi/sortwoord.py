import sys
def check_userinput():
    if len(sys.argv) != 3:
        print("De juiste manier om dit programma aan te roepen is: sortwoord.py 'invoerlijst.txt' 'uitvoerlijst.txt' ")
        sys.exit(1)
    else:
        invoer=sys.argv[1]
        uitvoer=sys.argv[2]
        return invoer, uitvoer
        
def lees_bestand (fname):
    woorden = [regel.strip() for regel in open(fname)]
    return woorden

invoer, uitvoer = check_userinput() #ga na of de gebruiker een invoer- en uitvoerbestand heeft opgegeven
woorden = lees_bestand (invoer)
if len(woorden) == 0: #ga na of het invoerbestand niet leeg is
    print("Het invoerbestnad is leeg. Er valt niks te ordenen.")
    sys.exit(1)
woorden = [str(x) for x in woorden] 
for woord in woorden: #ga na of de invoer alleen maar uit letters bestaat met ten hoogste een hoofdletter aan het begin
    if woord.isalpha() == False or (woord.islower() == False and woord.istitle() == False):
        print("In de lijst zijn alleen maar letters (a-Z, A-Z) toegestaan, en op iedere regel mag maar een woord staan. Verder mag alleen de beginletter een hoofdletter zijn.")
        sys.exit(1)
        
 #Nu gaan we de lijst splitsen in woorden meteen beginhoofdletter en woorden zonder beginhoofdletter
hoofdletters=[]
kleine_letters=[]
for woord in woorden:
    if woord.istitle() == True:
         hoofdletters.append(woord)
    else:
         kleine_letters.append(woord)  
#Sorteren maar       
hoofdletters.sort()
kleine_letters.sort()
  
fp= open(uitvoer, 'w')
for x in kleine_letters:
    fp.write(x+"\n")
for x in hoofdletters:
    fp.write(x+"\n")
fp.close()  
  
  