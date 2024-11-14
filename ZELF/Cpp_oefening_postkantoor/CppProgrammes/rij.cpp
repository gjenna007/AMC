#include "klassen.h"
#include<time.h>
#include<stdlib.h>
#include <list>


Rij::Rij (){
	klantNummer=1;
}

Rij::~Rij(){
	klanten.clear();
}

	
void Rij::neemTijdAan(const Klok& klok){
	huidigeTijd=klok.getTijd();
}

Klant Rij::creeerKlant(int nummer){
	Klant klant;
	srand (time(NULL));
	int aantForms=rand()% 2 + 1;
	if (aantForms==1){
		int kleurForm=rand()% 3 + 1;
		Formulier a;
		a.setKleur(kleurForm);
		klant.geefForm(a);
	}else{
		Formulier a;
		a.setKleur(GEEL);
		klant.geefForm(a);
		a.setKleur(GROEN);
		klant.geefForm(a);	
	}
	klant.setKlantNummer(nummer);
	return klant;
}

int Rij::getLengte() const{
	return klanten.size();
}
/*
void Rij::vernietigKlant(){
	klanten.erase(klanten.begin());
}
*/
void Rij::voegKlantToe(Klant a){
	klanten.push_back(a);
}

void Rij::krijgBeurt(Klok& klok, Ambtenaar& eersteLoket,Rij& rij,Lijst& lijst, Ambtenaar ambtenaar[]){
	neemTijdAan(klok);
	if (huidigeTijd<=BEGINLENGTE){
		static int klantNummer=0;
		Klant a=creeerKlant(klantNummer);
		klantNummer++;
		int ll=getLengte();
		std::cout<<"lengte"<<ll<<std::endl;
		voegKlantToe(a);
		ll=getLengte();
		std::cout<<"lengte"<<ll<<std::endl;
	} else if (huidigeTijd>BEGINLENGTE && huidigeTijd<SLUITINGSTIJD){
				srand (time(NULL));
			    int a=rand()% AANTTIKKENPERKLANT;
			    if (a==0){
			    	Klant b=creeerKlant(klantNummer);
			    	klantNummer++;
					voegKlantToe(b);
		    	}
	}
	int l=getLengte();
	static int count=0;
	count++;
	std::cout<<"rij zegt: keer nummer: "<<count<<std::endl;
	std::cout<<"rij zegt: lengte rij: "<<l<<std::endl;
	eersteLoket.krijgBeurt(klok, rij, lijst,ambtenaar);	
}

Klant Rij::geefEersteKlant(){
	Klant klant1;
	klant1=klanten.front();
	klanten.erase(klanten.begin());
	return klant1;
}
