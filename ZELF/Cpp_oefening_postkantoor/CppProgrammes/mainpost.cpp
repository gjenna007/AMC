#include <iostream>
#include "klassen.h"


int main(int argc, char** argv) {
	
	Klok klok;
	Rij rij;
	Ambtenaar ambtenaar[AANTLOKETTEN];
	for (int i=0;i<AANTLOKETTEN;i++){
		ambtenaar[i].setLoketNummer(i);
	}
	Lijst lijst;
	klok.krijgBeurt(rij,lijst,ambtenaar[0],ambtenaar);
	return 0;
}
