 #include <Imlib.h>
 #include <stdlib.h>
 #define iteratie 30
 int main()
   {
     ImlibData *id;
     ImlibData *id2;
     ImlibImage *im;
     ImlibImage *im2;

     int width,height,h,v,loop,index;
     Display *disp;

     void Beeldaanpassen(ImlibImage*,ImlibImage*,int,int);

    disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
    id =Imlib_init(disp);
    id2=Imlib_init(disp);

 /* Load the image specified as the first argument */
    im =Imlib_load_image(id,"deruddere05.tif");
    im2=Imlib_load_image(id2,"deruddere05.tif");
 /* Suck the image's original width and height out of the Image structure */
    width=im->rgb_width;
    height=im->rgb_height;

 /* Eerst stellen we ons er zeker van dat in de rood, groen, en blauw component inderdaad dezelfde waarde staat*/
    v = 0;
   while(v<height) {
     h = 0;
     while (h<width) {
     int kleur;
     index = (h+width*v)*3;
   	kleur = (im->rgb_data[index]+im->rgb_data[index+1]+im->rgb_data[index+2])/3;
        im->rgb_data[index]=im->rgb_data[index+1]=im->rgb_data[index+2]=kleur;
       h ++;
     }
     v ++;
   }

   /*Hier beginnen we met het daadwerkelijke filter*/



  loop=0;
  while (loop<iteratie){
    for (v=1;v<height;v++){
      for (h=1;h<width;h++){
        index=(h+v*width)*3;
       if (im->rgb_data[index]<im->rgb_data[index-width*3]||im->rgb_data[index]<im->rgb_data[index+width*3])
          im2->rgb_data[index]=im->rgb_data[index]+1;
        if (im->rgb_data[index]>im->rgb_data[index-width*3]||im->rgb_data[index]>im->rgb_data[index+width*3]){
          if (im->rgb_data[index]>0)
          im2->rgb_data[index]=im->rgb_data[index]-1;
        }
       }
     }
  Beeldaanpassen(im,im2,width,height);
/* loop++;
 }

      loop=0;
  while (loop<iteratie){*/
    for (v=1;v<height;v++){
      for (h=1;h<width;h++){
        index=(h+v*width)*3;
       if (im->rgb_data[index]<im->rgb_data[index-3]||im->rgb_data[index]<im->rgb_data[index+3])
          im2->rgb_data[index]=im->rgb_data[index]+1;
        if (im->rgb_data[index]>im2->rgb_data[index-3]||im->rgb_data[index]>im->rgb_data[index+3]){
          if (im->rgb_data[index]>0)
          im2->rgb_data[index]=im2->rgb_data[index]-1;
        }
       }
     }
 Beeldaanpassen(im,im2,width,height);
/* loop++;
 }

 loop=0;
  while (loop<iteratie){*/
    for (v=1;v<height;v++){
      for (h=1;h<width;h++){
        index=(h+v*width)*3;
        if (im->rgb_data[index]<im->rgb_data[index-width*3+3]||im->rgb_data[index]<im->rgb_data[index+width*3-3])
          im2->rgb_data[index]=im->rgb_data[index]+1;
        if (im->rgb_data[index]>im->rgb_data[index-width*3+3]||im->rgb_data[index]>im->rgb_data[index+width*3-3]){
          if (im->rgb_data[index]>1)
          im2->rgb_data[index]=im->rgb_data[index]-1;
        }
      }
    }
 Beeldaanpassen(im,im2,width,height);
/* loop++;
  }

 loop=0;
  while (loop<iteratie){*/
    for (v=1;v<height;v++){
      for (h=1;h<width;h++){
        index=(h+v*width)*3;
        if (im->rgb_data[index]<im->rgb_data[index-width*3-3]||im->rgb_data[index]<im->rgb_data[index+width*3+3])
          im2->rgb_data[index]=im->rgb_data[index]+1;
        if (im->rgb_data[index]>im->rgb_data[index-width*3-3]||im->rgb_data[index]>im->rgb_data[index+width*3+3]){
          if (im->rgb_data[index]>1)
          im2->rgb_data[index]=im->rgb_data[index]-1;
        }
      }
    }
 Beeldaanpassen(im,im2,width,height);
 loop++;
  }

   Imlib_save_image_to_ppm(id, im, "derudd05ownzx30.ppm");
   return 0;
}

/* De definities van de functies */

void Beeldaanpassen(ImlibImage *im, ImlibImage *im2,int width,int height){

int v,h,index;
for(v=0;v<height;v++){
  for (h=0;h<width;h++){
    index=(h+width*v)*3;
    im->rgb_data[index]=im2->rgb_data[index];
    im->rgb_data[index+1]=im2->rgb_data[index];
    im->rgb_data[index+2]=im2->rgb_data[index];
  }
}
     }









