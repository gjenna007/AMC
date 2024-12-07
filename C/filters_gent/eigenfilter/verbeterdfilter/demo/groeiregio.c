#include "groeiregio.h"
#include "definities.h"
/* Het laten groeien van de regio's met vergelijkbare grijswaarde */

int Groeiregio(int horl,int verl,int widthl,const int *blurbeeld,int
*scanbijhouder, struct Venster* venster){

	int topvenster, bottomvenster, nieuwtopvenster, nieuwbottomvenster;
	int lrandvenster, rrandvenster, nieuwlrandvenster, nieuwrrandvenster;
	int nietsveranderd=0;
	int aantalpunten=0;
	
	topvenster=bottomvenster=nieuwtopvenster=nieuwbottomvenster=verl;

	lrandvenster=rrandvenster=nieuwlrandvenster=nieuwrrandvenster=horl;
	if(scanbijhouder[horl+widthl*verl]!=0)
	                      return 0;
	
	scanbijhouder[horl+widthl*verl]=1;
	while(nietsveranderd==0){

		int hor1,ver1,hor2,ver2;
		nietsveranderd=1;
		for (ver1=topvenster;ver1<=bottomvenster;ver1++){
			for(hor1=lrandvenster;hor1<=rrandvenster;hor1++){
				if(scanbijhouder[hor1+widthl*ver1]==1){
					nietsveranderd=0;
					scanbijhouder[hor1+widthl*ver1]=2;
					aantalpunten++;
					for(ver2=-1;ver2<=1;ver2++){
						for(hor2=-1;hor2<=1;hor2++){
						  int positie=hor1+hor2+widthl*(ver1+ver2);
							if(scanbijhouder[positie]==0&&
                                                           abs(blurbeeld[positie]-

 								blurbeeld[horl+widthl*verl])<=/*(*/TOLERANTIE/*-1)/60*(blurbeeld[positie]-40)+2*/){

								scanbijhouder[positie]=1;
								if(hor1+hor2<lrandvenster)
								nieuwlrandvenster=hor1+hor2;
								if(hor1+hor2>rrandvenster)
								nieuwrrandvenster=hor1+hor2;
								if(ver1+ver2<topvenster)
								nieuwtopvenster=ver1+ver2;
								if(ver1+ver2>bottomvenster)
								nieuwbottomvenster=ver1+ver2;
							}
						}
					}
				}
			}
		}
		
		lrandvenster=nieuwlrandvenster;
		rrandvenster=nieuwrrandvenster;
		topvenster=nieuwtopvenster;
		bottomvenster=nieuwbottomvenster;
	}
venster->lrand=lrandvenster;
venster->rrand=rrandvenster;
venster->trand=topvenster;
venster->brand=bottomvenster;
return (aantalpunten);
}


