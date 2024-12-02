#include"klassen.h"

Klok::Klok(){
	huidigeTijd=0;
	ambtenaarBezig=false;
}
	
Klok::~Klok(){
}

void Klok::setAmbtenaarBezig(){
	ambtenaarBezig=true;
}

void Klok::doeTik(){
	huidigeTijd++;
	ambtenaarBezig=false;
}

void Klok::setTijd(int tijdStip){
	huidigeTijd=tijdStip;
}

void Klok::krijgBeurt(Rij& rij,Lijst& lijst,Ambtenaar& eersteLoket, Ambtenaar ambtenaar[]){
	int a=rij.getLengte();
	if (a==0 && ambtenaarBezig==false && huidigeTijd>SLUITINGSTIJD){
		printLijst(lijst);
	} else {
		doeTik();
		Klok hulpKlok;
		hulpKlok.setTijd(huidigeTijd);
		if (ambtenaarBezig==true){
			hulpKlok.setAmbtenaarBezig();
		}
		//std::cout<<"huidige tijd:"<<huidigeTijd<<std::endl;
		int ll=rij.getLengte();
		std::cout<<"klok zegt lengte rij is:"<<ll<<std::endl;
		rij.krijgBeurt(hulpKlok,eersteLoket,rij, lijst, ambtenaar);
		//std::cout<<"huidige tijd:"<<huidigeTijd<<std::endl;
	}
}

int Klok::getTijd () const{
	return huidigeTijd;
}

void Klok::printLijst(Lijst& lijst){
	lijst.printLijst();	
}


