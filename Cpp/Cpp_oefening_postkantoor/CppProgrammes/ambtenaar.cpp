#include"klassen.h"

Ambtenaar::Ambtenaar(){
	bezet=false;
}

Ambtenaar::~Ambtenaar(){
}

void Ambtenaar::geefBeurtDoor(Klok& klok,Rij& rij, Lijst& lijst, Ambtenaar ambtenaar[]){
	if (loketNummer<AANTLOKETTEN-1){
		std::cout<<"beurt wordt doorgegeven door loketnummer:"<<loketNummer<<std::endl;
		int ll=rij.getLengte();
		std::cout<<"ambtenaar"<<loketNummer<<" zegt: lengte rij is nu:"<<ll<<std::endl;
		ambtenaar[loketNummer+1].krijgBeurt(klok,rij,lijst, ambtenaar);
	} else {
		klok.krijgBeurt(rij,lijst,ambtenaar[0],ambtenaar);
	}
	return;
}

void Ambtenaar::setLoketNummer(int loket){
	loketNummer=loket;
}

void Ambtenaar::neemTijdAan(Klok& klok){
	huidigeTijd=klok.getTijd();
}

void Ambtenaar::krijgBeurt(Klok& klok, Rij& rij, Lijst& lijst,Ambtenaar ambtenaar[]){
	neemTijdAan(klok);
	if (bezet==true){
		if (huidigeTijd<eindTijdTaak){
			geefBeurtDoor(klok,rij,lijst,ambtenaar);
		} else {
			if (nogEenTaak==false){
				lijst.voegToe(klantNummer,aantForms,formsInBehandeling);
				bezet=false;
				geefBeurtDoor(klok,rij,lijst,ambtenaar);				
			} else {
				Klant nieuweKlant;
				Formulier nieuwFormulier;
				nieuwFormulier.setKleur(GEEL);
				nieuweKlant.geefForm(nieuwFormulier);
				nieuwFormulier.setKleur(GROEN);
				nieuweKlant.geefForm(nieuwFormulier);
				nieuweKlant.setKlantNummer(klantNummer);
				rij.voegKlantToe(nieuweKlant);
				int kleur[1];
				kleur[0]=BLAUW;
				lijst.voegToe(klantNummer,1,kleur);
				bezet=false;
				nogEenTaak=false;
				geefBeurtDoor(klok,rij,lijst,ambtenaar);
			}
		}
		
	} else {// if (bezet==false)
		std::cout<<"ambtenaar zegt: bezet=false"<<std::endl;
		int rijLengte=rij.getLengte();
		if (rijLengte==0 || huidigeTijd<BEGINLENGTE){
			std::cout<<"deze branch nemen we toch he?"<<rijLengte<<std::endl;
			geefBeurtDoor(klok,rij,lijst,ambtenaar);
		} else {
			Klant klant;
			klant=rij.geefEersteKlant();
			huidigeTijd=klok.getTijd();
			aantForms=klant.getAantForms();
			int verwerkingsTijd=0;
			for (int i=0;i<aantForms; i++){
				Formulier form;
				form=klant.vraagForm();
				formsInBehandeling[i]=form.getKleur();
				if (formsInBehandeling[i]==GROEN){
					verwerkingsTijd+=VERWERKINGSTIJDGROEN;
				} else if (formsInBehandeling[i]==GEEL){
					verwerkingsTijd+=VERWERKINGSTIJDGEEL;
				} else if (formsInBehandeling[i]==BLAUW){
					verwerkingsTijd+=VERWERKINGSTIJDBLAUW;
					nogEenTaak=true;	
				}
			}
			eindTijdTaak=huidigeTijd+verwerkingsTijd;
			bezet=true;
			int ll=rij.getLengte();
			std::cout<<"vlak voor beurt doorgegeven werd:"<<ll<<std::endl;
			geefBeurtDoor(klok,rij,lijst,ambtenaar);
		}
	}	
}

