 #include <Imlib.h>
 #include <math.h>
 #define alfa 8
 #define K 5.0
 #define deltat 1.0/6.0

 int main()
   {
     ImlibData *dechtbeeld;
     ImlibData *dblurbeeld;
     ImlibImage *echtbeeld;
     ImlibImage *blurbeeld;

     int width, height,hor,ver,t;
     Display *disp;

    disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
    dechtbeeld =Imlib_init(disp);
    dblurbeeld=Imlib_init(disp);

 /* Load the image specified as the first argument */
    echtbeeld =Imlib_load_image(dechtbeeld,"deruddere05.tif");
    blurbeeld=Imlib_load_image(dblurbeeld,"deruddere05.tif");
 /* Suck the image's original width and height out of the Image structure */
    width=echtbeeld->rgb_width;
    height=echtbeeld->rgb_height;


for (t=0;t<50;t++){
  int hor1,ver1;
  for (hor=1;hor<width-1;hor++){
     for (ver=1;ver<height-1;ver++){
     double deltaIhoru, deltaIveru, deltaIhorl, deltaIverl;
     double choru, chorl, cveru, cverl, deltaI;

       deltaIhoru=echtbeeld->rgb_data[3*(hor+1+width*(ver))]-echtbeeld->rgb_data[3*(hor+width*(ver))];
       deltaIhorl=echtbeeld->rgb_data[3*(hor+width*(ver))]-echtbeeld->rgb_data[3*(hor-1+width*(ver))];

       deltaIveru=echtbeeld->rgb_data[3*(hor+width*(ver+1))]-echtbeeld->rgb_data[3*(hor+width*(ver))];
       deltaIverl=echtbeeld->rgb_data[3*(hor+width*(ver))]-echtbeeld->rgb_data[3*(hor+width*(ver-1))];

       choru=1/(1+pow((abs(deltaIhoru))/K,(1+alfa)));
       chorl=1/(1+pow((abs(deltaIhorl))/K,(1+alfa)));

       cveru=1/(1+pow((abs(deltaIveru)/K),(1+alfa)));
       cverl=1/(1+pow((abs(deltaIverl)/K),(1+alfa)));

       deltaI= (choru*deltaIhoru-chorl*deltaIhorl)+(cveru*deltaIveru-cverl*deltaIverl);

       blurbeeld->rgb_data[3*(hor+width*(ver))]=echtbeeld->rgb_data[3*(hor+width*(ver))]+deltat*deltaI;
      }
  }

  for(ver1=0;ver1<height;ver1++){
    for(hor1=0;hor1<width;hor1++){
      int index=(hor1+width*ver1)*3;
      echtbeeld->rgb_data[index]=blurbeeld->rgb_data[index];
      echtbeeld->rgb_data[index+1]=blurbeeld->rgb_data[index];
      echtbeeld->rgb_data[index+2]=blurbeeld->rgb_data[index];
    }
  }
  printf("%d\n",t);
}

   Imlib_save_image_to_ppm(dechtbeeld, echtbeeld, "anisodiffresultaatderudd05k=5alfa8t50.ppm");
   return 0;
}









