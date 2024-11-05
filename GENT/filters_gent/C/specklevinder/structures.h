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

void Kaderen(ImlibImage* silhouet);

pixel Zoektop(const ImlibImage* beeld, const ImlibImage* silhouet, const int* specklebijhouder,
							int beginver, int beginhor);
							
int Groeispeckle(const ImlibImage *beeld, const ImlibImage *silhouet, int* specklebijhouder,
                 const pixel witstepunt, pixel coordinaten[][SPECKLELENGTE], int* venster);

void Randjemaken(const ImlibImage* beeld, int* specklebijhouder, const int* venster,
                 const int speckleteller);

//double Richtingscoefficient(speckle);

//vector Radiaal(speckle);

void Specklekleuren(ImlibImage *resultaat, pixel coordinaten[][SPECKLELENGTE], const int volgnummer, FILE* fpcheck);

