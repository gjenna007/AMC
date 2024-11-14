#include <iostream>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int main(int argc, char** argv) {
	srand (time(NULL));
	Dobbelsteen die;
	int loop=1;
	while (loop==1){
		string choice;
		std::cout<<"Nog een keer gooien? (y/n)?"<<endl;
		std::cin>>choice;
		
		if (choice=="Y" || choice=="y"){
			die.rollDie(); 
			std::cout<<die.getValue()<<endl;
		}else{
			loop=0;
		}
	return 0;
}
