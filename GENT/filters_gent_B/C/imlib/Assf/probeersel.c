 #include <Imlib.h>
 #include <math.h>
 #include <stdio.h>
 #include <stdlib.h>

 #define mask 11
 #define avanbeta 0.001
 #define bvanbeta 0.05
 #define cvanbeta 0
 #define kvanmerge 5
 #define deltamuvanmerge 5
 #define intersample 1
 #define thetax 0
 #define thetay 0

 void Omgeving (int, int, int, char *, int,int, double *,int, double *, double *);
 double Beta (double, int, double *, double *);
 void Buren (int, int, int, char *,int,double *,int,double *, double *);
 void Burenboven (int, int, int, char *,int,double *,int,double *, double *);
 void Burenrechts (int, int, int, char *,int,double *,int,double *, double *);
 void Burenonder (int, int, int, char *,int,double *,int,double *, double *);
 void Burenlinks (int, int, int, char *,int,double *,int,double *, double *);
 int cmp(const void *vp,const void *vq);
 void Scan(int,int,char**,int,int,int,int,char**,char**,int,int,int);


 int main(int argc, char **argv)
   {
     ImlibData *id;
     ImlibData *id2;
     ImlibImage *im;
     ImlibImage *im2;

     const  int range=mask/2;
     const int centralpixel=((mask+2)*(mask+2))/2;
     int w,h,hor1,ver1,hteller,vteller,teller;
     int lookupsize;
     double *alpha;
     double *mean;
     double *betadomein;
     double *betabeeld;
     char  **pixelomgeving;
     char **mergeomgeving;
     char **mergebijhouder;
  /*   int Pcooc[256*256];*/ /* In deze matrix wordt het aantal grijsovergangen bijgehouden.
                            Pcooc(i,j)=#overgangen van grijswaarde i naar grijswaarde j*/
/*     double pcooc[256*256];*/ /* Dit is de echte cooccurrentiematrix. coocp(i,j)=coocP(i,j)/P */

     Display *disp;

    disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
    id =Imlib_init(disp);
    id2=Imlib_init(disp);

 /* Load the image specified as the first argument */
    im =Imlib_load_image(id,"deruddere03.tif");
    im2=Imlib_load_image(id2,"deruddere03.tif");
 /* Suck the image's original width and height out of the Image structure */
    w=im->rgb_width;
    h=im->rgb_height;
    lookupsize=(w-2*range)*(h-2*range);/* Dit wordt de grootte van de look-up table */

/* Zeker stellen dat in de R, de G, en de B coordinaat inderdaad dezelfde waarde staat */

for (hor1=0;hor1<w;hor1++){
  int gemiddelde;
  for (ver1=0;ver1<h;ver1++){
    gemiddelde=(im->rgb_data[(hor1+w*ver1)*3]+im->rgb_data[(hor1+w*ver1)*3+1]+
    im->rgb_data[(hor1+ver1*w)*3+2])/3;
    im->rgb_data[(hor1+w*ver1)*3]=gemiddelde;
    im->rgb_data[(hor1+w*ver1)*3+1]=gemiddelde;
    im->rgb_data[(hor1+w*ver1)*3+2]=gemiddelde;
  }
}


/* Geheugenruimte reserveren voor de verschillende tabellen */
    mean = malloc(w*h*sizeof(double));/* mean en alpha zijn iets te groot,
                                          maar vanwege de manier waarop ik
                                         ze invul moet dat ook */
    alpha = malloc(w*h*sizeof(double));
    betadomein = malloc(lookupsize*sizeof(double));/* deze kunnen wel precies
                                             groot genoeg gemaakt worden */
    betabeeld = malloc(lookupsize*sizeof(double));
    mergeomgeving = malloc(3*mask*sizeof(char*));
    {for(hor1=0;hor1<3*mask;hor1++)
      mergeomgeving[hor1]=malloc(3*mask*sizeof(char));}
    mergebijhouder = malloc((2*mask+1)*sizeof(char*));
     { for(hor1=0;hor1<2*mask+1;hor1++)
        mergebijhouder[hor1]=malloc((2*mask+1)*sizeof(char));}
    pixelomgeving = malloc(w*h*sizeof(char *));
   { for (hor1=0;hor1<w*h;hor1++)
        pixelomgeving[hor1] = calloc((mask+2)*(mask+2), sizeof(char));}

/* De pixelomgevingen initialiseren */

for (hor1=0;hor1<w*h;hor1++)
  pixelomgeving[hor1][centralpixel]=1;

/* De tabel "mean" aanmaken */

    teller=0;
   hor1= range;
   while (ver1<h-range) {
     ver1 = range;
     while (hor1<w-range) {
       int ver2,hor2;
       double mu,xbar,som=0;
       for (ver2= -range; ver2<=range; ver2++) {
       for (hor2= -range; hor2<=range; hor2++) {

     som += im->rgb_data[((hor1+hor2)+w*(ver1+ver2))*3];
         }
        }
       mu=som/(mask*mask);
       mean[hor1+w*ver1]=mu;

 /* De tabellen "alpha" en "betadomein" aanmaken */

       som = 0;
       for (ver2= -range; ver2<=range; ver2++) {
       for (hor2= -range; hor2<=range; hor2++) {
     xbar= im->rgb_data[((hor1+hor2)+w*(ver1+ver2))*3]-mu;
     som+=xbar*xbar;
         }
       }
       if (mu==0) mu=1/(mask*mask); /* Als alle pixels =0, dan doen we even alsof 1 pixel =1*/
       alpha[hor1+w*ver1] = som/(mask*mask*mu);
       betadomein[teller] = alpha[hor1+w*ver1];
       teller ++;

      hor1 ++;
      }
   ver1 ++;
   }


 /* De look-up table "betabeeld" aanmaken */

qsort(betadomein, lookupsize, sizeof(double), cmp);

for (hor1=0;hor1<lookupsize;hor1++)
betabeeld[hor1]= avanbeta + bvanbeta* exp(- cvanbeta *betadomein[hor1]);

/* Nu gaan we het eerste deel van  het filter toepassen */
for (hor1=mask;hor1<=w-mask;hor1++){
printf("%d",hor1);
  for (ver1=mask;ver1<=h-mask;ver1++){
  int ver2, hor2, waarde=0, noemer=0;
    Omgeving(range, hor1,ver1,pixelomgeving[hor1+w*ver1],w,h, alpha,
                                  lookupsize, betadomein, betabeeld);
    for (ver2=1;ver2<=mask;ver2++){
      for (hor2=1; hor2<=mask;hor2++){
        if (pixelomgeving[hor1+w*ver1][hor2+(mask+2)*ver2]==1){
        waarde+=im->rgb_data[(hor1-(range+1)+hor2+w*(ver1-(range+1)+ver2))*3];
        noemer+=1;
        }
      }
     }
/* Hier gaan we alvast anticiperen op het tweede deel van het filter.
   Het aantal pixels in het window stoppen we in de centralpixel. (Normaal
                              gesproken is die op 1 geïnitialiseerd). */
pixelomgeving[hor1+w*ver1][centralpixel]=noemer;

  im2->rgb_data[(hor1+w*ver1)*3]=waarde/noemer;
  im2->rgb_data[(hor1+w*ver1)*3+1]=waarde/noemer;
  im2->rgb_data[(hor1+w*ver1)*3+2]=waarde/noemer;
  }
}

Imlib_save_image_to_ppm( id2, im2,"halfderuddere03.ppm");

/* Nu gaan we het tweede deel van het filter (het mergen) uitvoeren */

printf("Tweede deel\n");

for(hor1=mask;hor1<=w-mask;hor1++){
printf("%d",hor1);
  for(ver1=mask;ver1<=h-mask;ver1++){
    if (pixelomgeving[hor1+w*ver1][centralpixel]>kvanmerge){/*Hier
                                wordt gecheckt of het gebiedje groot genoeg is om in het
                                                        mergeproces te worden opgenomen*/
       int ver2,hor2,waarde=0,noemer=0;
       for(ver2=0;ver2<3*mask;ver2++){
         for(hor2=0;hor2<3*mask;hor2++){
           mergeomgeving[ver2][hor2]=0;
         }
       }
       mergeomgeving[mask+range][mask+range]=1;
       for(ver2=0;ver2<2*mask+1;ver2++){
         for(hor2=0;hor2<2*mask+1;hor2++){
           mergebijhouder[ver2][hor2]=0;
         }
       }
       mergebijhouder[mask][mask]=1;
/* In het array mergeomgeving wordt gewoon het gebied bijgehouden waarover de
                              smoothoperator gaat werken. (Het gebied wat je krijgt als je de
verschillende gebieden merget dus.*/
/* In mergebijhouder wordt bijgehouden wat de zaadpixels zijn van de gebieden waarmee
 gemerged wordt. Dit om het bepalen van het gebied waarover gesmoothed
moet worden te versnellen. Als we bij een pixel besluiten dat een bepaald gebied in
het mergeproces betrokken moet worden, dan zetten we
de corresponderende zaadpixel in de mergebijhouder op  1. Als we
nu via een andere pixel tegen datzelfde gebied aanlopen, dan kunnen we zien dat dat
gebied al 'aan de beurt' is geweest*/
     for(ver2=1;ver2<=mask;ver2++){
       for(hor2=1;hor2<=mask;hor2++){
         if (pixelomgeving[hor1+w*ver1][hor2+ver2*(mask+2)]==1){
           mergeomgeving[mask+ver2][mask+hor2]=1;
         /*for(teller=-1;teller<=1;teller++)*/
         for(hteller=-1;hteller<=1;hteller++){
           for(vteller=-1;vteller<=1;vteller++){
             Scan(hor1+hteller,ver1+vteller,pixelomgeving,mask+hor2,
                   mask+ver2,hteller,vteller,mergeomgeving,mergebijhouder,
                                                     w,range,centralpixel);
         /*for(teller=-1;teller<=1;teller++)
             Scan(hor1+teller,ver1+1,pixelomgeving,mask+hor2,mask+ver2,
         mask+teller,mask+1,teller,1,mergeomgeving,mergebijhouder,w,range,
                                             centralpixel);
           Scan(hor1-1,ver1,pixelomgeving,mask+hor2,mask+ver2,mask-1,mask,-1,
             0,mergeomgeving,mergebijhouder,w,range,centralpixel);
           Scan(hor1+1,ver1,pixelomgeving,mask+hor2,mask+ver2,mask+1,mask,1,
                       0,mergeomgeving,mergebijhouder,w,range,centralpixel);*/
           }
          }
         }
       }
     }
   for (ver2=0;ver2<3*mask;ver2++){
     for (hor2=0; hor2<3*mask;hor2++){
       if (mergeomgeving[ver2][hor2]==1){
         waarde+=im2->rgb_data[(hor1-(mask+range)+hor2+w*(ver1-(mask+range)
                                              +ver2))*3];
         noemer+=1;
       }
     }
   }


  im->rgb_data[(hor1+w*ver1)*3]=waarde/noemer;
  im->rgb_data[(hor1+w*ver1)*3+1]=waarde/noemer;
  im->rgb_data[(hor1+w*ver1)*3+2]=waarde/noemer;
  }/* 'if' van regel 158 */
}/* 'for' van regel 157 */
}/* 'for' van regel 156 */
   Imlib_save_image_to_ppm( id, im,"resultaatderuddere03.ppm");
   free(alpha);
   free(mean);
   free(betadomein);
   free(betabeeld);
   free(pixelomgeving);
   return 0;
}

/* Deze functie berekent de omgeving rond een pixel. Ze maakt de array 'pixelomgeving' aan */

void Omgeving(int range,int posx, int posy,char *pixelomgeving,
                                   int w,int h,double *alpha,int lookupsize,
              double *betadomein, double *betabeeld) {
int straal,x,y,positie;

 /*Eerst de eerste omgeving maken */
Buren(posx, posy, ((mask+2)*(mask+2))/2, pixelomgeving,w,alpha,lookupsize,
                                                             betadomein,betabeeld);
 /*Nu van het midden uit naar buiten spiralen*/
  for (straal=1;straal<=range;straal++){
    for (x=-straal;x<=straal;x++){
      positie=((mask+2)*(mask+2))/2+x-straal*(mask+2);
      if (pixelomgeving[positie]==1){
        Burenboven(posx+x,posy-straal,positie,
            pixelomgeving,w,alpha,lookupsize,
                                                  betadomein,betabeeld);
      }
     }

     for (y=-straal; y<=straal;y++){
       positie=((mask+2)*(mask+2))/2+straal+y*(mask+2);
       if (pixelomgeving[positie]==1){
         Burenrechts(posx+straal,posy+y,positie,pixelomgeving,w,alpha,
                                                           lookupsize,betadomein,betabeeld);
       }
      }

     for (x=straal;x>=-straal;x--){
       positie=((mask+2)*(mask+2))/2+x+straal*(mask+2);
       if (pixelomgeving[positie]==1){
        Burenonder(posx+x,posy+straal,positie,pixelomgeving,w,alpha,
                                                           lookupsize,betadomein,betabeeld);
       }
      }

     for (y=straal;y>=-straal;y--){
       positie=((mask+2)*(mask+2))/2-straal+y*(mask+2);
       if (pixelomgeving[positie]==1){
        Burenlinks(posx-straal,posy+y,positie,pixelomgeving,w,alpha,
                                                         lookupsize,betadomein,betabeeld);
       }
     }
   }
}

/* Deze fuctie berekent welke pixels in de rand van breedte 1 rond een pixel
aan het statistisch criterium voldoen */
void Buren (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int hor1,ver1;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],
                           lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],
                                       lookupsize,betadomein,betabeeld);
  for (hor1=-1;hor1<=1;++hor1){
    for (ver1=-1;ver1<=1;ver1++){
      if (ondergrens<alpha[xcoord+hor1+w*(ycoord+ver1)]){
        if(alpha[xcoord+hor1+w*(ycoord+ver1)]<=bovengrens){
        pixelomgeving[positie+hor1+(mask+2)*ver1]=1;
        }
      }
    }
  }
}
/* Deze fuctie berekent welke van de drie pixels rechts van een pixel
aan het statistisch criterium voldoen */
void Burenrechts (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int i;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],
                                lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],
                                     lookupsize,betadomein,betabeeld);
  for (i=-1;i<=1;i++){
      if (ondergrens<alpha[xcoord+1+w*(ycoord+i)]){
	    if(alpha[xcoord+1+w*(ycoord+i)]<=bovengrens){
        pixelomgeving[positie+1+(mask+2)*i]=1;
		}
      }
  }
}
/* Deze fuctie berekent welke van de drie pixels links van een pixel
aan het statistisch criterium voldoen */
void Burenlinks (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int i;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord]
                             ,lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],
                        lookupsize,betadomein,betabeeld);
  for (i=-1;i<=1;i++){
      if (ondergrens<alpha[xcoord-1+w*(ycoord+i)]){
        if(alpha[xcoord-1+w*(ycoord+i)]<=bovengrens){
        pixelomgeving[positie-1+(mask+2)*i]=1;
        }
      }
  }
}
/* Deze fuctie berekent welke van de drie pixels onder een pixel
aan het statistisch criterium voldoen */
void Burenonder (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int i;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],
                                  lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],
                                  lookupsize,betadomein,betabeeld);
  for (i=-1;i<=1;i++){
      if (ondergrens<alpha[xcoord+i+w*(ycoord+1)]){
        if(alpha[xcoord+i+w*(ycoord+1)]<=bovengrens){
        pixelomgeving[positie+i+(mask+2)]=1;
        }
      }
  }
}

/* Deze fuctie berekent welke van de drie pixels boven een pixel
aan het statistisch criterium voldoen */
void Burenboven (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int i;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],
                              lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],
                              lookupsize,betadomein,betabeeld);
  for (i=-1;i<=1;i++){
      if (ondergrens<alpha[xcoord+i+w*(ycoord-1)]){
        if(alpha[xcoord+i+w*(ycoord-1)]<=bovengrens){
        pixelomgeving[positie+i-(mask+2)]=1;
        }
      }
  }
}

/*Dit is de daadwerkelijke fuctie Beta, die bij ingeven van een alfa de beeldwaarde opzoekt*/

double Beta(double currentalpha, int lookupsize, double *betadomein, double *betabeeld){
int wig=lookupsize/2;
int reep=wig;
while(currentalpha!=betadomein[wig]){
reep=(reep+1)/2;
if (currentalpha>betadomein[wig])
wig+=reep;
else wig-=reep;
}

return betabeeld[wig];
}



/* Dit is de cmp (compare) functie die in qsort gebruikt wordt */



int cmp(const void *vp, const void *vq){
   const double *p=vp;
   const double *q=vq;
   double       diff=*q-*p;
   return ((diff>=0.0) ? ((diff>0.0) ? -1:0):+1);
}

 /*De Scanfunctie, die kijkt of het pixel deel uitmaakt van de omgeving van een naburig punt*/
void Scan(int xomgevingspixel, int yomgevingspixel,char **pixelomgeving,
                                                            int xmergeomg, int ymergeomg,
          int hteller, int vteller, char **mergeomgeving, char **mergebijhouder, int w,
                                                                         int range, int centralpixel){
 /* xmergeomgeving en ymergeomgeving zijn de coordinaten van het centrale pixel zelf.
                                                          (dus niet van pixel+teller of zoiets*/
 /*Hetzelfde geldt voor xmergebijh en ymergebijh*/

int hor3,ver3;
for(hor3=-range;hor3<=range;hor3++){
  for(ver3=-range;ver3<=range;ver3++){/* Dit is precies het gebied waar pixels kunnen zitten
                                                wiens omgeving de pixel die nu bekeken wordt kan bevatten*/
    if(mergebijhouder[(xmergeomg-range-1)+hteller+hor3][(ymergeomg-range-1)+vteller+ver3]==0){
      if(pixelomgeving[xomgevingspixel+hor3+w*(yomgevingspixel+ver3)][centralpixel-hor3+(mask+2)*
                                                                         (centralpixel-ver3)]!=0){
      int ver4,hor4;
        for(ver4=1;ver4<=mask;ver4++){
          for(hor4=1;hor4<=mask;hor4++){
            if(pixelomgeving[xomgevingspixel+hor3+w*(yomgevingspixel+ver3)][hor4+(mask+2)*ver4]!=0)
              mergeomgeving[xmergeomg+hteller+hor3-range-1+(hor4-1)][ymergeomg+vteller+ver3-range-1+
                                              (ver4-1)]=1;
          }
        }
     mergebijhouder[(xmergeomg-range-1)+hteller+hor3][(ymergeomg-range-1)+vteller+ver3]=1;
    }
  }
}
}
}




