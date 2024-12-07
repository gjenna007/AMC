#include <Imlib.h>
#include "definitions.h"
#include "structures.h"

int Randjemaken(const ImlibImage *beeld, int *specklebijhouder,
                 const int *venster, pixel *rand){
int ver1,hor1,width,i;
width=beeld->rgb_width;
 i=0;
for (ver1=venster[TOP];ver1<=venster[BOTTOM];ver1++){
  for(hor1=venster[LINKS];hor1<=venster[RECHTS];hor1++){
    int ver2,hor2;
    if (specklebijhouder[hor1+ver1*width]==3){
      for (ver2=-1;ver2<=1;ver2++){
        for (hor2=-1;hor2<=1;hor2++){
          if (specklebijhouder[hor1+hor2+(ver1+ver2)*width]==0){
           specklebijhouder[hor1+hor2+(ver1+ver2)*width]=6;
           rand[i].ver=ver1+ver2;
           rand[i].hor=hor1+hor2;
           i++;
           }
         }
       }
     }
   }
}
for (ver1=venster[TOP]-1;ver1<=venster[BOTTOM]+1;ver1++){
  for(hor1=venster[LINKS]-1;hor1<=venster[RECHTS]+1;hor1++){
     if (specklebijhouder[hor1+ver1*width]==6) specklebijhouder[hor1+ver1*width]=0;
  }
}
return (i);
}
