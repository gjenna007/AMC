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


 void Scan(int,int,char**,int,int,int,int,char**,char**,int,int,int);


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



/* Nu gaan we het tweede deel van het filter (het mergen) uitvoeren */

printf("Tweede deel\n");

for(hor1=mask;hor1<=w-mask;hor1++){
printf("%d",hor1);
  for(ver1=mask;ver1<=h-mask;ver1++){
    if (pixelomgeving[hor1+w*ver1][centralpixel]>kvanmerge){/*Hier wordt gecheckt of het gebiedje groot genoeg is om in het
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
/* In het array mergeomgeving wordt gewoon het gebied bijgehouden waarover de smoothoperator gaat werken. (Het gebied wat je krijgt als je de
verschillende gebieden merget dus.*/
/* In mergebijhouder wordt bijgehouden wat de zaadpixels zijn van de gebieden waarmee gemerged wordt. Dit om het bepalen van het gebied waarover gesmoothed
moet worden te versnellen. Als we bij een pixel besluiten dat een bepaald gebied in het mergeproces betrokken moet worden, dan zetten we
de corresponderende zaadpixel in de mergebijhouder op  1. Als we nu via een andere pixel tegen datzelfde gebied aanlopen, dan kunnen we zien dat dat
gebied al 'aan de beurt' is geweest*/
     for(ver2=1;ver2<=mask;ver2++){
       for(hor2=1;hor2<=mask;hor2++){
         if (pixelomgeving[hor1+w*ver1][hor2+ver2*(mask+2)]==1){
           mergeomgeving[mask+ver2][mask+hor2]=1;
         /*for(teller=-1;teller<=1;teller++)*/
         for(hteller=-1;hteller<=1;hteller++){
           for(vteller=-1;vteller<=1;vteller++){
             Scan(hor1+hteller,ver1+vteller,pixelomgeving,mask+hor2,mask+ver2,hteller,vteller,mergeomgeving,mergebijhouder,w,range,centralpixel);
         /*for(teller=-1;teller<=1;teller++)
             Scan(hor1+teller,ver1+1,pixelomgeving,mask+hor2,mask+ver2,mask+teller,mask+1,teller,1,mergeomgeving,mergebijhouder,w,range,centralpixel);
           Scan(hor1-1,ver1,pixelomgeving,mask+hor2,mask+ver2,mask-1,mask,-1,0,mergeomgeving,mergebijhouder,w,range,centralpixel);
           Scan(hor1+1,ver1,pixelomgeving,mask+hor2,mask+ver2,mask+1,mask,1,0,mergeomgeving,mergebijhouder,w,range,centralpixel);*/
           }
          }
         }
       }
     }
   for (ver2=0;ver2<3*mask;ver2++){
     for (hor2=0; hor2<3*mask;hor2++){
       if (mergeomgeving[ver2][hor2]==1){
         waarde+=im2->rgb_data[(hor1-(mask+range)+ver2+w*(ver1-(mask+range)+hor2))*3];
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
   Imlib_save_image_to_ppm( id, im, "resultaatdemaere.ppm");
   free(alpha);
   free(mean);
   free(betadomein);
   free(betabeeld);
   free(pixelomgeving);
   return 0;
}

 /*De Scanfunctie, die kijkt of het pixel deel uitmaakt van de omgeving van een naburig punt*/
void Scan(int xomgevingspixel, int yomgevingspixel,char **pixelomgeving, int xmergeomg, int ymergeomg,
          int hteller, int vteller, char **mergeomgeving, char **mergebijhouder, int w, int range, int centralpixel){
 /* xmergeomgeving en ymergeomgeving zijn de coordinaten van het centrale pixel zelf. (dus niet van pixel+teller of zoiets*/
 /*Hetzelfde geldt voor xmergebijh en ymergebijh*/

int hor3,ver3;
for(hor3=-range;hor3<=range;hor3++){
  for(ver3=-range;ver3<=range;ver3++){/* Dit is precies het gebied waar pixels kunnen zitten wiens omgeving de pixel die nu bekeken wordt kan bevatten*/
    if(mergebijhouder[(xmergeomg-range-1)+hteller+hor3][(ymergeomg-range-1)+vteller+ver3]==0){
      if(pixelomgeving[xomgevingspixel+hor3+w*(yomgevingspixel+ver3)][centralpixel-hor3+(mask+2)*(centralpixel-ver3)]!=0){
      int ver4,hor4;
        for(ver4=1;ver4<=mask;ver4++){
          for(hor4=1;hor4<=mask;hor4++){
            if(pixelomgeving[xomgevingspixel+hor3+w*(yomgevingspixel+ver3)][hor4+(mask+2)*ver4]!=0)
              mergeomgeving[xmergeomg+hteller+hor3-range-1+(hor4-1)][ymergeomg+vteller+ver3-range-1+(ver4-1)]=1;
          }
        }
     mergebijhouder[(xmergeomg-range-1)+hteller+hor3][(ymergeomg-range-1)+vteller+ver3]=1;
    }
  }
}
}
}




