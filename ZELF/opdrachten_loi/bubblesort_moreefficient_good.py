def sorteren (invoer):
    uitvoer=invoer.copy()
    passage=len(invoer)
    daadwerkelijk_gewisseld=True
    while passage>1 and  daadwerkelijk_gewisseld==True:
        daadwerkelijk_gewisseld=False
        for loop in range(passage-1):
            eerste=uitvoer[loop]
            tweede=uitvoer[loop+1]
            if eerste>tweede:
                uitvoer[loop]=tweede
                uitvoer[loop+1]=eerste
                daadwerkelijk_gewisseld=True
        passage-=1
    return uitvoer

getallen=[110,27,58,96,176,2,-4,56]
gesorteerd=sorteren(getallen)
print(getallen)
print(gesorteerd)