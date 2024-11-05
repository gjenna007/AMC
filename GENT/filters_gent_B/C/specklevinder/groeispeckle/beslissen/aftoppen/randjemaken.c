#include <Imlib.h>
#include <math.h>
#include "definitions.h"
#include "structures.h"

int Randjemaken(const int*  specklebox, char *resultaatarray,
                 const int width, const ImlibImage* origineel){
  int ver1,hor1;
  double teller,sum;
for (ver1=specklebox[TOP];ver1<=specklebox[BOTTOM];ver1++){
  for(hor1=specklebox[LEFT];hor1<=specklebox[RIGHT];hor1++){
    int ver2,hor2;
    if (resultaatarray[hor1+ver1*width]==3){
      for (ver2=-1;ver2<=1;ver2++){
        for (hor2=-1;hor2<=1;hor2++){
          if (resultaatarray[hor1+hor2+(ver1+ver2)*width]<=1){
              resultaatarray[hor1+hor2+(ver1+ver2)*width]=100;
          }
        }
      }
      // resultaatarray[hor1+ver1*width]=2;
    }
  }
}
 teller=0;
 sum=0;
 for (ver1=specklebox[TOP]-1;ver1<=specklebox[BOTTOM]+1;ver1++){
   for(hor1=specklebox[LEFT]-1;hor1<=specklebox[RIGHT]+1;hor1++){
     if (resultaatarray[hor1+ver1*width]==100){
       teller++;
       sum+=origineel->rgb_data[(hor1+width*ver1)*3];
       resultaatarray[hor1+ver1*width]=1;
     }
   }
 }
 return floor((sum/teller) + 1);
}
