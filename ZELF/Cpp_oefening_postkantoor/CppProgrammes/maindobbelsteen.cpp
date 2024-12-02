#include <iostream>
#include<string>
#include"dobbelsteen.h"
using namespace std;

int main(int argc, char** argv) {
	Dobbelsteen dye;
	int loop=1;
	while (loop==1){
		string choice;
		std::cout<<"Nog een keer gooien? (y/n)?"<<endl;
		std::cin>>choice;
		if (choice=="Y" || choice=="y"){
			dye.rollDye(); 
			std::cout<<dye.getValue()<<endl;
		}else{
			loop=0;
		}
	}
		return 0;
}
