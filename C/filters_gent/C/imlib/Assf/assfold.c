 #include <Imlib.h>
 #include <math.h>
 #include <stdio.h>
 #include <stdlib.h>

 #define mask 11
 #define avanbeta 0.001
 #define bvanbeta 0.05
 #define cvanbeta 100

 void Omgeving (int, int, int, char *, int, double *,int, double *, double *);
 double Beta (double, int, double *, double *);
 void Buren (int, int, int, char *,int,double *,int,double *, double *);
  /*void Betalookup (double *, double *);*/
 int cmp(const void *vp,const void *vq);


 int main()
   {
     ImlibData *id;
     ImlibData *id2;
     ImlibImage *im;
     ImlibImage *im2;

     const  int range=mask/2;
     int w,h,i,j,teller;
     int lookupsize;
     double *alpha;
     double *mean;
     double *betadomein;
     double *betabeeld;
     char  pixelomgeving[(mask+2)*(mask+2)];
     Display *disp;

    disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
    id =Imlib_init(disp);
    id2=Imlib_init(disp);

 /* Load the image specified as the first argument */
    im =Imlib_load_image(id,"fantoombeeld.tif");
    im2=Imlib_load_image(id2,"fantoombeeld.tif");
 /* Suck the image's original width and height out of the Image structure */
    w=im->rgb_width;
    h=im->rgb_height;
    lookupsize=(w-2*range)*(h-2*range);/* Dit wordt de grootte van de look-up table */

/* Zeker stellen dat in de R, de G, en de B coordinaat inderdaad dezelfde waarde staat */

for (i=0;i<w;i++){
  int gemiddelde;
  for (j=0;j<h;j++){
    gemiddelde=(im->rgb_data[(i+w*j)*3]+im->rgb_data[(i+w*j)*3+1]+im->rgb_data[(i+j*w)*3+2])/3;
    im->rgb_data[(i+w*j)*3]=gemiddelde;
    im->rgb_data[(i+w*j)*3+1]=gemiddelde;
    im->rgb_data[(i+w*j)*3+2]=gemiddelde;
  }
}


/* Geheugenruimte reserveren voor de verschillende tabellen */
    mean = malloc(w*h*sizeof(double));/* mean en alpha zijn iets te groot, maar vanwege de manier waarop ik ze invul moet dat ook */
    alpha = malloc(w*h*sizeof(double));
    betadomein = malloc(lookupsize*sizeof(double));/* deze kunnen wel precies groot genoeg gemaakt worden */
    betabeeld = malloc (lookupsize*sizeof(double));

/* De tabel "mean" aanmaken */

    teller=0;
    i = range;
   while (i<w-range) {
     j = range;
     while (j<h-range) {
       int k,l;
       double mu,xbar,som=0;
       for (k= -range; k<=range; k++) {
       for (l= -range; l<=range; l++) {

     som += im->rgb_data[((i+k)+w*(j+l))*3];
         }
        }
       mu=som/(mask*mask);
       mean[i+w*j]=mu;

 /* De tabellen "alpha" en "betadomein" aanmaken */

       som = 0;
       for (k= -range; k<=range; k++) {
       for (l= -range; l<=range; l++) {
     xbar= im->rgb_data[((i+k)+w*(j+l))*3]-mu;
     som+=xbar*xbar;
         }
       }
       alpha[i+w*j] = som/(mask*mask*mu);
       betadomein[teller] = alpha[i+w*j];
       teller ++;

      j ++;
      }
   i ++;
   }


 /* De look-up table "betabeeld" aanmaken */

/*Betalookup(alpha,betadomein);*/

qsort(betadomein, lookupsize, sizeof(double), cmp);
for (i=0;i<lookupsize;i++)
betabeeld[i]= avanbeta + bvanbeta* exp(- cvanbeta *betadomein[i]);

/* Nu gaan we het filter toepassen */
for (i=mask;i<=w-mask;i++){
  for (j=mask;j<=h-mask;j++){
  int k, l, waarde=0, noemer=0;
    Omgeving(range, i,j,pixelomgeving,w, alpha,lookupsize, betadomein, betabeeld);
    for (k=1;k<=mask;k++){
      for (l=1; l<=mask;l++){
        if (pixelomgeving[l+(mask+2)*k]==1){
        waarde+=im->rgb_data[(i-(range+1)+l+w*(j-(range+1)+k))*3];
        noemer+=1;
        }
      }
    }
  im2->rgb_data[(i+w*j)*3]=waarde/noemer;
  im2->rgb_data[(i+w*j)*3+1]=waarde/noemer;
  im2->rgb_data[(i+w*j)*3+2]=waarde/noemer;
  }
}

   Imlib_save_image_to_ppm( id2, im2, "fantoombeeld.ppm");
   free(alpha);
   free(mean);
   free(betadomein);
   free(betabeeld);
   return 0;
}

/* Deze functie berekent de omgeving rond een pixel. Ze maakt de array 'pixelomgeving' aan. */
void Omgeving(int range,int posx, int posy,char *pixelomgeving, int w,double *alpha,int lookupsize,
              double *betadomein, double *betabeeld) {
int i=0 ,x,y,positie;

/*initialiseren*/
while (i<(mask+2)*(mask+2)){
    pixelomgeving[i]=0;
    i++;
  }
  pixelomgeving[((mask+2)*(mask+2))/2]=1;
 /*Nu van het midden uit naar buiten spiralen*/
  for (i=0;i<=range;++i){
    for (x=-i;x<=i;++x){
      positie=((mask+2)*(mask+2))/2+x-i*(mask+2);
      if (pixelomgeving[positie]==1){
        Buren(posx+x,posy-i,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
      }
     }

     for (y=-i+1; y<=i;++y){
       positie=((mask+2)*(mask+2))/2+i+y*(mask+2);
       if (pixelomgeving[positie]==1){
         Buren(posx+i,posy+y,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
       }
      }

     for (x=+i-1;x>=-i;--x){
       positie=((mask+2)*(mask+2))/2+x+i*(mask+2);
       if (pixelomgeving[positie]==1){
        Buren(posx+x,posy+i,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
       }
      }

     for (y=+i-1;y>=-i+1;--y){
       positie=((mask+2)*(mask+2))/2-i+y*(mask+2);
       if (pixelomgeving[positie]==1){
        Buren(posx-i,posy+y,positie,pixelomgeving,w,alpha,lookupsize,betadomein,betabeeld);
       }
     }
   }
}

/* Deze fuctie berekent welke pixels in de rand van breedte 1 rond een pixel
aan het statistisch criterium voldoen */
void Buren (int xcoord, int ycoord, int positie, char *pixelomgeving, int w,
            double *alpha,int lookupsize,double *betadomein,double *betabeeld){
int i,j;
double ondergrens, bovengrens;

ondergrens=alpha[xcoord+w*ycoord]-Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
bovengrens=alpha[xcoord+w*ycoord]+Beta(alpha[xcoord+w*ycoord],lookupsize,betadomein,betabeeld);
  for (i=-1;i<=1;++i){
    for (j=-1;j<=1;++j){
      if (ondergrens<alpha[xcoord+i+w*(ycoord+j)]){
        if(alpha[xcoord+i+w*(ycoord+j)<=bovengrens]){
        pixelomgeving[positie]=1;
        }
      }
      else pixelomgeving[positie]=0;
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

/*Deze functie maakt de look-up tables "betadomein" en "betabeeld" aan. */

/*void Betalookup(double *alpha,double *betadomein){
double grootste, kleinste, schuifmaat;
int i,j;
kleinste=grootste=alpha[0];
for (i=1;i<=w*h-1;i++){
  if alpha[i]>grootste
    grootste=alpha[i];
  if alpha[i]<kleinste
    kleinste=alpha[i];
}
Eerst wordt betadomein=alpha-geordend en met alle dubbelen eruit aangemaakt*/
/*betadomein[0]=kleinste;
schuifmaat=kleinste;
j=1;
while(schuifmaat<grootste){
  schuifmaat=grootste;
  for (i=0;i<=w*h-1;i++){
    if alpha[i]>kleinste{
      if alpha[i]<schuifmaat
      schuifmaat=alpha[i];
    }
  }
  betadomein[j]=schuifmaat;
  kleinste=beta[j];
  j++;
}
betadomein[j]=grootste;
printf("%d",j);
lookupsize=j+1;*/ /*De grootte van de array is nu ook buiten deze functie te zien*/
    
/* En nu maken we betabeeld*/
/*betabeeld = malloc(lookupsize*sizeof(double));*/
/*qsort(betadomein, lookupsize, sizeof(double), cmp);
for (i=0;i<lookupsize;i++)
betabeeld[i]= avanbeta + bvanbeta* exp(- cvanbeta *betadomein[i]);
}*/


/* Dit is de cmp (compare) functie die in qsort gebruikt wordt */

int cmp(const void *vp, const void *vq){
   const double *p=vp;
   const double *q=vq;
   double       diff=*p-*q;
   return ((diff>=0.0) ? ((diff>0.0) ? -1:0):+1);
}







