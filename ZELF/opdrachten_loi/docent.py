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
            
class Docent(Persoon):
    def __init__(self, naam, sekse, geboortedatum, salaris = 0):
        super().__init__(naam, sekse, geboortedatum)
        self.__salaris = salaris
    def setSalaris(self, salaris):
        self.__salaris = salaris
    def getSalaris(self):
        return self.__salaris
    def verhoogSalaris(self, perc):
        '''Het verhogingspecentage moet een getal tussen 0 en 100 zijn'''
        self.__salaris *= (1+ perc/100)
        

d1 = Docent('Marcela','V','25-12-1988')
print(d1.getNaam(),d1.leeftijd(),d1.isVrouw(),d1.getSalaris())
d1.setSalaris(2500.0)
print(d1.getSalaris())
d1.verhoogSalaris(5)
print(d1.getSalaris())