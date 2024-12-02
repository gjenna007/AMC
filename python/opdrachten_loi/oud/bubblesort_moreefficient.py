def sorteren (invoer):
   invoer_copy=invoer.copy()
   #eerst gaan we het grootste element van de lijst bepalen
   grootste=max(invoer_copy)
   plaats=invoer_copy.index(grootste)
#nu gaan we steeds het kleinste element bepalen en die een voor een aan een 
#nieuwe lijst toevoegen
   uitvoer=[]
   for passage in range(len(invoer)):
      kleinste=grootste  
      for loop in range(len(invoer)):
         if invoer_copy[loop] != '*':
            if invoer_copy[loop]<kleinste:
               plaats=loop
               kleinste=invoer_copy[loop]
      uitvoer.append(kleinste)
      invoer_copy[plaats]='*'
   return uitvoer
#getallen=[3,3,2,2,2,1]
getallen=[110,27,58,96,176,2,-4,56]
gesorteerd=sorteren(getallen)
print(getallen)
print(gesorteerd)