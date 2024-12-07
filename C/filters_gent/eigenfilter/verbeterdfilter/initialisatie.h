#include <Imlib.h>

extern int width, height;
extern int *scanbijhouder;
extern ImlibImage* silhouet;
struct Kleur{
          int rood;
          int groen;
          int blauw;};
extern struct Kleur* kleur;
extern void InitScanbijhouder(int *scanbijhouder, int widthl, int heightl,
                         const ImlibImage* silhouet);
extern void InitVulkleur (struct Kleur* kleur);


