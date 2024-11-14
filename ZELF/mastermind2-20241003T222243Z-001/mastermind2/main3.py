# -*- coding: utf-8 -*-
"""
Created on Sat Oct 26 18:40:42 2019

@author: gjenna
"""

import os, sys
current_path = os.path.abspath('.')
sys.path.insert(0,current_path)

import classes3 as cl
import numpy as np

class Game:    
    def __init__(self):
        MOET_NOG_INITIEREN = False
        self.alleBeoordelingen = cl.AlleBeoordelingen()
        self.alleCodes = cl.AlleCodes()
        self.combinatieMatrix = InitieerCombinatieMatrix(self, MOET_NOG_INITIEREN)
        
    def Play(self):
        overgeblevenCodes = cl.OvergeblevenCodes()
        speler = cl.Speler()
        masterMind = cl.MasterMind()
        oordeel = []
        beurt = cl.Beurt()
        codeNummer = 0
        while oordeel != [4,0,0]:
             if beurt.counter > 1: 
                 overgeblevenCodes = masterMind.ProcessOordeel(oordeel, codeNummer, overgeblevenCodes, self.alleBeoordelingen, 
                                                               self.combinatieMatrix, beurt, self.alleCodes)
                 if overgeblevenCodes == "TheEnd": 
                     break
             print("Nog", np.sum(overgeblevenCodes.x), "mogelijkheden over")
             codeNummer = masterMind.ChooseCode(beurt, overgeblevenCodes, self.alleCodes, self.combinatieMatrix)
             masterMind.PlayMove (beurt, codeNummer, self.alleCodes)
             oordeel = speler.GeefOordeel(beurt)
             if oordeel == "TheEnd":
                 break
             beurt.AddOne()
        #print("Geraden!")
        
def GeefOordeel (self, codeNummer1, codeNummer2):
        self.alleBeoordelingen = cl.AlleBeoordelingen()
        self.alleCodes = cl.AlleCodes()
        code1 = self.alleCodes.x[codeNummer1][1]
        code2 = self.alleCodes.x[codeNummer2][1]
#        code1 = (0,5,2,2)
#        code2 = (2,0,5,5)
#        flags1 = [0, 1, 2, 3]
        aant_zwart = 0
        
        flags1 = [True, True, True, True]
        for x in range(4):
            if flags1[x] == True and code1[x] == code2[x]:
                aant_zwart += 1
                flags1[x] = False
#        for x in flags1:
#            if x > -1 and code1[x] == code2[x]:
#                aant_zwart += 1
#                flags1[x] = -1
        
        aant_wit = 0
        flags2 = flags1.copy()
        
        for x in range(4):
            if flags1[x] == True:
                ChangeFlag = False
                for y in range(4):
                    if flags2[y] == True and code1[x] == code2[y]:
                        aant_wit += 1
                        flags2[y] = False
                        ChangeFlag = True
                        break
                if ChangeFlag == True:
                    flags1[x] = False
                        
        oordeel = {'fout': 4 - aant_zwart - aant_wit, 'halfgoed': aant_wit, 'goed': aant_zwart}                
        for teller in range(14):
            if (oordeel['halfgoed'] == self.alleBeoordelingen.x[teller][1]['halfgoed'] and
                oordeel['goed'] == self.alleBeoordelingen.x[teller][1]['goed']):
                        return (teller)
                        #print(self.alleCodes.x[codeNummer1][1])
                        #print(self.alleCodes.x[codeNummer2][1])
                        #print(self.alleBeoordelingen.x[teller][1])
                        break
                    
def InitieerCombinatieMatrix (self,moet_nog_initieren): 
      if moet_nog_initieren == True:
        combinatieMatrix = np.full((2401, 2401), 100)#hiermee kun je controleren of de matrix volledig ingevuld wordt
        #eerst alle volledig goeden invullen op de diagonaal
        for x in range(2401):
            combinatieMatrix[x,x] = 13
        #nu de rest laten beoordelen en invullen
        for x in range(2400):
            for y in range (x + 1, 2401):
                oordeelNummer = GeefOordeel(self, x, y)
                combinatieMatrix[x,y] = oordeelNummer
                combinatieMatrix[y,x] = oordeelNummer 
                if x%10 == 0 and y%100 == 0 : print(x, y)
                if x%100 == 0 and y == 2400: np.save('Beoordelingsmatrix.npy',combinatieMatrix)
        np.save('Beoordelingsmatrix.npy',combinatieMatrix)
        print("Klaar!")
        return(combinatieMatrix)
      else: 
        combinatieMatrix = np.load('Beoordelingsmatrix.npy')
        return(combinatieMatrix)
        

 #########################################################   
game = Game()
mainloop = True
while mainloop == True:
    print("Neem een code in gedachten bestaande uit vier cijers van 0 t/m 6")
    input("Druk op enter, dan begin ik met raden....")
    game.Play()
    print("Nog een keer spelen? (y/n)")
    while True:
        choice = input("> ")    
        if choice == 'y' or choice == 'Y' or choice == "yes":
            break
        elif choice == 'n' or choice == 'N' or choice == "no":
            mainloop = False
            break