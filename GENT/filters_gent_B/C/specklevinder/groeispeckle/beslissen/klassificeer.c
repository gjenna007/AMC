#include <Imlib.h>
#include "definitions.h"
int Klassificeer(const int seedver, const int seedhor, const int width,
                 const char *resultaatarray, const ImlibImage *compbeeld){

  int sum,teller;
  double mean;
  int ver,hor,beslissing;
  beslissing=BLAUW;
  teller=0;
  sum=0;
  if (seedver>=15){
  for (ver=seedver-15;ver<=seedver+15;ver++){
    for(hor=seedhor-15;hor<=seedhor+15;hor++){
      teller++;
      sum+=compbeeld->rgb_data[(hor+ver*width)*3];
    }
  }  
  mean=sum/teller;
  }
  if (mean<=58) beslissing=ROOD;
  return beslissing;
}

                                  
