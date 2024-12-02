#include <Imlib.h>
#include "definitions.h"
#include "structures.h"

void Growspeckle (const int seedver, const int seedhor, const int seedgrey,
                  const ImlibImage* origineel, char* resultaatarray,
                  const ImlibImage* silhouet, const int width,
                  int* specklebox){

  float diff;
  if (resultaatarray[seedhor+width*seedver]==0 &&
      silhouet->rgb_data[(seedhor+width*seedver)*3]!=0){
    diff=seedgrey-origineel->rgb_data[(seedhor+width*seedver)*3];
    if (diff<0) diff=-diff;
    if (diff<RANGE){
      //punt toevoegen en bounding box aanpassen
      resultaatarray[seedhor+width*seedver]=3;
      if (seedhor<specklebox[LEFT]) specklebox[LEFT]=seedhor;
      if (seedhor>specklebox[RIGHT]) specklebox[RIGHT]=seedhor;
      if (seedver<specklebox[TOP]) specklebox[TOP]=seedver;
      if (seedver>specklebox[BOTTOM]) specklebox[BOTTOM]=seedver;
      Growspeckle(seedver,seedhor+1,seedgrey,origineel,
                      resultaatarray,silhouet,width,specklebox);
      Growspeckle(seedver,seedhor-1,seedgrey,origineel,
                      resultaatarray,silhouet,width,specklebox);
      Growspeckle(seedver+1,seedhor,seedgrey,origineel,
                      resultaatarray,silhouet,width,specklebox);
      if (seedver>1) Growspeckle(seedver-1,seedhor,seedgrey,origineel,
      resultaatarray,silhouet,width,specklebox);
    }
  }
}
