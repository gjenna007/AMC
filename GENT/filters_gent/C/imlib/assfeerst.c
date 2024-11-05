 #include <Imlib.h>
 #include <math.h>
 #include <stdio.h>
 #include <stdlib.h>

 #define mask 11
 #define avanbeta 0.001
 #define bvanbeta 0.5
 #define cvanbeta 0
 #define kvanmerge 5
 #define deltamuvanmerge 5

 void Omgeving (int, int, int, char *, int,int, double *,int, double *, double *);
 double Beta (double, int, double *, double *);
 void Buren (int, int, int, char *,int,double *,int,double *, double *);
 void Burenboven (int, int, int, char *,int,double *,int,double *, double *);
 void Burenrechts (int, int, int, char *,int,double *,int,double *, double *);
 void Burenonder (int, int, int, char *,int,double *,int,double *, double *);
 void Burenlinks (int, int, int, char *,int,double *,int,double *, double *);
 int cmp(const void *vp,const void *vq);



 int main()
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
     Display *disp;

    disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
    id =Imlib_init(disp);
    id2=Imlib_init(disp);

 /* Load the image specified as the first argument */
    im =Imlib_load_image(id,"demaere09.ppm");
    im2=Imlib_load_image(id2,"demaere09.ppm");
 /* Suck the image's original width and height out of the Image structure */
    w=im->rgb_width;
    h=im->rgb_height;
    lookupsize=(w-2*range)*(h-2*range);/* Dit wordt de grootte van de look-up table */

/* Zeker stellen dat in de R, de G, en de B coordinaat inderdaad dezelfde waarde staat */

for (hor1=0;hor1<w;hor1++){
  int gemiddelde;
  for (ver1=0;ver1<h;ver1++){
    gemiddelde=(im->rgb_data[(hor1+w*ver1)*3]+im->rgb_data[(hor1+w*ver1)*3+1]+im->rgb_data[(hor1+ver1*w)*3+2])/3;
    im->rgb_data[(hor1+w*ver1)*3]=gemiddelde;
    im->rgb_data[(hor1+w*ver1)*3+1]=gemiddelde;
    im->rgb_data[(hor1+w*ver1)*3+2]=gemiddelde;
  }
}


/* Geheugenruimte reserveren voor de verschillende tabellen */
    mean = malloc(w*h*sizeof(double));/* mean en alpha zijn iets te groot, maar vanwege de manier waarop ik ze invul moet dat ook */
    alpha = malloc(w*h*sizeof(double));
    betadomein = malloc(lookupsize*sizeof(double));/* deze kunnen wel precies groot genoeg gemaakt worden */
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
   while (hor1<w-range) {
     ver1 = range;
     while (ver1<h-range) {
       int ver2,hor2;
       double mu,xbar,som=0;
       for (ver2= -range; ver2<=range; ver2++) {
       for (hor2= -range; hor2<=range; hor2++) {

     som += im->rgb_data[((hor1+ver2)+w*(ver1+hor2))*3];
         }
        }
       mu=som/(mask*mask);
       mean[hor1+w*ver1]=mu;

 /* De tabellen "alpha" en "betadomein" aanmaken */

       som = 0;
       for (ver2= -range; ver2<=range; ver2++) {
       for (hor2= -range; hor2<=range; hor2++) {
     xbar= im->rgb_data[((hor1+ver2)+w*(ver1+hor2))*3]-mu;
     som+=xbar*xbar;
         }
       }
       alpha[hor1+w*ver1] = som/(mask*mask*mu);
       betadomein[teller] = alpha[hor1+w*ver1];
       teller ++;

      ver1 ++;
      }
   hor1 ++;
   }


 /* De look-up table "betabeeld" aanmaken */

qsort(betadomein, lookupsize, sizeof(double), cmp);

for (hor1=0;hor1<lookupsize;hor1++)
betabeeld[hor1]= avanbeta + bvanbeta* exp(- cvanbeta *betadomein[hor1]);


/* Nu gaan we het eerste deel van  het filter toepassen */
/* De pixelomgevingen schrijven we weg in ASSF-PIXELOMGEVING */
fopen("ASSF-PIXELOMGEVING", w);
for (hor1=mask;hor1<=w-mask;hor1++){
printf("%d",hor1);
  for (ver1=mask;ver1<=h-mask;ver1++){
  int ver2, hor2, waarde=0, noemer=0;
    Omgeving(range, hor1,ver1,pixelomgeving[hor1+w*ver1],w,h, alpha,lookupsize, betadomein, betabeeld);
    for (ver2=1;ver2<=mask;ver2++){
      for (hor2=1; hor2<=mask;hor2++){
        if (pixelomgeving[hor1+w*ver1][hor2+(mask+2)*ver2]==1){
        waarde+=im->rgb_data[(hor1-(range+1)+hor2+w*(ver1-(range+1)+ver2))*3];
        noemer+=1;
        }
      }
     }
/* Hier gaan we alvast anticiperen op het tweede deel van het filter. Het aantal pixels in het window stoppen we in de centralpixel. (Normaal
 gesproken is die op 1 geïnitialiseerd). */
pixelomgeving[hor1+w*ver1][centralpixel]=noemer;

  im2->rgb_data[(hor1+w*ver1)*3]=waarde/noemer;
  im2->rgb_data[(hor1+w*ver1)*3+1]=waarde/noemer;
  im2->rgb_data[(hor1+w*ver1)*3+2]=waarde/noemer;
  }
}

Imlib_save_image_to_ppm( id2, im2, "ASSF_HALFRESULTAAT.ppm");

   free(alpha);
   free(mean);
   free(betadomein);
   free(betabeeld);
   free(pixelomgeving);
   return 0;
}

/* Deze functie berekent de omgeving rond een pixel. Ze maakt de array 'pixelomgeving' aan */

void Omgeving(int range,int posx, int posy,char *pixelomgeving, int w,int h,double *alpha,int lookupsize,
              double *betadomein, double *betabeeld) {
int hor1,x,y,positie;

 /*Eerst de eerste omgeving maken */
Buren(posx, posy, ((mask+2)*(mask+2))/2, pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
 /*Nu van het midden uit naar buiten spiralen*/
  for (hor1=1;hor1<=range;hor1++){
    for (x=-hor1;x<=hor1;x++){
      positie=((mask+2)*(mask+2))/2+x-hor1*(mask+2);
      if (pixelomgeving[positie]==1){
        Burenboven(posx+x,posy-hor1,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
      }
     }

     for (y=-hor1; y<=hor1;y++){
       positie=((mask+2)*(mask+2))/2+hor1+y*(mask+2);
       if (pixelomgeving[positie]==1){
         Burenrechts(posx+hor1,posy+y,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
       }
      }

     for (x=hor1;x>=-hor1;x--){
       positie=((mask+2)*(mask+2))/2+x+hor1*(mask+2);
       if (pixelomgeving[positie]==1){
        Burenonder(posx+x,posy+hor1,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
       }
      }

     for (y=hor1;y>=-hor1;y--){
       positie=((mask+2)*(mask+2))/2-hor1+y*(mask+2);
       if (pixelomgeving[positie]==1){
        Burenlinks(posx-hor1,posy+y,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
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

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
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
int hor1;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
  for (hor1=-1;hor1<=1;hor1++){
      if (ondergrens<alpha[xcoord+1+w*(ycoord+hor1)]){
	    if(alpha[xcoord+1+w*(ycoord+hor1)]<=bovengrens){
        pixelomgeving[positie+1+(mask+2)*hor1]=1;
		}
      }
  }
}
/* Deze fuctie berekent welke vande drie pixels links van een pixel
aan het statistisch criterium voldoen */
void Burenlinks (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int hor1;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
  for (hor1=-1;hor1<=1;hor1++){
      if (ondergrens<alpha[xcoord-1+w*(ycoord+hor1)]){
        if(alpha[xcoord-1+w*(ycoord+hor1)]<=bovengrens){
        pixelomgeving[positie-1+(mask+2)*hor1]=1;
        }
      }
  }
}
/* Deze fuctie berekent welke van de drie pixels onder een pixel
aan het statistisch criterium voldoen */
void Burenonder (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int hor1;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
  for (hor1=-1;hor1<=1;hor1++){
      if (ondergrens<alpha[xcoord+hor1+w*(ycoord+1)]){
        if(alpha[xcoord+hor1+w*(ycoord+1)]<=bovengrens){
        pixelomgeving[positie+hor1+(mask+2)]=1;
        }
      }
  }
}

/* Deze fuctie berekent welke van de drie pixels boven een pixel
aan het statistisch criterium voldoen */
void Burenboven (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int hor1;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
  for (hor1=-1;hor1<=1;hor1++){
      if (ondergrens<alpha[xcoord+hor1+w*(ycoord-1)]){
        if(alpha[xcoord+hor1+w*(ycoord-1)]<=bovengrens){
        pixelomgeving[positie+hor1-(mask+2)]=1;
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






