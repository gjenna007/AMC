 #define RANGE 5 /*RANGE is de 'straal' van het masker waarmee
                   ik het beeld ga blurren. Ik ga dus een
                   gemiddelde waarde filter toepassen met een
                   11x11 window. Nu is RANGE=floor(11/2)*/
 #define TOLERANTIE 2/*De range waarin de grijswaarden
 mogen afwijken om tot hetzelfde gebied gerekend te worden*/
 #define THETAX 1
 #define THETAY 0/* De vector (THETAX,THETAY) bepaalt de hoek
                          waaronder we de overgangen bekijken;
                    b.v.  THETAX=THETAY=1 levert een hoek van 45 graden
                           tegen de klok in !!(zoals in de wiskunde dus)*/
#define INTERSAMPLING 1 /*De zg "intersampling-space"*/
 #define MINGEBIEDSGROOTTE 200
 #define MAXGEBIEDSGROOTTE 150000
 #define KLEURSTAP 12/*De lengte van een ribbe van de kleurkubus*/
 #define MAXAANTITERATIES 4
 #define BOTTOMCONTRAST 10
 #define TOPCONTRAST 40
 #define GRENSGRIJSWAARDE 67
