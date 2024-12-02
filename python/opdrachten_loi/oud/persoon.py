import datetime
class Persoon:
    def __init__(self, naam, sekse, geboortedatum):
        self.__naam = naam
        self.__sekse = sekse
        f="%d-%m-%Y"
        self.__geboortedatum = datetime.datetime.strptime(geboortedatum, f)  
    def getNaam(self):
        return self.__naam
    def getGebDatum(self):
        return self.__geboortedatum
    def isVrouw(self):
        return self.__sekse == 'V'
    def leeftijd(self):
        today = datetime.date.today()
        age= today.year - self.__geboortedatum.year - ((today.month, today.day) < (self.__geboortedatum.month, self.__geboortedatum.day))
        return(age)
            
p1 = Persoon('Jos','M','24-10-1973')
print(p1.getNaam(), p1.leeftijd())


        