#define SILHOUET "silhouetderuddere03.tif" 
#define ORIGINEEL "deruddere03.tif"
#define PEAKS "peaks80deruddere03.tif" //Dit zijn de toppen BINNEN DE 
// SILHOUET (er moet hier dus een AND operatie op uitgevoerd zijn)
#define RESULTAAT "bisderuddere03speckles.ppm"
#define N_O_TOPS 1573 //sum(sum(peaks))
#define RANGE 17 //de tolerantieruimte voor de region growing 
#define LEFT 0
#define RIGHT 1
#define TOP 2
#define BOTTOM 3
