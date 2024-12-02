# -*- coding: utf-8 -*-
"""
Created on Sat Oct 26 18:41:46 2019

@author: gjenna
"""
#import sys
import numpy as np
#import random
            
class Speler:
    #Deze functie wordt gebruikt om de speler zijn beoordeling te geven over de door MM voorgestelde kleurcode
    def GeefOordeel(self,beurt):
        loop = True
        while (loop):
            loop = False
            raw_aant_zwart = input("Hoeveel pennen hebben de goede kleur en staan op de goede plaats? (0-4)")  
            try: 
                aant_zwart = int(raw_aant_zwart)
                if aant_zwart < 0 or aant_zwart > 4:
                    print ("Niet toegestane waarde")
                    loop = True
            except ValueError:
                print ("Dit is geen geheel getal tussen 0 en 4")
                loop = True
        if aant_zwart == 4: 
               print("Geraden in", beurt.counter, "beurten :-)")
               return("TheEnd")       
        loop = True
        while (loop):
            loop = False
            raw_aant_wit = input("Hoeveel van de overige pennen hebben al wel de goede kleur, maar staan nog niet op de goede plaats? (0-4)")  
            try: 
                aant_wit = int(raw_aant_wit)
                if aant_wit < 0 or aant_wit > 4:
                    print ("Niet toegestane waarde")
                    loop = True
            except ValueError:
                print ("Dit is geen geheel getal tussen 0 en 4")
                loop = True
        
        aant_leeg = 4 - aant_zwart - aant_wit
        return (aant_zwart, aant_wit, aant_leeg)
    
class MasterMind:
    def ChooseCode (self, beurt, overgeblevenCodes, alleCodes, combinatieMatrix):
    #Deze functie kiest de volgende code om te raden uit de overgeblevenCodes
       if beurt.counter == 1: return (466)#Dit is code (1,2,3,4)
       else:
           minimalValuedCode = [10000, 0]
           for row in range (2401):
             if overgeblevenCodes.x[row] == 1:
               scores = np.zeros(14)
               for column in range(2401):
                   if overgeblevenCodes.x[column] == 1:
                       scores[int(combinatieMatrix[row,column])] += 1
               bestScore = np.average(scores)
               if bestScore < minimalValuedCode [0]: 
                   minimalValuedCode[0] = bestScore
                   minimalValuedCode[1] = row
           return( minimalValuedCode[1])
       
    def PlayMove (self, beurt, codeNummer, alleCodes):
      #code = self.ChooseCode (beurt, overgeblevenCodes, alleCodes, combinatieMatrix)
      print("Poging", beurt.counter, ":", alleCodes.x[codeNummer][1])
      
    def ProcessOordeel (self, oordeel, codeNummer, overgeblevenCodes, alleBeoordelingen, combinatieMatrix, beurt, alleCodes):
    #Deze functie past de vector "overgeblevenCodes" aan
       #eerst moet ik het oordeelNummer achterhalen
       for x in range(14):
           if (oordeel[0] == alleBeoordelingen.x[x][1]['goed'] and
               oordeel[1] == alleBeoordelingen.x[x][1]['halfgoed'] and
               oordeel[2] == alleBeoordelingen.x[x][1]['fout']):
                   oordeelNummer = x
                   break
       for column in range (2401):
           if combinatieMatrix[codeNummer, column] != oordeelNummer:
               overgeblevenCodes.x [column] = 0
#       if np.sum(overgeblevenCodes.x) == 1:
#           print("Dan is het:")
#           self.PlayMove(beurt, np.where(np.array(overgeblevenCodes.x)== 1)[0][0], alleCodes)
#           return("TheEnd")
       if np.amax(overgeblevenCodes.x) == 0: 
           print("Onmogelijk. Een van je beoordelingen is verkeerd.")
           return("TheEnd")
       else: return (overgeblevenCodes)       
   #de array overgeblevenodes moet nu geupdatet worden.
    #iedere beoordeling doet het totaal aantal toegestane mogelijkheden afnemen 
   
class Beurt:
    def __init__(self):
        self.counter = 1
    def AddOne(self):
        self.counter += 1
     
class AlleBeoordelingen: #alle 14 mogelijke beoordelingen, met hun volgnummers
    def __init__ (self):
        self.x=((0,{"fout": 4, "halfgoed": 0, "goed": 0}),
                (1,{"fout": 3, "halfgoed": 1, "goed": 0}),
                (2,{"fout": 3, "halfgoed": 0, "goed": 1}),
                (3,{"fout": 2, "halfgoed": 2, "goed": 0}),
                (4,{"fout": 2, "halfgoed": 1, "goed": 1}),
                (5,{"fout": 2, "halfgoed": 0, "goed": 2}),
                (6,{"fout": 1, "halfgoed": 3, "goed": 0}),
                (7,{"fout": 1, "halfgoed": 2, "goed": 1}),
                (8,{"fout": 1, "halfgoed": 1, "goed": 2}),
                (9,{"fout": 1, "halfgoed": 0, "goed": 3}),
                (10,{"fout": 0, "halfgoed": 4, "goed": 0}),
                (11,{"fout": 0, "halfgoed": 3, "goed": 1}),
                (12,{"fout": 0, "halfgoed": 2, "goed": 2}),
                (13,{"fout": 0, "halfgoed": 0, "goed": 4}))
          
class AlleCodes: #alle 2401 mogelijke codes, met hun volgnummers
    def __init__ (self):
        self.x = []
        counter = 0
        for kleur1 in range(7):
            for kleur2 in range(7):
                for kleur3 in range(7):
                    for kleur4 in range(7):
                        self.x.append((counter, (kleur1, kleur2, kleur3, kleur4)))
                        counter += 1
                            
class OvergeblevenCodes: #een lijst met enen en nullen van de codes die nog toegestaan zijn
    def __init__ (self):
        self.x = []
        for i in range(2401):
            self.x.append(1)
            
 
        
    
