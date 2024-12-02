#include"klassen.h"
#include<iostream>
Lijst::Lijst(){
}

Lijst::~Lijst(){
}

int Lijst::getLengte(){
	return lijst.size();
}

void Lijst::voegToe(const int& klantNummer, const int& aantKleuren, const int kleur[]){
	lijstItem newItem;
	newItem.klantNummer=klantNummer;
	newItem.aantKleuren=aantKleuren;
	for (int i=0;i<aantKleuren;i++){
		newItem.kleur[i]=kleur[i];
	}
	lijst.push_back(newItem);	
}

void Lijst::printLijst(){
	int counter=1;
	for (std::list<lijstItem>::const_iterator i=lijst.begin(), end=lijst.end();i!=end;++i){
       	std::cout<<counter<<" Klantnummer: "<<(*i).klantNummer<<" Formulier(en): ";
       	for (int j=0;j<(*i).aantKleuren;j++){
       		switch ((*i).kleur[j]){
       			case BLAUW:
       				std::cout<<"blauw ";
       				break;
       			case GROEN:
       				std::cout<<"groen ";
       				break;
       			case GEEL:
       				std::cout<<"geel ";
       				break;
       		}
       	}
       	std::cout<<std::endl;
    }
};


