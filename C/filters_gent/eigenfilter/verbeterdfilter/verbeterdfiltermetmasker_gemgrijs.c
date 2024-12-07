#include <Imlib.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "definities.h"
#include "initialisatie.h"
#include "groeiregio.h"
#include "coocmatrix.h"

 /*Hier komen alle functies */
void Filter (int hor, int ver, int width, ImlibImage * compbeeld,
	     ImlibImage * resultaatbeeld, ImlibImage * gefilterdbeeld,
	     int *scanbijhouder, int *blurbeeld,
	     struct Kleur *kleur, FILE * fpuniformiteit, FILE * fpcontrast,	/*
										   FILE *fpinvdiffmoment, FILE *fpentropie, */
	     FILE * fpgebiedsgrootten, FILE * fpgemgrijswaarden,
	     ImlibImage * kleurpalet);

 /*  void Cooc(const ImlibImage* compbeeld,const int*scanbijhouder,const struct Venster* venster,
    double*coocmatrix); */
double BerekenUniformiteit (const double *coocmatrix);	/* Invoer is hier uiteraard
							   de co-ocurrentiematrix */
double BerekenContrast (const double *coocmatrix);
/* double  BerekenInvdiffmoment(const double*coocmatrix);
   double BerekenEntropie(const double*coocmatrix);*/
/* double BerekenCorrelatie(const double*coocmatrix);*/
// void Beeldblurren(const ImlibImage* compbeeld, int* blurbeeld);
void Beeldcompressen (const ImlibImage *, int *, int, int);
void GebiedDeactiveren (int width, const struct Venster *venster,
			int *scanbijhouder);
void KleurGebiedje (ImlibImage * compbeeld, const struct Venster *venster,
		    const int *scanbijhouder, const struct Kleur *kleur);
void PasVulkleurAan (struct Kleur *kleur /*, double contrast */ );
void TekenKleurpalet (ImlibImage * kleurpalet, const struct Kleur *kleur);
int FilterKnop (double contrast, int gem_grijswaarde_regio);
void PasCrimminfilterToe (ImlibImage * resultaatbeeld,
			  ImlibImage * gefilterdbeeld, int width,
			  const int *scanbijhouder,
			  const struct Venster *venster, double contrast,
			  int gem_grijswaarde_regio);
void Beeldaanpassen (ImlibImage * resultaatbeeld,
		     const ImlibImage * gefilterdbeeld, int width,
		     const struct Venster *venster);
int BerekenGemGrijswaarde (const ImlibImage * compbeeld, int widht,
			   const int *scanbijhouder,
			   const struct Venster *venster, int aantalpunten);

int
main ()
{
/*Hier komen de variabelen*/
  ImlibData *dcompbeeld;
  ImlibData *dresultaatbeeld;
  ImlibData *dgefilterdbeeld;
  ImlibData *dkleurpalet;
  ImlibData *dsilhouet;
  ImlibData *dgeblurdbeeld;
  ImlibImage *compbeeld;
  ImlibImage *resultaatbeeld;
  ImlibImage *gefilterdbeeld;
  ImlibImage *kleurpalet;
  ImlibImage *silhouet;
  ImlibImage *geblurdbeeld;
  int *blurbeeld;
  int *scanbijhouder;
  struct Kleur *kleur;
  FILE *fpuniformiteit;
  FILE *fpcontrast;
  /*FILE *fpinvdiffmoment;
     FILE *fpentropie; */
  FILE *fpgebiedsgrootten;
  FILE *fpgemgrijswaarden;
  Display *disp;
  int width, height, hor, ver;

/* Creëren van de files waarin ik de resultaten ga wegschrijven*/
  fpuniformiteit = fopen ("compuniformiteit", "w");
  fpcontrast = fopen ("compacontrast", "w");
  /* fpinvdiffmoment=fopen("invdiffmoment","w");
     fpentropie=fopen("entropie","w"); */
  fpgebiedsgrootten = fopen ("compgebiedsgrootten", "w");
  fpgemgrijswaarden = fopen ("compgemgrijswaarden", "w");

/* Hier komen alle files waarin weggeschreven wordt*/
  disp = XOpenDisplay (NULL);
/* Immediately afterwards Intitialise Imlib */
  dcompbeeld = Imlib_init (disp);
  dresultaatbeeld = Imlib_init (disp);
  dgefilterdbeeld = Imlib_init (disp);
  dkleurpalet = Imlib_init (disp);
  dsilhouet = Imlib_init (disp);
  dgeblurdbeeld=Imlib_init (disp);
/* Load the image specified as the first argument */
  compbeeld = Imlib_load_image (dcompbeeld, "compderuddere05.tif");
  resultaatbeeld = Imlib_load_image (dresultaatbeeld, "deruddere05.tif");
  gefilterdbeeld = Imlib_load_image (dgefilterdbeeld, "deruddere05.tif");
  geblurdbeeld = Imlib_load_image (dgeblurdbeeld, "blurderuddere05.tif");
  kleurpalet = Imlib_load_image (dkleurpalet, "kleurpalet.jpg");
  silhouet = Imlib_load_image (dsilhouet, "silhouetderuddere05.tif");	/*Met de functie
									   echomask.m bepaal je dit silhouet. Mbv scanbijhouder
									   zorg je dat de te filteren regio's alleen daarbinnen
									   gegroeid worden. */
/* Suck the image's original width and height out of the Image structure */
  width = compbeeld->rgb_width;
  height = compbeeld->rgb_height;

/*Dan kunnen we nu ruimte voor de diverse tabellen alloceren*/
  scanbijhouder = calloc (width * height, sizeof (int));	/*de waarden in scanbijhouder hebben
								   de volgende betekenis:
								   0=nog niets mee gebeurd
								   1=behoort tot groeigebied, moet nog
								   gescand worden
								   2=behoort tot groeigebied, en is al
								   gescand
								   3=hoeft nooit meer bekeken te worden */
  blurbeeld = calloc (width * height, sizeof (int));
  kleur = malloc (sizeof (struct Kleur));
  /*Nu gaan we een gemiddeldewaardefilter op het beeld loslaten,
     en zodoende "blurbeeld" construeren */
  //Beeldblurren(compbeeld,blurbeeld);
  Beeldcompressen (geblurdbeeld, blurbeeld, width, height);
/*Nu maken een randje in "scanbijhouder", om het gebied waarin we de regio's
                                             gaan afbakenen te begrenzen*/
  InitScanbijhouder (scanbijhouder, width, height, silhouet);

/* We definieren de eerste vulkleur*/
  InitVulkleur (kleur);
/* En nu gaan we het filter toepassen */
  for (ver = RANGE; ver < height - RANGE; ver++)
    {
      for (hor = RANGE; hor < width - RANGE; hor++)
	{
	  if (scanbijhouder[hor + width * ver] == 0)
	    {
	      Filter (hor, ver, width, compbeeld, resultaatbeeld,
		      gefilterdbeeld, scanbijhouder, blurbeeld, kleur,
		      fpuniformiteit, fpcontrast,	/*fpinvdiffmoment,fpentropie, */
		      fpgebiedsgrootten, fpgemgrijswaarden, kleurpalet);
	    }
	}
      //printf("%d\n",ver);
    }
/* En nu het ingekleurde beeld wegschrijven*/
  Imlib_save_image_to_ppm (dresultaatbeeld, resultaatbeeld, "gateaadaptol.ppm");
  Imlib_save_image_to_ppm (dkleurpalet, kleurpalet, "gatebadaptol.ppm");
  Imlib_save_image_to_ppm (dcompbeeld, compbeeld, "gatecadaptol.ppm");
/* Alles netjes afstluiten en beëindigen*/
  fclose (fpuniformiteit);
  fclose (fpcontrast);
  /*fclose(fpinvdiffmoment);
     fclose(fpentropie); */
  fclose (fpgebiedsgrootten);
  fclose (fpgemgrijswaarden);
  free (scanbijhouder);
  free (blurbeeld);
  return 0;
}

/* Het daadwerkelijke filter*/

void
Filter (int hor, int ver, int width, ImlibImage * compbeeld,
	ImlibImage * resultaatbeeld, ImlibImage * gefilterdbeeld,
	int *scanbijhouder, int *blurbeeld,
	struct Kleur *kleur, FILE * fpuniformiteit, FILE * fpcontrast,	/*
									   FILE *fpinvdiffmoment, FILE *fpentropie, */
	FILE * fpgebiedsgrootten, FILE * fpgemgrijswaarden,
	ImlibImage * kleurpalet)
{
  double *coocmatrix;
  int aantalpunten;
  int gem_grijswaarde_regio;
  double uniformiteit, contrast /*,invdiffmoment, entropie*,correlatie */ ;
  //venster=malloc(sizeof(struct Venster));/*lrandvenster,rrandvenster,topvenster
  //                                                  ,bottomvenster*/
  struct Venster *venster;
  venster = malloc (sizeof (struct Venster));
  coocmatrix = calloc (256 * 256, sizeof (double));

  aantalpunten =
    Groeiregio (hor, ver, width, blurbeeld, scanbijhouder, venster);
  if (aantalpunten > MINGEBIEDSGROOTTE && aantalpunten < MAXGEBIEDSGROOTTE)
    {				/*Al te kleine gebieden wordt niets
				   mee gedaan */
      Cooc (compbeeld, scanbijhouder, venster, coocmatrix);
      gem_grijswaarde_regio =
	BerekenGemGrijswaarde (compbeeld, width, scanbijhouder, venster,
			       aantalpunten);
      /*KleurGebiedje
         (compbeeld,width,venster,scanbijhouder,&kleur); */
      TekenKleurpalet (kleurpalet, kleur);
      PasVulkleurAan (kleur);
      contrast = BerekenContrast (coocmatrix);
      fprintf (fpcontrast, "%f\n", contrast);
      uniformiteit = BerekenUniformiteit (coocmatrix);
      /*invdiffmoment =BerekenInvdiffmoment(coocmatrix);
         entropie=BerekenEntropie(coocmatrix); */
      /*correlatie=BerekenCorrelatie(coocmatrix); */
      /* PasCrimminfilterToe(resultaatbeeld,gefilterdbeeld,width,scanbijhouder,
         venster,contrast,gem_grijswaarde_regio); */
      KleurGebiedje (compbeeld, venster, scanbijhouder, kleur);
//{ double twee,een = BerekenContrast(coocmatrix);

      //PasVulkleurAan (kleur, contrast);
//twee = BerekenContrast(coocmatrix);
//printf("***%f***\n",een-twee);
//}
      PasCrimminfilterToe (resultaatbeeld, gefilterdbeeld, width,
			   scanbijhouder, venster, contrast,
			   gem_grijswaarde_regio);
      GebiedDeactiveren (width, venster, scanbijhouder);

      fprintf (fpuniformiteit, "%f\n", uniformiteit);
      //fprintf(fpcontrast,"%f\n",contrast);
      /*fprintf(fpinvdiffmoment,"%f\n",invdiffmoment);
         fprintf(fpentropie,"%f\n",entropie); */
      fprintf (fpgebiedsgrootten, "%d\n", aantalpunten);
      printf ("%d%c%d\n", ver, ' ', aantalpunten);
      fprintf (fpgemgrijswaarden, "%d\n", gem_grijswaarde_regio);
      printf ("%d%c%f\n", ver, ' ', contrast);

      /*Volgens het oorspronkelijke plan ga je nu op het gebied de crimminfilter toepassen,
         waarbij je het aantal keer dat je filtert af laat hangen van
         statistische waarden die je herkent uit de coocmatrix. Nu denk ik dat het eerst nuttig
         is verschillende van die statistische waarden te berekenen
         en die in een filetje weg te schrijven om te kunnen beoordelen hoe je de
         filtercoefficient hiervan moet laten afhangen. */
    }
  //free(venster);
  free (coocmatrix);
}


/* Het uitrekenen van de coocurrentiematrix van een gebiedje*/

/*void Cooc(const ImlibImage *compbeeld,const int *scanbijhouder,
                              const struct Venster *venster, double *coocmatrix){

	int hor1, ver1;
	int overgangentotaal;
	const int width=compbeeld->rgb_width;
	overgangentotaal=0;
	for (ver1=venster->trand;ver1<=venster->brand;ver1++){
		for (hor1=venster->lrand;hor1<=venster->rrand;hor1++){
			int positiekern=hor1+width*ver1;
			int positiebuur=hor1+INTERSAMPLING*THETAX+width*(ver1-INTERSAMPLING*THETAY);
			if (scanbijhouder[positiekern]==2&&scanbijhouder[positiebuur]==2){
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
*/
/*Gebiedje wat juist gebruikt is om de coocmatrix mee uit te rekenen, 'bij de
                                                   achtergrond trekken'*/

void
GebiedDeactiveren (int width, const struct Venster *venster,
		   int *scanbijhouder)
{
  int hor1, ver1;
  for (ver1 = venster->trand; ver1 <= venster->brand; ver1++)
    {
      for (hor1 = venster->lrand; hor1 <= venster->rrand; hor1++)
	{
	  if (scanbijhouder[hor1 + width * ver1] == 2)
	    scanbijhouder[hor1 + width * ver1] = 3;
	}
    }
}

/*Aan de hand van de coocmatrix rekenen we verschillende
                                  statistische parameters uit*/

/*Uniformiteit*/

double
BerekenUniformiteit (const double *coocmatrix)
{
  int hor1, ver1;
  double som = 0;
  for (ver1 = 0; ver1 < 256; ver1++)
    {
      for (hor1 = 0; hor1 < 256; hor1++)
	{
	  som +=
	    coocmatrix[hor1 + 256 * ver1] * coocmatrix[hor1 + 256 * ver1];
	}
    }
  return (som);
}

/*Contrast*/

double
BerekenContrast (const double *coocmatrix)
{
  int hor1, ver1;
  double som = 0;
  for (ver1 = 0; ver1 < 256; ver1++)
    {
      for (hor1 = 0; hor1 < 256; hor1++)
	{
	  som +=
	    (ver1 - hor1) * (ver1 - hor1) * coocmatrix[hor1 + 256 * ver1];
	}
    }
  return (som);
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
 /*Correlatie */
/*
double BerekenCorrelatie(int *coocmatrix){
int hor1,ver1;
double mux,muy,sigmax,sigmay,som=0;
for

		
Dit moeten we nog eens goed uitzoeken*/

/* Gemiddeldewaarde filter op beeld toepassen, met (2*RANGE+1)x(2*RANGE+1) window*/

void
Beeldblurren (const ImlibImage * compbeeld, int *blurbeeld)
{

  int hor, width;
  hor = RANGE;
  width = compbeeld->rgb_width;
  while (hor < width - RANGE)
    {
      int ver, height;
      ver = RANGE;
      height = compbeeld->rgb_height;
      while (ver < height - RANGE)
	{
	  int som;
	  int ver1;
	  int index = hor + width * ver;
	  som = 0;
	  for (ver1 = -RANGE; ver1 <= RANGE; ver1++)
	    {
	      int hor1;
	      for (hor1 = -RANGE; hor1 <= RANGE; hor1++)
		{
		  som +=
		    compbeeld->rgb_data[index * 3 +
					(hor1 + ver1 * width) * 3];
		}
	    }
	  blurbeeld[index] = som / ((2 * RANGE + 1) * (2 * RANGE + 1));
	  ver++;
	}
      hor++;
    }
}


/*Een gebiedje waarvan de coocurrentiematrix berekend is, kleuren*/

void
KleurGebiedje (ImlibImage * compbeeld, const struct Venster *venster,
	       const int *scanbijhouder, const struct Kleur *kleur)
{
  int ver1;
  for (ver1 = venster->trand; ver1 <= venster->brand; ver1++)
    {
      int hor1;
      for (hor1 = venster->lrand; hor1 <= venster->rrand; hor1++)
	{
	  int index;
	  int width = compbeeld->rgb_width;
	  index = hor1 + width * ver1;
	  if (scanbijhouder[index] == 2)
	    {
	      compbeeld->rgb_data[index * 3] = kleur->rood * 255 / KLEURSTAP;
	      compbeeld->rgb_data[index * 3 + 1] =
		kleur->groen * 255 / KLEURSTAP;
	      compbeeld->rgb_data[index * 3 + 2] =
		kleur->blauw * 255 / KLEURSTAP;
	    }
	}
    }
}

/* Verandert de kleur aan waarmee je het volgende gebiedje vult*/

void
PasVulkleurAan (struct Kleur *kleur /*, double contrast */ )
{
/*  int temp1, temp2, temp3;
  temp1 = temp2 = temp3 = 0;
  if (contrast >= TOPCONTRAST)
    {
      temp1 = 255;
    }
  if (contrast <= BOTTOMCONTRAST)
    {
      temp2 = 255;
    }
  if (contrast > BOTTOMCONTRAST && contrast < TOPCONTRAST)
    {
      temp3 = 255;
    }
//  temp=floor((TOPCONTRAST-contrast)*255/(TOPCONTRAST-BOTTOMCONTRAST));}


  kleur->rood = temp1;
  kleur->groen = temp2;
  kleur->blauw = temp3;
*/


  kleur->rood++;
  if (kleur->rood > KLEURSTAP)
    {
      kleur->rood = 0;
      kleur->groen++;
      if (kleur->groen > KLEURSTAP)
	{
	  kleur->groen = 0;
	  kleur->blauw++;
	  if (kleur->blauw > KLEURSTAP)
	    puts ("Grotere KLEURSTAP nemen!");
	}
    }
}

/*Een vakje van het kleurpalet inkleuren*/

void
TekenKleurpalet (ImlibImage * kleurpalet, const struct Kleur *kleur)
{
  //De lengte van de ribbe van 1 kleurpaletvakje
  int kleurpaletafmeting =
    500 / ceil (sqrt (KLEURSTAP * KLEURSTAP * KLEURSTAP));
  //De coordinaten van het te vullen vakje in het kleurpalet
  static int xcoord = 0;
  static int ycoord = 0;
  //Het daadwerkelijke kleuren
  int hor, ver;
  for (ver = ycoord * kleurpaletafmeting;
       ver < (ycoord + 1) * kleurpaletafmeting; ver++)
    {
      for (hor = xcoord * kleurpaletafmeting;
	   hor < (xcoord + 1) * kleurpaletafmeting; hor++)
	{
	  int index;
	  index = hor + 500 * ver;
	  kleurpalet->rgb_data[index * 3] = kleur->rood * 255 / KLEURSTAP;
	  kleurpalet->rgb_data[index * 3 + 1] =
	    kleur->groen * 255 / KLEURSTAP;
	  kleurpalet->rgb_data[index * 3 + 2] =
	    kleur->blauw * 255 / KLEURSTAP;
	}
    }
  //Opschuiven naar het volgende vakje
  xcoord++;
  if (xcoord >= 500 / kleurpaletafmeting)
    {
      xcoord = 0;
      ycoord++;
      if (ycoord >= 500 / kleurpaletafmeting)
	printf ("%s", "er zit een bug in de kleurpalet!");
    }
}


/* Hier wordt berekend hoe het aantal het aantal keer dat gefilterd
wordt (de sterkte van de fitlering) afhangt van de uniformiteit*/

int
FilterKnop (double contrast, int gem_grijswaarde_regio)
{
  double grijsratio;
  if (contrast > TOPCONTRAST)
    {
      //if(gem_grijswaarde_regio>GRENSGRIJSWAARDE){
      return 0;
      //}
//return ceil(MAXAANTITERATIES/2);
    }
//grijsratio=gem_grijswaarde_regio/maxgrijswaarde;
//if(grijsratio>1) grijsratio=1;
  if (contrast < BOTTOMCONTRAST)
    {
      if (gem_grijswaarde_regio < GRENSGRIJSWAARDE)
	{
	  return MAXAANTITERATIES;
	}
//contrast=BOTTOMCONTRAST;
      else
	{
	  return 0;
	}
    }

  else
    {
      return floor ((contrast - TOPCONTRAST) * MAXAANTITERATIES /
		    (BOTTOMCONTRAST - TOPCONTRAST));
    }

/*   return floor(MAXAANTITERATIES*(1-grijsratio)+.5);
return floor((contrast-TOPCONTRAST)*MAXAANTITERATIES/(BOTTOMCONTRAST-TOPCONTRAST)*
             (1-grijsratio));*/

}

/* Vanaf hier komt het deel van het crimminfilter*/
void
PasCrimminfilterToe (ImlibImage * resultaatbeeld, ImlibImage * gefilterdbeeld,
		     int width, const int *scanbijhouder,
		     const struct Venster *venster, double contrast,
		     int gem_grijswaarde_regio)
{

  int hor, ver, index, filtersterkte;
  int loop = 0;
  filtersterkte = FilterKnop (contrast, gem_grijswaarde_regio);

// Om de gezonde gebieden donkerder te krijgen:

  if (filtersterkte > 1)
    {

      while (loop < filtersterkte)
	{
	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - width * 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + width * 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - width * 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + width * 3])
			{
			  if (resultaatbeeld->rgb_data[index] > 2)

			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 3;
			}
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//N-S direction
/*
	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + 3])
			{

			  if (resultaatbeeld->rgb_data[index] > 2)
			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 3;
			}
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);*/	//E-W direction

	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - width * 3 + 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + width * 3 - 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - width * 3 + 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + width * 3 - 3])
			{
			  if (resultaatbeeld->rgb_data[index] > 2)
			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 3;
			}
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//NE-SW direction

	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - width * 3 - 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + width * 3 + 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - width * 3 - 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + width * 3 + 3])
			{
			  if (resultaatbeeld->rgb_data[index] > 2)
			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 3;
			}
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//NW-SE direction
	  loop++;
	}
    }

//Om de zieke gebieden lichter te krijgen:
  if (filtersterkte <= 1)
    {
      while (loop < MAXAANTITERATIES)
	{
	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {
		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - width * 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + width * 3])
			{
			  if (resultaatbeeld->rgb_data[index] > 0)

			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 1;
			}
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - width * 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + width * 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//N-S direction

	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {

		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + 3])
			{

			  if (resultaatbeeld->rgb_data[index] > 0)
			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 1;
			}
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//E-W direction


	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {

		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - width * 3 + 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + width * 3 - 3])
			{
			  if (resultaatbeeld->rgb_data[index] > 0)
			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 1;
			}
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - width * 3 + 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + width * 3 - 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//NE-SW direction

	  for (ver = venster->trand; ver <= venster->brand; ver++)
	    {
	      for (hor = venster->lrand; hor <= venster->rrand; hor++)
		{
		  index = (hor + ver * width) * 3;
		  if (scanbijhouder[index / 3] == 2)
		    {

		      if (resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index - width * 3 - 3]
			  || resultaatbeeld->rgb_data[index] >
			  resultaatbeeld->rgb_data[index + width * 3 + 3])
			{
			  if (resultaatbeeld->rgb_data[index] > 0)
			    gefilterdbeeld->rgb_data[index] =
			      resultaatbeeld->rgb_data[index] - 1;
			}
		      if (resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index - width * 3 - 3]
			  || resultaatbeeld->rgb_data[index] <
			  resultaatbeeld->rgb_data[index + width * 3 + 3])
			gefilterdbeeld->rgb_data[index] =
			  resultaatbeeld->rgb_data[index] + 1;
		    }
		}
	    }
	  Beeldaanpassen (resultaatbeeld, gefilterdbeeld, width, venster);	//NW-SE direction
	  loop++;
	}

    }
}

/* De definities van de functies */

void
Beeldaanpassen (ImlibImage * resultaatbeeld,
		const ImlibImage * gefilterdbeeld, int width,
		const struct Venster *venster)
{

  int v, h, index;
  for (v = venster->trand; v <= venster->brand; v++)
    {
      for (h = venster->lrand; h <= venster->rrand; h++)
	{
	  index = (h + width * v) * 3;
	  resultaatbeeld->rgb_data[index] = gefilterdbeeld->rgb_data[index];
	  resultaatbeeld->rgb_data[index + 1] =
	    gefilterdbeeld->rgb_data[index];
	  resultaatbeeld->rgb_data[index + 2] =
	    gefilterdbeeld->rgb_data[index];
	}
    }
}

int
BerekenGemGrijswaarde (const ImlibImage * compbeeld, int width,
		       const int *scanbijhouder,
		       const struct Venster *venster, int aantalpunten)
{

  int hor, ver;
  int som = 0;

  for (ver = venster->trand; ver <= venster->brand; ver++)
    {
      for (hor = venster->lrand; hor <= venster->rrand; hor++)
	{
	  int index = hor + width * ver;
	  if (scanbijhouder[index] == 2)
	    {
	      som += compbeeld->rgb_data[index * 3];
	    }
	}
    }
  return floor (som / aantalpunten + .5);
}

void
Beeldcompressen (const ImlibImage * geblurdbeeld, int *blurbeeld, int width,
		 int height)
{

  int hor, ver, index;
  for (ver = 0; ver < height; ver++)
    {
      for (hor = 0; hor < width; hor++)
	{
	  index = hor + ver * width;
	  blurbeeld[index] = geblurdbeeld->rgb_data[index * 3];
	}
    }
}
