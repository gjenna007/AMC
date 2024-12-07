#include <Imlib.h>
#include "structures.h"

pixel Zoektop(const ImlibImage* beeld, const ImlibImage* silhouet,
	      const int* specklebijhouder, int beginver, int beginhor){

int width,doorzoeken;
pixel outputpixel;
width=beeld->rgb_width;
doorzoeken=1;
printf("%d%c%d%s",beginver,' ',beginhor,", ");
while (doorzoeken==1){
  int scanver,scanhor;
    scanver=-1;
    scanhor=-1;
    while (1==1){
        int ver,hor;
        int positie,beginpositie;
    	ver=beginver+scanver;
    	hor=beginhor+scanhor;
    	beginpositie=beginhor+beginver*width;
    	positie=hor+ver*width;
    	
      if(silhouet->rgb_data[positie*3]!=0){
        if(specklebijhouder[positie]==0){     	
           if(beeld->rgb_data[positie*3]>beeld->rgb_data[beginpositie*3]){     	
    	      beginver=ver;
    	      beginhor=hor;
    	      break;
   	    }
         }
       }
   		
   	scanhor++;
    	if(scanhor>1){
    	   scanhor=-1;
    	   scanver++;
    	   if(scanver>1){
    	     doorzoeken=0;
    	     break;
    	    }
    	  }
    }
// Hier springen de beide "breaks" naartoe.
}
//printf("%d%c%d\n",beginver,' ',beginhor);
outputpixel.ver=beginver;
outputpixel.hor=beginhor;
return(outputpixel);
}




