from math import sqrt
class Punt:
    def __init__(self,x,y):
        self.x=x
        self.y=y
    def afstandTot(self, p):
        """
        Calculate the Euclidean distance from this point to another point
        """
        xdist=self.x-p.x
        ydist=self.y-p.y
        return sqrt(xdist*xdist+ydist*ydist)
    def __str__(self):
        """
        Make a string representation of a Rational object
        """
        return "Punt(" +str(self.x) +", "+ str(self.y) +")"
    
A=Punt(1,1)
print(A)
B=Punt(4,5)
print(B)
print(A.afstandTot(B))
print(B.afstandTot(A))        