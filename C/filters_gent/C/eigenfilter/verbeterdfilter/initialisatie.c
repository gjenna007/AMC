#include <Imlib.h>
#include "definities.h"
#include "initialisatie.h"
/*Gebied aan geven waarbinnen de regio's kunnen groeien*/
void InitScanbijhouder(int *scanbijhouder,int widthl,int heightl,
                                         const ImlibImage *silhouet){

  int hor1,ver1,index;
  for (hor1=RANGE-1;hor1<=widthl-RANGE;hor1++){
	   scanbijhouder[hor1+(RANGE-1)*widthl]=

scanbijhouder[hor1+(heightl-RANGE)*widthl]=3;
   }
   for (ver1=RANGE;ver1<heightl-RANGE;ver1++){
	   scanbijhouder[RANGE-1+widthl*ver1]=

scanbijhouder[widthl-RANGE+ver1*widthl]=3;
   }
   for(ver1=0;ver1<heightl;ver1++){
     for(hor1=0;hor1<widthl;hor1++){
     index=hor1+ver1*widthl;
     if(silhouet->rgb_data[index*3]==0)
        scanbijhouder[index]=3;
     }
   }
}
/*Eerste kleur vastleggen waarmee we de regio's gaan kleuren*/
void InitVulkleur(struct Kleur *kleur){

kleur->rood=1;/*We willen het gebruik van grijs vermijden*/
kleur->groen=kleur->blauw=0;
}

