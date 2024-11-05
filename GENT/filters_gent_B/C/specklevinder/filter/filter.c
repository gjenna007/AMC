#include <Imlib.h>
#include <math.h>
#include "definitions.h"
#include "structures.h"

void Filter(const ImlibImage* beeld, ImlibImage* resultaat, const int* venster,
            const pixel* rand, const int randlengte, int* specklebijhouder,
            int beslissing){

  //We beginnen met op de plaats van de speckle het gemiddelde van de rand te zetten
  //Later kunnen we meer ingewikkelde dingen uitproberen
  int teller,ver,hor,width;
  double sum,mean;
  sum=0;
  width=beeld->rgb_width;
  for (teller=0;teller<randlengte;teller++){
    int positie;
    positie=rand[teller].hor+width*rand[teller].ver;
    sum=sum+resultaat->rgb_data[positie*3];
  }
  mean=floor(sum/((double) randlengte));
  if(mean<0) mean=0;
  if(mean>255) mean=255;
  for(ver=venster[TOP];ver<=venster[BOTTOM];ver++){
    for(hor=venster[LINKS];hor<=venster[RECHTS];hor++){
      int positie;
      positie=hor+width*ver;
      if(beeld->rgb_data[positie*3]==0&&
         beeld->rgb_data[positie*3+1]==0&&
         beeld->rgb_data[positie*3+2]==255&&//
         specklebijhouder[positie]==3//&&
         //beslissing==255
         ){
         //printf("%f\n",sum);
	
	resultaat->rgb_data[positie*3]= mean;
        resultaat->rgb_data[positie*3+1]= mean;
        resultaat->rgb_data[positie*3+2]= mean;
        specklebijhouder[positie]=1;
       
      }
    }
  }
}


