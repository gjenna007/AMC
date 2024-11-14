#include"dobbelsteen.h"
#include<time.h>
#include<stdlib.h>

Dobbelsteen::Dobbelsteen(void){
	ogen=1;
}
Dobbelsteen::~Dobbelsteen(void){
}

void Dobbelsteen::rollDye(){
	srand (time(NULL));
	ogen=rand()% 6 + 1;
}

int Dobbelsteen::getValue()const{
	return ogen;
}

