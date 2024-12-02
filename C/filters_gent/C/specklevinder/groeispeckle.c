#include <Imlib.h>
#include <stdio.h>
#include <math.h>
#include "structures.h"
#include "definitions.h"

int Groeispeckle(const ImlibImage *beeld, const ImlibImage *silhouet,
                        int *specklebijhouder, const pixel witstepunt,
                        pixel coordinaten[][SPECKLELENGTE], int *venster){

int topvenster, bottomvenster, nieuwtopvenster, nieuwbottomvenster;
int lrandvenster, rrandvenster, nieuwlrandvenster, nieuwrrandvenster;
int pixelnummer,width,top,ietsveranderd;
static int speckleteller=0;
pixelnummer=1;
speckleteller++;
width=beeld->rgb_width;
top=witstepunt.hor+width*witstepunt.ver;
topvenster=bottomvenster=nieuwtopvenster=nieuwbottomvenster=witstepunt.ver;
lrandvenster=rrandvenster=nieuwlrandvenster=nieuwrrandvenster=witstepunt.hor;
	
specklebijhouder[lrandvenster+width*topvenster]=speckleteller+1;
ietsveranderd=1;
printf("%d%c%d\n", topvenster, ' ',lrandvenster);
if(speckleteller>AANTALSPECKLES) printf("%d%c%d%s\n",topvenster,' ',lrandvenster," Dit worden meer speckles dan verwacht!");
while(ietsveranderd==1){
int ver,hor;
ietsveranderd=0;
for(ver=topvenster;ver<=bottomvenster;ver++){
  for(hor=lrandvenster;hor<=rrandvenster;hor++){
    int positie;
    positie=hor+width*ver;
    if(specklebijhouder[positie]==speckleteller+1){
      if (specklebijhouder[positie-width]==0&&
        silhouet->rgb_data[(positie-width)*3]!=0&&
        abs(beeld->rgb_data[(positie-width)*3]-
        beeld->rgb_data[top*3])<=TOLERANTIE){
        specklebijhouder[positie-width]=speckleteller+1;
        if (ver==topvenster) nieuwtopvenster=topvenster-1;
      }
      if (specklebijhouder[positie+width]==0&&
        silhouet->rgb_data[(positie+width)*3]!=0&&
        abs(beeld->rgb_data[(positie+width)*3]-
        beeld->rgb_data[top*3])<=TOLERANTIE){
        specklebijhouder[positie+width]=speckleteller+1;
	if (ver==bottomvenster) nieuwbottomvenster=bottomvenster+1;
      }
      if (specklebijhouder[positie-1]==0&&
        silhouet->rgb_data[(positie-1)*3]!=0&&
        abs(beeld->rgb_data[(positie-1)*3]-
        beeld->rgb_data[top*3])<=TOLERANTIE){
        specklebijhouder[positie-1]=speckleteller+1;
        if (hor==lrandvenster) nieuwlrandvenster=lrandvenster-1;
      }
      if (specklebijhouder[positie+1]==0&&
        silhouet->rgb_data[(positie+1)*3]!=0&&
        abs(beeld->rgb_data[(positie+1)*3]-
        beeld->rgb_data[top*3])<=TOLERANTIE){
        specklebijhouder[positie+1]=speckleteller+1;
	if(hor==rrandvenster) nieuwrrandvenster=rrandvenster+1;
      }
      specklebijhouder[positie]=speckleteller;
      coordinaten[speckleteller][pixelnummer].ver=ver;
      coordinaten[speckleteller][pixelnummer].hor=hor;
      pixelnummer++;
      ietsveranderd=1;
      if (pixelnummer>SPECKLELENGTE) printf("%d%c%d%c%d%s\n",ver,' ',hor,' ',pixelnummer," Grotere SPECKLELENGTE nemen!");
    }
  }
}
lrandvenster=nieuwlrandvenster;
rrandvenster=nieuwrrandvenster;
topvenster=nieuwtopvenster;
bottomvenster=nieuwbottomvenster;
}	
// OP de 0-de plaats ->ver in de matrix schrijven uit hoeveel pixels de speckle bestaat
coordinaten[speckleteller][0].ver=pixelnummer-1;
venster[LINKS]=lrandvenster;
venster[RECHTS]=rrandvenster;
venster[TOP]=topvenster;
venster[BOTTOM]=bottomvenster;	
return (speckleteller);
}
