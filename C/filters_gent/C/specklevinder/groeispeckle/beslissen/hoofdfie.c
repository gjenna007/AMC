#include <Imlib.h>
#include <stdlib.h>
#include <stdio.h>
#include "definitions.h"
#include "structures.h"
#include "functions.h"
int main(){
 
  ImlibData *dsilhouet;
  ImlibData *dorigineel;
  ImlibData *dcompbeeld;
  ImlibData *dpeaks;
  ImlibData *dresultaat;
  ImlibImage *silhouet;
  ImlibImage *origineel;
  ImlibImage *compbeeld;
  ImlibImage *peaks;
  ImlibImage *resultaat;
  char *resultaatarray;
  gpixel toppen[N_O_TOPS]; //Dit wordt de lijst "seed points"
  int width,height,finger,x,y;
  Display *disp;
  
  disp=XOpenDisplay(NULL);
  dsilhouet=Imlib_init(disp);
  dorigineel=Imlib_init(disp);
  dcompbeeld=Imlib_init(disp);
  dpeaks=Imlib_init(disp);
  dresultaat=Imlib_init(disp);
  silhouet=Imlib_load_image(dsilhouet,SILHOUET);
  origineel=Imlib_load_image(dorigineel,ORIGINEEL);
  compbeeld=Imlib_load_image(dcompbeeld,COMPBEELD);
  peaks=Imlib_load_image(dpeaks,PEAKS);
  resultaat=Imlib_load_image(dresultaat,ORIGINEEL);
  
  width=origineel->rgb_width;
  height=origineel->rgb_height;
  resultaatarray=calloc(width*height,sizeof(char));
  Maketopslist(origineel,peaks,toppen,width,height);
  for (finger=0;finger<N_O_TOPS;finger++){
    printf("%d%c%d\n",finger,' ',toppen[finger].gval);
  }
  printf("%c\n",'z');
  for (finger=0;finger<N_O_TOPS;finger++){
    int seedver,seedhor,seedgrey;
    seedver=toppen[finger].ver;
    seedhor=toppen[finger].hor;
    if (resultaatarray[seedhor+width*seedver]==0){
      int specklebox[4];
      int mean,beslissing;
      specklebox[LEFT]=seedhor;
      specklebox[RIGHT]=seedhor;
      specklebox[TOP]=seedver;
      specklebox[BOTTOM]=seedver;
      seedgrey=toppen[finger].gval;
      Growspeckle(seedver,seedhor,seedgrey,origineel,
                      resultaatarray,silhouet,width,specklebox);
      mean=Randjemaken(specklebox,resultaatarray,width,origineel);
      beslissing=Klassificeer(seedver,seedhor,width,resultaatarray,
                                                        compbeeld);      
      //printf("%d\n",finger);
      for (y=specklebox[TOP]; y<=specklebox[BOTTOM]; y++){
       for (x=specklebox[LEFT]; x<=specklebox[RIGHT]; x++){
         if (resultaatarray[x+width*y]==3){
           resultaat->rgb_data[(x+width*y)*3]=beslissing;
           resultaat->rgb_data[(x+width*y)*3+1]=0;
           resultaat->rgb_data[(x+width*y)*3+2]=255-beslissing;
	   resultaatarray[x+width*y]=2;
         }                  
       }
     }
    }
  }
  
  Imlib_save_image_to_ppm(dresultaat, resultaat, RESULTAAT); 
  free(resultaatarray);
  return 0;
}
