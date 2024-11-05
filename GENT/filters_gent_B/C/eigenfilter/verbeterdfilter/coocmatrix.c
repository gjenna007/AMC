#include <Imlib.h>
#include <assert.h>
#include "coocmatrix.h"
#include "definities.h"
#include "groeiregio.h"

/* Het uitrekenen van de coocurrentiematrix van een gebiedje*/

void Cooc(const ImlibImage *compbeeld,const int *scanbijhouder,
                              const struct Venster *venster,
				 double* coocmatrix){

	int hor1, ver1;
	int overgangentotaal;
	const int width=compbeeld->rgb_width;
	overgangentotaal=0;
	for (ver1=(venster)->trand;ver1<=(venster)->brand;ver1++){
		for (hor1=(venster)->lrand;hor1<=(venster)->rrand;hor1++){
			int positiekern=hor1+width*ver1;
			int positiebuur=hor1+
 			 INTERSAMPLING*THETAX+width*(ver1-INTERSAMPLING*THETAY);
			if (scanbijhouder[positiekern]==2 &&
     			 scanbijhouder[positiebuur]==2){
			  int grijsw1=compbeeld->rgb_data[positiekern*3];
			  int grijsw2=compbeeld->rgb_data[positiebuur*3];
			  assert(grijsw1+256*grijsw2 < 256*256);
			  assert(grijsw1+256*grijsw2 >= 0);
			  coocmatrix[grijsw1+256*grijsw2]++;
			  overgangentotaal ++;
			}
	 	 }
	}
  if (overgangentotaal!=0){
    for (ver1=0;ver1<256;ver1++){
      for (hor1=0;hor1<256;hor1++){
        coocmatrix[hor1+256*ver1]/=overgangentotaal;
      }
    }
  }
}

