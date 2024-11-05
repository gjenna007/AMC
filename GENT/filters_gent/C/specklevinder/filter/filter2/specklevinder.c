#include <Imlib.h>
#include "structures.h"
#include "definitions.h"

//Het hoofdprogramma

int main(){
int ver;
pixel rand[SPECKLELENGTE];
ImlibData *dbeeld;
ImlibData *dsilhouet;
ImlibData *dresultaat;
ImlibData *dcompbeeld;
//ImlibData *dorig;

ImlibImage *beeld;
ImlibImage *silhouet;
ImlibImage *resultaat;
ImlibImage *compbeeld;
//ImlibImage *orig;

Display *disp;
int* specklebijhouder;
disp=XOpenDisplay(NULL);

dbeeld=Imlib_init(disp);
dsilhouet=Imlib_init(disp);
dresultaat=Imlib_init(disp);
dcompbeeld=Imlib_init(disp);
//dorig=Imlib_init(disp);

beeld=Imlib_load_image(dbeeld,BEELD);
silhouet=Imlib_load_image(dsilhouet,SILHOUET);
resultaat=Imlib_load_image(dresultaat,ORIG);
compbeeld=Imlib_load_image(dcompbeeld,COMPBEELD);
//orig=Imlib_load_image(dorig,ORIG);

specklebijhouder=calloc((silhouet->rgb_width)*(silhouet->rgb_height),sizeof(int));
for (ver=TOPKADER;ver<=BOTTOMKADER;ver++){
   int hor,breedte;
   breedte=silhouet->rgb_width;
   for(hor=0;hor<breedte;hor++){
       //printf("%d%c%d%c%d",ver,' ',hor,' 
//',silhouet->rgb_data[(hor+ver*breedte)*3]);
       //printf("%c%d\n",' ',specklebijhouder[hor+breedte*ver]);
       //pintf("%c%d
       if ((silhouet->rgb_data[(hor+breedte*ver)*3]==255)&&
	  (specklebijhouder[hor+breedte*ver]==0)&&
	  (beeld->rgb_data[(hor+breedte*ver)*3]==0)&&
	  (beeld->rgb_data[(hor+breedte*ver)*3+1]==0)&&
	  (beeld->rgb_data[(hor+breedte*ver)*3+2]==255)){
	  int venster[4];
	  pixel witstepunt;
          int randlengte,beslissing;
          witstepunt.ver=ver;
          witstepunt.hor=hor;
	  specklebijhouder[hor+breedte*ver]=2;
	  Groeispeckle(beeld,silhouet,specklebijhouder,witstepunt,venster);
	  randlengte=Randjemaken(beeld,specklebijhouder,venster,rand);
          beslissing=Klassificeer(compbeeld,witstepunt); 	
          Filter(beeld,resultaat,venster,rand,randlengte,specklebijhouder,
                 beslissing);         
       }
   }
}
Imlib_save_image_to_ppm(dresultaat,resultaat,RESULTAATBEELD);
free(specklebijhouder);
return 0;
}	
	








				


