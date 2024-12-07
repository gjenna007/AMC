#include <Imlib.h>
#include "definitions.h"

void Kaderen(ImlibImage* silhouet){

int width,height,ver,hor;
width=silhouet->rgb_width;
height=silhouet->rgb_height;
for (ver=0;ver<TOPKADER;ver++){
  for (hor=0;hor<width;hor++){
  int positie;
  positie=hor+width*ver;
  silhouet->rgb_data[positie*3]=0;
  silhouet->rgb_data[positie*3+1]=0;
  silhouet->rgb_data[positie*3+2]=0;
  }
}
for (ver=BOTTOMKADER;ver<height;ver++){
  for (hor=0;hor<width;hor++){
  int positie;
  positie=hor+width*ver;
  silhouet->rgb_data[positie*3]=0;
  silhouet->rgb_data[positie*3+1]=0;
  silhouet->rgb_data[positie*3+2]=0;
  }
}
}
