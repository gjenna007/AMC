#include <Imlib.h>
#include "definitions.h"

void Randjemaken(const ImlibImage *beeld, int *specklebijhouder,
                 const int *venster, const int speckleteller){
int ver1,hor1,width;
width=beeld->rgb_width;
for (ver1=venster[TOP];ver1<=venster[BOTTOM];ver1++){
  for(hor1=venster[LINKS];hor1<=venster[RECHTS];hor1++){
    int ver2,hor2;
    if (specklebijhouder[hor1+ver1*width]==speckleteller){
      for (ver2=-1;ver2<=1;ver2++){
        for (hor2=-1;hor2<=1;hor2++){
          if (specklebijhouder[hor1+hor2+(ver1+ver2)*width]==0) specklebijhouder[hor1+hor2+(ver1+ver2)*width]=-1;
         }
       }
     }
   }
}
}
