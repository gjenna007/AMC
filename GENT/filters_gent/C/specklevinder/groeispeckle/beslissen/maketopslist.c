#include <Imlib.h>
#include <stdlib.h>
#include "definitions.h"
#include "structures.h"

int cmp(const void *vp, const void *vq);

void Maketopslist (const ImlibImage* origineel, const ImlibImage *peaks,
                   gpixel* toppen, const int width, const int height){

   
  int i,ver,hor;
  i=0;
  //Eerst de lijst aanmaken
  for (ver=0;ver<height;ver++){
    for (hor=0;hor<width;hor++){
      if (peaks->rgb_data[(hor+width*ver)*3]!=0){
        toppen[i].hor=hor;
        toppen[i].ver=ver;
        toppen[i].gval=origineel->rgb_data[(hor+width*ver)*3];
        i++;
      }
    }
  }
  //Daarna de lijst ordenen op grijswaarde (van hoog naar laag)
  qsort(toppen,N_O_TOPS,sizeof(gpixel),cmp);
}

int cmp(const void *vp, const void *vq){

  const gpixel *p=vp;
  const gpixel *q=vq;
  double diff=p[0].gval - q[0].gval;
  return ((diff >= 0.0) ? ((diff > 0.0) ? -1 : 0) : +1);
}



