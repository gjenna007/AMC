#include<list>
#include "definities.h"
#include<iostream>

class Formulier{
	public:
		Formulier();
		~Formulier();
		int getKleur() const;	
		void setKleur(int a);
	private:
		int kleur;
};

class Klant{
	public:
		Klant();
		~Klant();
		void setAantForms(int);
		int getAantForms() const;
		void geefForm(Formulier);
		Formulier vraagForm();
		void setBeurt(bool); 
		bool getBeurt() const;
		int getKlantNummer() const;
		void setKlantNummer(int);
	private:
		bool aanDeBeurt;
		int aantalForms;
		std::list<Formulier> formulieren;
		int klantNummer;
};

class Lijst{
	public:
		Lijst();
		~Lijst();
		struct lijstItem{
			int klantNummer;
			int aantKleuren;
			int kleur[2];
		};
		int getLengte();
		void voegToe(const int& klantNummer, const int& aantKleuren, const int kleur[]);
		void printLijst();
	private:
		std::list<lijstItem> lijst;
};

class Rij;
class Ambtenaar;

class Klok{
	public:
		Klok();
		~Klok();
		void setAmbtenaarBezig();
		int getTijd()const;
		void setTijd(int tijdStip);
		void krijgBeurt(Rij& rij,Lijst& lijst, Ambtenaar& eersteLoket,Ambtenaar ambtenaar[]);
	private:
		int huidigeTijd;
		bool ambtenaarBezig;
		void doeTik();
		void printLijst(Lijst& lijst);
};

class Rij{
	public:
		Rij();
		~Rij();
		int getLengte() const;
		void voegKlantToe(Klant);
		void vernietigKlant();
		void krijgBeurt(Klok& klok, Ambtenaar& loket0, Rij& rij,Lijst& lijst, Ambtenaar ambtenaar[]);//de functie krijgBeurt vertelt wat er allemaal moet gebeuren
		Klant geefEersteKlant();
	private:
		void neemTijdAan(const Klok& klok);
		Klant creeerKlant(int nummer);//creert een nieuwe klant en voegt die achteraan de rij toe
		int huidigeTijd;
		std::list<Klant> klanten;
		int klantNummer;//nummerdat aan de volgende klant gegeven kan worden
};

class Ambtenaar{
	public:
		Ambtenaar();
		~Ambtenaar();
		void krijgBeurt(Klok& klok,Rij& rij,Lijst& lijst, Ambtenaar ambtenaar[]);//de functie krijgBeurt vertelt wat er allemaal moet gebeuren
        void setLoketNummer(const int loket);
        void neemTijdAan(Klok& klok);
	private:
		Rij rij;
		Lijst lijst;
		int loketNummer;
		int huidigeTijd;
		bool bezet;
		int klantNummer;//dit is het klantNummer van de klant die nu in behandeling is
		int eindTijdTaak;
		bool nogEenTaak;
		int aantForms;/*aantForms is hier het aantal formulieren dat een ambtenaar
		op een bepaald moment in bezit heeft. Mbv een loopje m oet een klant al 
		zijn formulieren aan de ambtenaar geven */
		void schrijfOpLijst(Lijst,const int i_klantNummer,int*);
		int formsInBehandeling[2];
		void geefBeurtDoor(Klok& klok, Rij& rij, Lijst& lijst, Ambtenaar ambtenaar[]);
};



