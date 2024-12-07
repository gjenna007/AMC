#include <Imlib.h>
#include "definitions.h"
#include "structures.h"

void Randjemaken(const int*  specklebox, char *resultaatarray,
                 const int width){
  int ver1,hor1;
for (ver1=specklebox[TOP];ver1<=specklebox[BOTTOM];ver1++){
  for(hor1=specklebox[LEFT];hor1<=specklebox[RIGHT];hor1++){
    int ver2,hor2;
    if (resultaatarray[hor1+ver1*width]==3){
      for (ver2=-1;ver2<=1;ver2++){
        for (hor2=-1;hor2<=1;hor2++){
          if (resultaatarray[hor1+hor2+(ver1+ver2)*width]==0){
           resultaatarray[hor1+hor2+(ver1+ver2)*width]=1;
          }
        }
      }
    resultaatarray[hor1+ver1*width]=2;
    }
  }
}
}
