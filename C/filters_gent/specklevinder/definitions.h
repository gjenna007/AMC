#define TOLERANTIE 11//controleert de groei van de speckles adhv de
//grijswaarden
//#define MAXAFWIJKING 20//controleert de striktheid van wat onder 
//"loodrecht" verstaan wordt
#define SPECKLEGRENS 80//dit is de minimale grijswaarde waarboven een pixel als potentiele speckle aangemerkt wordt
//#define TRANSDUCERX floating point	
//#define TRANSDUCERY floating point
#define BEELD "deruddere03.tif"
#define SILHOUET "silhouetderuddere03.tif"
#define RESULTAATBEELD "specklederuddere02.ppm" //je leest het beeld zelf in
//als startpunt, alles wat niet grijs is kun je later evt. zwart maken", hier
//worden de speckles op ingekleurd
//#define SPECKLESCOORDINATENFILE// naam van de file waar de 
//driedimensionale array met de coordinaten
// van de pixels die de speckles vormen worden opgeslagen
//#define SPECKLESFILE// De naam van de file waar de twee-dimensionale 
//array met dezelfde afmeting als het
// beeld, met daarin de nummers van de speckles opgeslagen wordt.
//#define TERUG "de naam waaronder het uiteindelijke resultaat gesaved wordt.ppm"
#define SPECKLELENGTE  2000 //maximaal aantal pixels van een speckle;
//breedte van de array SPECKLECOORDINATEN.
#define AANTALSPECKLES 500 //maximaal aantal speckles dat gevonden kan
//worden; lengte van de array SPECKLECOORDINATEN
#define LINKS 0
#define RECHTS 1
#define TOP 2
#define BOTTOM 3
#define TOPKADER 120
#define BOTTOMKADER 164
