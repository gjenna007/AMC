#include <Imlib.h>
#include <stdio.h>
#include <math.h>
#include "structures.h"
#include "definitions.h"

/* int main(){ */
/* ImlibData *dbeeld; */
/* ImlibData *dsilhouet; */
/* ImlibImage *beeld; */
/* ImlibImage *silhouet;  */
/* int venster[4]; */
/* pixel witstepunt;   */
/* Display *disp; */
/* int* specklebijhouder;   */
/* disp=XOpenDisplay(NULL); */

/* dbeeld=Imlib_init(disp); */
/* dsilhouet=Imlib_init(disp);  */
/* beeld=Imlib_load_image(dbeeld,BEELD); */
/* silhouet=Imlib_load_image(dsilhouet,SILHOUET);   */
/* specklebijhouder=calloc(silhouet->rgb_width*silhouet->rgb_height,sizeof(int)); */
/*  witstepunt.ver=100; */
/*  witstepunt.hor=245; */
/*  specklebijhouder[245+722*100]=2; */

/* Groeispeckle(beeld,silhouet,specklebijhouder,witstepunt,venster); */
/* return 0; */
/* } */
void Groeispeckle(const ImlibImage *beeld, const ImlibImage *silhouet,
                        int *specklebijhouder, const pixel witstepunt,
                         int *venster){

int topvenster, bottomvenster, nieuwtopvenster, nieuwbottomvenster;
int lrandvenster, rrandvenster, nieuwlrandvenster, nieuwrrandvenster;
int width,top,ietsveranderd;
width=beeld->rgb_width;
top=witstepunt.hor+width*witstepunt.ver;
topvenster=bottomvenster=nieuwtopvenster=nieuwbottomvenster=witstepunt.ver;
lrandvenster=rrandvenster=nieuwlrandvenster=nieuwrrandvenster=witstepunt.hor;
	

ietsveranderd=1;
//printf("%d%c%d\n", topvenster, ' ',lrandvenster);
while(ietsveranderd==1){
int ver,hor;
ietsveranderd=0;
for(ver=topvenster;ver<=bottomvenster;ver++){
  for(hor=lrandvenster;hor<=rrandvenster;hor++){
    int positie;
    positie=hor+width*ver;
    //printf("%d%c%d%c", topvenster, ' ',bottomvenster,' ');
    //printf("%d%c%d\n", lrandvenster, ' ',rrandvenster);
    if(specklebijhouder[positie]==2&&
       beeld->rgb_data[positie*3]==0&&
       beeld->rgb_data[positie*3+1]==0&&
       beeld->rgb_data[positie*3+2]==255){
      if (beeld->rgb_data[(positie-width)*3]==0&&
          beeld->rgb_data[(positie-width)*3+1]==0&&
          beeld->rgb_data[(positie-width)*3+2]==255&&
          specklebijhouder[positie-width]==0){
          specklebijhouder[positie-width]=2;
          if (ver==topvenster) nieuwtopvenster=topvenster-1;
      }
      if (beeld->rgb_data[(positie+width)*3]==0&&
          beeld->rgb_data[(positie+width)*3+1]==0&&
          beeld->rgb_data[(positie+width)*3+2]==255&&
          specklebijhouder[positie+width]==0 ){
          specklebijhouder[positie+width]=2;
	  if (ver==bottomvenster) nieuwbottomvenster=bottomvenster+1;
      }
      if (beeld->rgb_data[(positie-1)*3]==0&&
          beeld->rgb_data[(positie-1)*3+1]==0&&
          beeld->rgb_data[(positie-1)*3+2]==255&&
          specklebijhouder[positie-1]==0){
          specklebijhouder[positie-1]=2;
          if (hor==lrandvenster) nieuwlrandvenster=lrandvenster-1;
      }
      if (beeld->rgb_data[(positie+1)*3]==0&&
          beeld->rgb_data[(positie+1)*3+1]==0&&
          beeld->rgb_data[(positie+1)*3+2]==255&&
          specklebijhouder[positie+1]==0){
          specklebijhouder[positie+1]=2;
	  if(hor==rrandvenster) nieuwrrandvenster=rrandvenster+1;
      }
      specklebijhouder[positie]=3;
      ietsveranderd=1;
    }
  }
}
lrandvenster=nieuwlrandvenster;
rrandvenster=nieuwrrandvenster;
topvenster=nieuwtopvenster;
bottomvenster=nieuwbottomvenster;
}	
venster[LINKS]=lrandvenster;
venster[RECHTS]=rrandvenster;
venster[TOP]=topvenster;
venster[BOTTOM]=bottomvenster;	
}
