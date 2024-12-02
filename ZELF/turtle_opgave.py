from math import sqrt
def trek_wortel(lijst):
    with open("wortels.txt","w") as f:
        for a in lijst:
            print(str(a)+"\t"+str(sqrt(a))+"\n",file=f)
    return

if __name__=="__main__":
    bovengrens=int(input("Wat is het grootste nummer waarvan de wortel getrokken moet worden?"))
    trek_wortel(list(range(1,bovengrens+1)))
    #print(str(list(range(1,bovengrens+1))))