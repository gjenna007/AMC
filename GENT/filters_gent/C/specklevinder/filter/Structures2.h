#include <Imlib.h>
#include "definitions.h"

typedef struct{
        int ver;
        int hor;
       }pixel;
/*
typedef struct{
        int n_o_pixels;
        pixel first_pixel;
       }speckle;

typedef struct{
	double ver;
	double hor;
       }vector;
*/

//Alle gebruikte functies

//void Kaderen(ImlibImage* silhouet);

//pixel Zoektop(const ImlibImage* beeld, const ImlibImage* silhouet, const int* specklebijhouder,
//							int beginver, int beginhor);
							
void Groeispeckle(const ImlibImage *beeld, const ImlibImage *silhouet, int* specklebijhouder,
                 const pixel witstepunt, int* venster);

int Randjemaken(const ImlibImage* beeld, int* specklebijhouder, const int* venster, pixel* rand);

void Filter (const ImlibImage *beeld, ImlibImage *resultaat, const int *venster, const pixel* rand, const int randteller, int* specklebijhouder,
int beslissing);

int Klassificeer(const ImlibImage *compbeeld, const pixel witstepunt);

//double Richtingscoefficient(speckle);

//vector Radiaal(speckle);

//void Specklekleuren(ImlibImage *resultaat, pixel 
//coordinaten[][SPECKLELENGTE], const int volgnummer, FILE* fpcheck);

