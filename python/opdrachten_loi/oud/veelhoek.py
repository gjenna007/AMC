from math import sqrt
class Veelhoek:
    def __init__(self,n):
        self.aantal_zijden = n
        
    def __str__(self):
        """
        Make a string representation of the veelhoek
        """
        return str(self.aantal_zijden) + " zijden"
        # Client code that uses Rational objects
        
class Driehoek(Veelhoek):
    def __init__(self,lst):
        super().__init__(3)
        self.zijden = lst
    def bereken_omtrek(self):
        """Bereken de omtrek van de driehoek"""
        return sum(self.zijden)
    def bereken_oppervlakte(self):
        """Bereken de oppervlakte van een driebhoek"""
        s=self.bereken_omtrek()/2
        return sqrt(s*(s-self.zijden[0])*(s-self.zijden[1])*(s-self.zijden[2]))
class Rechthoek(Veelhoek):
    def __init__(self,lst):
        super().__init__(4)
        self.zijden = lst
    def bereken_omtrek(self):
        """Bereken de omtrek van de rechthoek"""
        return 2*sum(self.zijden)
    def bereken_oppervlakte(self):
        """Bereken de oppervlakte van een rechthoek"""
        l,b=self.zijden
        return l*b   
class Vierkant(Rechthoek):
    def __init__(self,l):
        super().__init__([l,l])
        
    
dh=Driehoek([3,4,5])
print(dh)
print(dh.bereken_omtrek())
print(dh.bereken_oppervlakte())
rh=Rechthoek([4,5])
print(rh)
print(rh.bereken_omtrek())
print(rh.bereken_oppervlakte())
vk=Vierkant(5)
print(vk)
print(vk.bereken_omtrek())
print(vk.bereken_oppervlakte())