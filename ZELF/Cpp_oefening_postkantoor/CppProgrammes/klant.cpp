#include"klassen.h"

Klant::Klant (){
	aantalForms=0;
}

Klant::~Klant(){
	formulieren.clear();
}

void Klant::setBeurt(bool a){
		aanDeBeurt=a;
}	

bool Klant::getBeurt() const{
		return aanDeBeurt;
}	

void Klant::setKlantNummer(int a){
	klantNummer=a;
}

int Klant::getKlantNummer() const{
	return klantNummer;
}

void Klant::setAantForms(int i_aantForms){
	aantalForms=i_aantForms;
}

int Klant::getAantForms()const{
	return aantalForms;
}

void Klant::geefForm(Formulier a){
	formulieren.push_back(a);
	aantalForms++;
}

Formulier Klant::vraagForm(){
	return formulieren.back();
	formulieren.pop_back();
	aantalForms--;
}

	
		
