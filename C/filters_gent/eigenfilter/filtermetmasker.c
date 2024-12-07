 #include <Imlib.h>
 #include <math.h>
 #include <stdlib.h>
 #include <stdio.h>
 #define mask 11
 #define tolerantie 4/*De range waarin de grijswaarden
 mogen afwijken om tot hetzelfde gebied gerekend te worden*/
 #define thetax 1
 #define thetay 0/* De vector (thetax,thetay) bepaalt de hoek
                          waaronder we de overgangen bekijken;
                    b.v.  thetax=thetay=1 levert een hoek van 45 graden*/
 #define intersampling 1 /*De zg "intersamplimg-space"*/
 #define mingebiedsgrootte 100
 #define maxgebiedsgrootte 150000
 #define kleurstap 8/*De lengte van een ribbe van de kleurkubus*/
 #define maxaantiteraties 12
 #define bottomcontrast 7000
 #define topcontrast 10000

 /*Hier komen alle functies*/
   void Filter(int,int,int,ImlibImage*,ImlibImage*,ImlibImage*,int*,int*,
                                     int*,FILE*,/*FILE*,FILE*,*/FILE*,
                                     FILE*,ImlibImage*,int*,int);
   int  Groeiregio(int,int,int,int*,int*,int*);
   void Cooc(int,int,int,ImlibImage*,int*,int*,double*);
   double BerekenUniformiteit(double*);
   double BerekenContrast(double*);
/* double  BerekenInvdiffmoment(double*);
   double BerekenEntropie(double*);*/
/* double BerekenCorrelatie(int*);*/
   void Beeldblurren(ImlibImage*,int*,int,int,int);
/*   void Beeldcompressen(ImlibImage*,int*,int,int);*/
   void RGBGelijk(ImlibImage*,int,int);
   void InitScanbijhouder(int*,int,int,int,ImlibImage*);
   void GebiedDeactiveren(int,int*,int*);
   void KleurGebiedje(ImlibImage*,int,int*,int*,int*);
   void PasVulkleurAan(int*);
   void InitVulkleur(int*);
   int RibbeVakje();
   void TekenKleurpalet(ImlibImage*,int*,int,int*);
   void PasKleurpalethorverAan(int*,int);
   int FilterKnop(double);
   void PasCrimminfilterToe(ImlibImage*,ImlibImage*,
                           int,int*,int*,double);
   void Beeldaanpassen(ImlibImage*,ImlibImage*,int,int*);

 int main() {

/*Hier komen de variabelen*/
   ImlibData *dechtbeeld;
   ImlibData *dresultaatbeeld;
   ImlibData *dgefilterdbeeld;
   ImlibData *dkleurpalet;
   ImlibData *dsilhouet;
   ImlibImage *echtbeeld;
   ImlibImage *resultaatbeeld;
   ImlibImage *gefilterdbeeld;
   ImlibImage *kleurpalet;
   ImlibImage *silhouet;
   int *blurbeeld;
   int *scanbijhouder;
   int *kleur;
   int *kleurpalethorver;
   FILE *fpuniformiteit;
   FILE *fpcontrast;
  /*FILE *fpinvdiffmoment;
   FILE *fpentropie;*/
   FILE *fpgebiedsgrootten;
   Display *disp;
   int width,height,hor,ver,range;
   int kleurpaletafmeting;
/* Creëren van de files waarin ik de resultaten ga wegschrijven*/
   fpuniformiteit=fopen("compuniformiteit","w");
   fpcontrast=fopen("compacontrast","w");
  /* fpinvdiffmoment=fopen("invdiffmoment","w");
   fpentropie=fopen("entropie","w");*/
   fpgebiedsgrootten=fopen("compgebiedsgrootten","w");
/* Hier komen alle files waarin weggeschreven wordt*/
   disp=XOpenDisplay(NULL);
/* Immediately afterwards Intitialise Imlib */
   dechtbeeld =Imlib_init(disp);
   dresultaatbeeld=Imlib_init(disp);
   dgefilterdbeeld=Imlib_init(disp);
   dkleurpalet=Imlib_init(disp);
   dsilhouet=Imlib_init(disp);
/* Load the image specified as the first argument */
   echtbeeld =Imlib_load_image(dechtbeeld,"comprodts05.tif");
   resultaatbeeld=Imlib_load_image(dresultaatbeeld,"rodts05.tif");
   gefilterdbeeld=Imlib_load_image(dgefilterdbeeld,"rodts05.tif");
   kleurpalet=Imlib_load_image(dkleurpalet,"kleurpalet.tif");
   silhouet=Imlib_load_image(dsilhouet,"silhouetrodts05.tif");/*Met de functie
                          echomask.m bepaal je dit silhouet. Mbv scanbijhouder
                          zorg je dat de te filteren regio's alleen daarbinnen
                          gegroeid worden.*/
/* Suck the image's original width and height out of the Image structure */
   width=echtbeeld->rgb_width;
   height=echtbeeld->rgb_height;

/*Dan kunnen we nu ruimte voor de diverse tabellen alloceren*/
   scanbijhouder=calloc(width*height,sizeof(int));/*de waarden in scanbijhouder hebben
                                                  de volgende betekenis:
                                                  0=nog niets mee gebeurd
                                                  1=behoort tot groeigebied, moet nog
                                                                        gescand worden
                                                  2=behoort tot groeigebied, en is al
                                                                               gescand
                                                  3=hoeft nooit meer bekeken te worden*/
   blurbeeld=calloc(width*height,sizeof(int));
   kleur=calloc(3,sizeof(int));/* R,G,B */
   kleurpalethorver=calloc(2,sizeof(int));/*Horizontaal,vertikaal*/
   range=mask/2;
/* Eerst zorgen we dat de R, de B, en de G-waarden zeker gelijk zijn*/
   RGBGelijk(echtbeeld,width,height);
/*Nu gaan we een gemiddeldewaardefilter op het beeld loslaten,
                               en zodoende "blurbeeld" construeren */
 Beeldblurren(echtbeeld,blurbeeld,width,height,range);
 /*  Beeldcompressen(echtbeeld,blurbeeld,width,height);*/
/*Nu maken een randje in "scanbijhouder", om het gebied waarin we de regio's
                                             gaan afbakenen te begrenzen*/
   InitScanbijhouder(scanbijhouder,width,height,range,silhouet);

/*Nu maken we een rooster war het kleurpalet in getekend kan worden*/
kleurpaletafmeting=RibbeVakje();
/* We definieren de eerste vulkleur*/
    InitVulkleur(kleur);	
/* En nu gaan we het filter toepassen */
for (ver=range;ver<height-range;ver++){
  for (hor=range;hor<width-range;hor++){
    if (scanbijhouder[hor+width*ver]==0){
      Filter(hor,ver,width,echtbeeld,resultaatbeeld,gefilterdbeeld,
            scanbijhouder, blurbeeld,kleur,fpuniformiteit,
             fpcontrast,/*fpinvdiffmoment,fpentropie,*/
             fpgebiedsgrootten,kleurpalet,kleurpalethorver,
                                                    kleurpaletafmeting);}
    }
  printf("%d\n",ver);
  }
/* En nu het ingekleurde beeld wegschrijven*/
Imlib_save_image_to_ppm(dresultaatbeeld, resultaatbeeld, "a.ppm");
Imlib_save_image_to_ppm(dkleurpalet, kleurpalet, "b.ppm");
Imlib_save_image_to_ppm(dechtbeeld, echtbeeld, "c.ppm");
/* Alles netjes afstluiten en beëindigen*/
   fclose(fpuniformiteit);
   fclose(fpcontrast);
 /*fclose(fpinvdiffmoment);
   fclose(fpentropie);*/
   fclose(fpgebiedsgrootten);
   free(scanbijhouder);
   free(blurbeeld);
   return 0;
}

/* Het daadwerkelijke filter*/

void Filter(int hor, int ver, int width, ImlibImage *echtbeeld,
             ImlibImage *resultaatbeeld,ImlibImage *gefilterdbeeld,
             int *scanbijhouder, int *blurbeeld,
             int *kleur, FILE *fpuniformiteit, FILE *fpcontrast,/*
             FILE *fpinvdiffmoment, FILE *fpentropie,*/
             FILE *fpgebiedsgrootten, ImlibImage *kleurpalet,
             int *kleurpalethorver, int kleurpaletafmeting){

  int *venster;
  double *coocmatrix;
  int aantalpunten;
  double uniformiteit ,contrast/*,invdiffmoment, entropie*,correlatie*/;
  venster=malloc(4*sizeof(int));/*lrandvenster,rrandvenster,topvenster
                                                    ,bottomvenster*/
  coocmatrix=calloc(256*256,sizeof(double));

   aantalpunten=Groeiregio(hor, ver, width, blurbeeld, scanbijhouder,venster);
   if (aantalpunten>mingebiedsgrootte&&
       aantalpunten<maxgebiedsgrootte){ /*Al te kleine gebieden wordt niets
                                                              mee gedaan*/
   Cooc(hor, ver, width, echtbeeld, scanbijhouder, venster, coocmatrix);
   KleurGebiedje(echtbeeld,width,venster,scanbijhouder,kleur);
   TekenKleurpalet(kleurpalet,kleurpalethorver,kleurpaletafmeting,kleur);
   PasKleurpalethorverAan(kleurpalethorver,kleurpaletafmeting);
   PasVulkleurAan(kleur);
   contrast=BerekenContrast(coocmatrix);
   uniformiteit=BerekenUniformiteit(coocmatrix);
   /*invdiffmoment =BerekenInvdiffmoment(coocmatrix);
   entropie=BerekenEntropie(coocmatrix);*/
   /*correlatie=BerekenCorrelatie(coocmatrix);*/
   PasCrimminfilterToe(resultaatbeeld,gefilterdbeeld,width,scanbijhouder,
                       venster,contrast);
   GebiedDeactiveren(width,venster,scanbijhouder);

   fprintf(fpuniformiteit,"%f\n",uniformiteit);
   fprintf(fpcontrast,"%f\n",contrast);
 /*fprintf(fpinvdiffmoment,"%f\n",invdiffmoment);
   fprintf(fpentropie,"%f\n",entropie);*/
   fprintf(fpgebiedsgrootten,"%d\n",aantalpunten);

  /*Volgens het oorspronkelijke plan ga je nu op het gebied de crimminfilter toepassen,
                              waarbij je het aantal keer dat je filtert af laat hangen van
   statistische waarden die je herkent uit de coocmatrix. Nu denk ik dat het eerst nuttig
                                  is verschillende van die statistische waarden te berekenen
   en die in een filetje weg te schrijven om te kunnen beoordelen hoe je de
                                          filtercoefficient hiervan moet laten afhangen.*/
  }
  free(venster);
  free(coocmatrix);
}

/* Het laten groeien van de regio's met vergelijkbare grijswaarde */

int Groeiregio(int hor,int ver,int width,int *blurbeeld,int *scanbijhouder,int *venster){

	int topvenster, bottomvenster, nieuwtopvenster, nieuwbottomvenster;
	int lrandvenster, rrandvenster, nieuwlrandvenster, nieuwrrandvenster;
	int nietsveranderd=0;
	int aantalpunten=0;
	
	topvenster=bottomvenster=nieuwtopvenster=nieuwbottomvenster=ver;
	lrandvenster=rrandvenster=nieuwlrandvenster=nieuwrrandvenster=hor;
	if(scanbijhouder[hor+width*ver]!=0)
	                      return 0;
	
	scanbijhouder[hor+width*ver]=1;
	while(nietsveranderd==0){

		int hor1,ver1,hor2,ver2;
		nietsveranderd=1;
		for (ver1=topvenster;ver1<=bottomvenster;ver1++){
			for(hor1=lrandvenster;hor1<=rrandvenster;hor1++){
				if(scanbijhouder[hor1+width*ver1]==1){
					nietsveranderd=0;
					scanbijhouder[hor1+width*ver1]=2;
					aantalpunten ++;
					for(ver2=-1;ver2<=1;ver2++){
						for (hor2=-1;hor2<=1;hor2++){
							int positie=hor1+hor2+width*(ver1+ver2);
							if (scanbijhouder[positie]==0&&
							                     abs(blurbeeld[positie]-
								blurbeeld[hor+width*ver])<=tolerantie){
								scanbijhouder[positie]=1;
								if (hor1+hor2<lrandvenster)
									nieuwlrandvenster=hor1+hor2;
								if (hor1+hor2>rrandvenster)
									nieuwrrandvenster=hor1+hor2;
								if (ver1+ver2<topvenster)
									nieuwtopvenster=ver1+ver2;
								if (ver1+ver2>bottomvenster)
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
venster[0]=lrandvenster;
venster[1]=rrandvenster;
venster[2]=topvenster;
venster[3]=bottomvenster;
return (aantalpunten);
}


/* Het uitrekenen van de coocurrentiematrix van een gebiedje*/

void Cooc(int hor,int ver, int width,ImlibImage *echtbeeld,
                              int *scanbijhouder,int *venster, double *coocmatrix){

	int hor1, ver1;
	int overgangentotaal=0;
	for (ver1=venster[2];ver1<=venster[3];ver1++){
		for (hor1=venster[0];hor1<=venster[1];hor1++){
			int positiekern=hor1+width*ver1;
			int positiebuur=hor1+intersampling*thetax+width*(ver1-intersampling*thetay);
			if (scanbijhouder[positiekern]==2&&scanbijhouder[positiebuur]==2){
			  int grijsw1=echtbeeld->rgb_data[positiekern];
			  int grijsw2=echtbeeld->rgb_data[positiebuur];
			  double temp=coocmatrix[grijsw1+256*grijsw2];
			  coocmatrix[grijsw1+256*grijsw2]=temp+1;
			  overgangentotaal ++;
			}
	  }
	}
  if (overgangentotaal!=0){
    for (ver1=0;ver1<256;ver1++){
      for (hor1=0;hor1<256;hor1++){
      double temp=coocmatrix[hor1+256*ver1];
        coocmatrix[hor1+256*ver1]=temp/overgangentotaal;
      }
    }
  }
}

/*Gebiedje wat juist gebruikt is om de coocmatrix mee uit te rekenen, 'bij de
                                                   achtergrond trekken'*/

void GebiedDeactiveren(int width, int *venster,int *scanbijhouder){
int hor1,ver1;
for(ver1=venster[2];ver1<=venster[3];ver1++){
  for(hor1=venster[0];hor1<=venster[1];hor1++){
    if (scanbijhouder[hor1+width*ver1]==2)
      scanbijhouder[hor1+width*ver1]=3;
  }
}
}

/*Aan de hand van de coocmatrix rekenen we verschillende
                                  statistische parameters uit*/

/*Uniformiteit*/

double BerekenUniformiteit(double *coocmatrix){
int hor1,ver1;
double som=0;
for (ver1=0;ver1<256;ver1++){
  for (hor1=0;hor1<256;hor1++){
    som+=coocmatrix[hor1+256*ver1]*coocmatrix[hor1+256*ver1];
  }
}
return(som);
}

/*Contrast*/

double BerekenContrast (double *coocmatrix){
int hor1,ver1;
double som=0;
for (ver1=0;ver1<256;ver1++){
  for (hor1=0;hor1<256;hor1++){
    som+=(ver1-hor1)*(ver1-hor1)*coocmatrix[hor1+256*ver1];
  }
}
return(som);
}

/* Inverse Difference Moment*/
/*
double BerekenInvdiffmoment(double *coocmatrix){
int hor1,ver1;
double som=0;
for (ver1=0;ver1<256;ver1++){
  for (hor1=0;hor1<256;hor1++){
    som+=coocmatrix[hor1+256*ver1]/(1+(hor1-ver1)*(hor1-ver1));
  }
}
return(som);
}
*/
/*Entropie*/
/*
double BerekenEntropie(double *coocmatrix){
int hor1,ver1;
double som=0;
for (ver1=0;ver1<256;ver1++){
  for (hor1=0;hor1<256;hor1++){
    if(coocmatrix[hor1+256*ver1]!=0)
      som-=coocmatrix[hor1+256*ver1]*log(coocmatrix[hor1+256*ver1]);
  }
}
return(som);
}
*/
 /*Correlatie*/
/*
double BerekenCorrelatie(int *coocmatrix){
int hor1,ver1;
double mux,muy,sigmax,sigmay,som=0;
for

		
Dit moeten we nog eens goed uitzoeken*/	

/* Gemiddeldewaarde filter op beeld toepassen, met mask*mask window*/
			
void Beeldblurren(ImlibImage *echtbeeld,int *blurbeeld,int width,
                                              int height,int range){

    int hor,ver,hor1,ver1,som;
    hor = range;
   while (hor<width-range) {
     ver = range;
     while (ver<height-range) {
       int index = hor+width*ver;
       som = 0;
       for (ver1= -range; ver1<=range; ver1++) {
	       for (hor1= -range; hor1<=range; hor1++) {
		     som += echtbeeld->rgb_data[index*3+(hor1+ver1*width)*3];
         }
       }
     blurbeeld[index]=som/(mask*mask);
     ver++;
     }
     hor ++;
   }
}

/*Gelijk maken van de R,G,en B-waarden*/

void RGBGelijk(ImlibImage*echtbeeld,int width,int height){

  int hor,ver,som;
  for (ver=0;ver<height;ver++){
    for (hor=0;hor<width;hor++){
      int index=(hor+width*ver);
      som=echtbeeld->rgb_data[index]+echtbeeld->rgb_data[index+1]+
                                                echtbeeld->rgb_data[index+2];
      echtbeeld->rgb_data[index]=echtbeeld->rgb_data[index+1]=
                                      echtbeeld->rgb_data[index+2]=som/3;
    }
  }
}

/*De rand aangeven waarbinnen de gebiedjes kunnen groeien*/

void InitScanbijhouder(int *scanbijhouder,int width,int height,int range,
                                         ImlibImage *silhouet){

  int hor,ver,index;
  for (hor=range-1;hor<=width-range;hor++){
	   scanbijhouder[hor+(range-1)*width]=
	                                    scanbijhouder[hor+(height-range)*width]=3;
   }
   for (ver=range;ver<height-range;ver++){
	   scanbijhouder[range-1+width*ver]=
	                                    scanbijhouder[width-range+ver*width]=3;
   }
   for(ver=0;ver<height;ver++){
     for(hor=0;hor<width;hor++){
     index=hor+ver*width;
     if(silhouet->rgb_data[index*3]==0)
        scanbijhouder[index]=3;
     }
   }
}

/*Een gebiedje waarvan de coocurrentiematrix berekend is, kleuren*/

void KleurGebiedje(ImlibImage *echtbeeld, int width, int *venster,
                                          int *scanbijhouder, int *kleur){
int hor1,ver1,index;
for (ver1=venster[2];ver1<=venster[3];ver1++){
  for (hor1=venster[0];hor1<=venster[1];hor1++){
    index=hor1+width*ver1;
    if (scanbijhouder[index]==2){
      echtbeeld->rgb_data[index*3]=kleur[0]*255/kleurstap;
      echtbeeld->rgb_data[index*3+1]=kleur[1]*255/kleurstap;
      echtbeeld->rgb_data[index*3+2]=kleur[2]*255/kleurstap;
    }
  }
}
}

/* Verandert de kleur aan waarmee je het volgende gebiedje vult*/

void PasVulkleurAan(int *kleur){

kleur[0]=kleur[0]+1;
if (kleur[0]>kleurstap){
  kleur[0]=0;
  kleur[1]=kleur[1]+1;
  if (kleur[1]>kleurstap){
    kleur[1]=0;
    kleur[2]=kleur[2]+1;
    if (kleur[2]>kleurstap)
      printf("%s\n","Grotere kleurstap nemen!");
  }
}
}

/* Vastleggen eerste kleur waarmee we gaan vullen*/

void InitVulkleur(int *kleur){

kleur[0]=1;/*We willen het gebruik van grijs vermijden*/
kleur[1]=kleur[2]=0;
}

/*De lengte van de ribbe van 1 kleurpaletvakje uitrekenen*/

int RibbeVakje(){
return (500/ceil(sqrt(kleurstap*kleurstap*kleurstap)));
}
/*Een vakje van het kleurpalet inkleuren*/

void TekenKleurpalet(ImlibImage *kleurpalet,int *kleurpalethorver,
                                           int kleurpaletafmeting,int *kleur){


int hor,ver;
for (ver=kleurpalethorver[1]*kleurpaletafmeting;
                       ver<(kleurpalethorver[1]+1)*kleurpaletafmeting;ver++){
   for(hor=kleurpalethorver[0]*kleurpaletafmeting;
                       hor<(kleurpalethorver[0]+1)*kleurpaletafmeting;hor++){
       int index;
       index=hor+500*ver;
       kleurpalet->rgb_data[index*3]=kleur[0]*255/kleurstap;
       kleurpalet->rgb_data[index*3+1]=kleur[1]*255/kleurstap;
       kleurpalet->rgb_data[index*3+2]=kleur[2]*255/kleurstap;
   }
}
}

/* De coordinaten van het volgende in te kleuren vakje berekenen*/

void PasKleurpalethorverAan(int *kleurpalethorver,int kleurpaletafmeting){

kleurpalethorver[0]=kleurpalethorver[0]+1;
if (kleurpalethorver[0]>=500/kleurpaletafmeting){
  kleurpalethorver[0]=0;
  kleurpalethorver[1]=kleurpalethorver[1]+1;
  if (kleurpalethorver[1]>=500/kleurpaletafmeting)
    printf("%s","er zit een bug in de kleurpalet!");
  }
}


/* Hier wordt berekend hoe het aantal het aantal keer dat gefilterd
wordt (de sterkte van de fitlering) afhangt van de uniformiteit*/

int FilterKnop(double contrast){
if (contrast>topcontrast)
   return 0;
if (contrast<bottomcontrast)
   return maxaantiteraties;
return floor((contrast-topcontrast)*maxaantiteraties/(bottomcontrast-topcontrast));
}

/* Vanaf hier komt het deel van het crimminfilter*/
void PasCrimminfilterToe(ImlibImage *resultaatbeeld,ImlibImage *gefilterdbeeld,
                          int width,int *scanbijhouder,int *venster,
                          double contrast){

int hor,ver,index,filtersterkte;
int  loop=0;
filtersterkte=FilterKnop(contrast);

 while (loop<filtersterkte){
    for (ver=venster[2];ver<=venster[3];ver++){
      for (hor=venster[0];hor<=venster[1];hor++){
        index=(hor+ver*width)*3;
       if (scanbijhouder[index/3]==2){
       if (resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index-width*3]||
              resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index+width*3])
          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]+1;
        if (resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index-width*3]||
            resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index+width*3]){
          if (resultaatbeeld->rgb_data[index]>0)

          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]-1;
        }
        }
       }
     }
  Beeldaanpassen(resultaatbeeld,gefilterdbeeld,width,venster);

    for (ver=venster[2];ver<=venster[3];ver++){
      for (hor=venster[0];hor<=venster[1];hor++){
        index=(hor+ver*width)*3;
        if (scanbijhouder[index/3]==2){
       if (resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index-3]||
            resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index+3])
          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]+1;
        if (resultaatbeeld->rgb_data[index]>gefilterdbeeld->rgb_data[index-3]||
             resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index+3]){

          if (resultaatbeeld->rgb_data[index]>0)
          gefilterdbeeld->rgb_data[index]=gefilterdbeeld->rgb_data[index]-1;
        }
        }
       }
     }
 Beeldaanpassen(resultaatbeeld,gefilterdbeeld,width,venster);

    for (ver=venster[2];ver<=venster[3];ver++){
      for (hor=venster[0];hor<=venster[1];hor++){
        index=(hor+ver*width)*3;
        if (scanbijhouder[index/3]==2){
        if (resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index-width*3+3]||
           resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index+width*3-3])
          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]+1;
        if (resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index-width*3+3]||
            resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index+width*3-3]){
          if (resultaatbeeld->rgb_data[index]>1)
          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]-1;
        }
        }
      }
    }
 Beeldaanpassen(resultaatbeeld,gefilterdbeeld,width,venster);

    for (ver=venster[2];ver<=venster[3];ver++){
      for (hor=venster[0];hor<=venster[1];hor++){
        index=(hor+ver*width)*3;
        if (scanbijhouder[index/3]==2){
        if (resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index-width*3-3]||
            resultaatbeeld->rgb_data[index]<resultaatbeeld->rgb_data[index+width*3+3])
          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]+1;
        if (resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index-width*3-3]||
          resultaatbeeld->rgb_data[index]>resultaatbeeld->rgb_data[index+width*3+3]){
          if (resultaatbeeld->rgb_data[index]>1)
          gefilterdbeeld->rgb_data[index]=resultaatbeeld->rgb_data[index]-1;
        }
        }
      }
    }
 Beeldaanpassen(resultaatbeeld,gefilterdbeeld,width,venster);
 loop++;
  }
}

/* De definities van de functies */

void Beeldaanpassen(ImlibImage *resultaatbeeld, ImlibImage *gefilterdbeeld,
                                                     int width,int *venster){

int v,h,index;
for(v=venster[2];v<=venster[3];v++){
  for (h=venster[0];h<=venster[1];h++){
    index=(h+width*v)*3;
    resultaatbeeld->rgb_data[index]=gefilterdbeeld->rgb_data[index];
    resultaatbeeld->rgb_data[index+1]=gefilterdbeeld->rgb_data[index];
    resultaatbeeld->rgb_data[index+2]=gefilterdbeeld->rgb_data[index];
  }
}
}
/*
void Beeldcompressen(ImlibImage *echtbeeld,int *blurbeeld,int width,
                                              int height){

int hor,ver,index;
for (ver=0;ver<height;ver++){
  for(hor=0;hor<width;hor++){
    index=hor+ver*width;
    blurbeeld[index]=echtbeeld->rgb_data[index*3];
  }
}
}

*/




