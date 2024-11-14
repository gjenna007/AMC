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
            
class Student(Persoon):
    #we definiéren een klassvariabele om iedere student die aangemaakt wordt een ander nummer te kunnen geven
    studentnr = 1
    def __init__(self, naam, sekse, geboortedatum):
        super().__init__(naam, sekse, geboortedatum)
        self.__studentnr = Student.studentnr
        Student.studentnr += 1
        self.__opleidingen = []
    def getStudentnr(self):
        return self.__studentnr
    def voegOpleidingToe(self, code):
        self.__opleidingen.append(code)
    def verwijderOpleiding(self, code):
        self.__opleidingen.remove(code)
    def volgtOpleiding(self,code):
        return code in self.__opleidingen
        
s1 = Student ('Dennis', 'M', '02-04-1995')
print(s1.getStudentnr(),s1.getNaam(),s1.leeftijd())
s2=Student('Karima','V','15-12-1998')
print(s2.getStudentnr(),s2.getNaam(),s2.leeftijd())
s2.voegOpleidingToe('Inf')
s2.voegOpleidingToe('Twi')
print(s2.getNaam(),s2.volgtOpleiding('ChT'))
print(s2.getNaam(),s2.volgtOpleiding('Inf'))
s2.verwijderOpleiding('Inf')
print(s2.getNaam(),s2.volgtOpleiding('Inf'))