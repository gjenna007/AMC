#define SILHOUET "silhouetcriel02.tif" 
#define ORIGINEEL "criel02.tif"
#define PEAKS "peaks80criel02.tif" //Dit zijn de toppen BINNEN DE 
// SILHOUET (er moet hier dus een AND operatie op uitgevoerd zijn)
#define RESULTAAT "biscriel02speckles.ppm"
#define N_O_TOPS 3046 //sum(sum(peaks))
#define RANGE 17 //de tolerantieruimte voor de region growing 
#define LEFT 0
#define RIGHT 1
#define TOP 2
#define BOTTOM 3
