#include <Imlib.h>
#include "structures.h"
#include "definitions.h"

//Het hoofdprogramma

int main(){
int ver;
pixel coordinaten[AANTALSPECKLES][SPECKLELENGTE];
ImlibData *dbeeld;
ImlibData *dsilhouet;
ImlibData *dresultaat;

ImlibImage *beeld;
ImlibImage *silhouet;
ImlibImage *resultaat;

FILE* fpcheck;

Display *disp;
int* specklebijhouder;
disp=XOpenDisplay(NULL);
fpcheck=fopen("check","w");

dbeeld=Imlib_init(disp);
dsilhouet=Imlib_init(disp);
dresultaat=Imlib_init(disp);
beeld=Imlib_load_image(dbeeld,BEELD);
silhouet=Imlib_load_image(dsilhouet,SILHOUET);
resultaat=Imlib_load_image(dresultaat,BEELD);
Kaderen(silhouet);//onder en boven een zwart randje maken
specklebijhouder=calloc(silhouet->rgb_width*silhouet->rgb_height,sizeof(int));
for (ver=TOPKADER;ver<=BOTTOMKADER;ver++){
	int hor,breedte;
	breedte=silhouet->rgb_width;
	for(hor=0;hor<breedte;hor++){
		if (silhouet->rgb_data[(hor+breedte*ver)*3]!=0&&
		    specklebijhouder[hor+breedte*ver]==0&&
		    beeld->rgb_data[(hor+breedte*ver)*3]>SPECKLEGRENS){
			int volgnummer;
			int venster[4];
			pixel witstepunt;
			witstepunt=Zoektop(beeld,silhouet,specklebijhouder,ver,hor);
			//if(beeld->rgb_data[(witstepunt.hor+breedte*witstepunt.ver)*3]>SPECKLEGRENS){
					//double raaklijn;
					//vector radiaal;
					//int volgnummer;
					//int venster[4];
					//int vuller;
					volgnummer=Groeispeckle(beeld,silhouet,specklebijhouder,witstepunt,
					                        coordinaten,venster);
					Randjemaken(beeld,specklebijhouder,venster,volgnummer);
					//(vlekje[speckleteller])->n_o_pixels=aant_pixels;
				  //(vlekje[speckleteller])->punt=malloc(aant_pixels*sizeof(pixel));
				  //for(vuller=0;vuller<aant_pixels;vuller++){
				   // (vlekje[speckleteller]->punt)[vuller]=modelspeckle[vuller];
				  //}
				  //raaklijn=Richtingscoefficient(vlekje[speckleteller]);
				  //radiaal=Radiaal(vlekje[speckleteller]);
				  Specklekleuren(resultaat,coordinaten,volgnummer,fpcheck);
			//}
		}
	}
}
//Hier moet je nu nog een routine schrijven die 'coordinaten' wegschrijft.
//Als je ze later weer eens wil gebruiken kun je makkelijk een programmaatje schrijven dat ze inleest:
// misschien kun je daarvoor nu alvast een standaardprogrammaatje schrijven.
Imlib_changed_image(dresultaat,resultaat);
Imlib_save_image_to_ppm(dresultaat,resultaat,RESULTAATBEELD);
free(specklebijhouder);
fclose(fpcheck);
return 0;
}	
	








				


