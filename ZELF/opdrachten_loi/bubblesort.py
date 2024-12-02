def sorteren (invoer):
    uitvoer=invoer.copy()
    passage=len(invoer)
    while passage>1:
        for loop in range(passage-1):
            eerste=uitvoer[loop]
            tweede=uitvoer[loop+1]
            if eerste>tweede:
                uitvoer[loop]=tweede
                uitvoer[loop+1]=eerste
        passage-=1
    return uitvoer

getallen=[110,27,58,96,176,2,-4,56]
gesorteerd=sorteren(getallen)
print(getallen)
print(gesorteerd)