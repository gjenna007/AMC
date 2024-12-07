#include <Imlib.h>
#include <stdio.h>
#include "structures.h"
#include "definitions.h"

void Specklekleuren(ImlibImage *resultaat, pixel coordinaten[][SPECKLELENGTE],
                    const int volgnummer, FILE *fpcheck){
int aantalpixels,teller;
aantalpixels=coordinaten[volgnummer][0].ver;
for (teller=1;teller<=aantalpixels;teller++){
  int ver,hor,width;
  width=resultaat->rgb_width;
  ver=coordinaten[volgnummer][teller].ver;
  hor=coordinaten[volgnummer][teller].hor;
  fprintf(fpcheck,"%d%c%d%c%d\n",volgnummer,' ',ver,' ',hor);
  resultaat->rgb_data[(hor+width*ver)*3]=0;
  resultaat->rgb_data[(hor+width*ver)*3+1]=0;
  resultaat->rgb_data[(hor+width*ver)*3+2]=255;
}
}
