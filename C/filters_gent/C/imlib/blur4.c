 #include <Imlib.h>
 #include <math.h>
 #define mask 11

 int main()
   {
     ImlibData *dechtbeeld;
     ImlibData *dblurbeeld;
     ImlibImage *echtbeeld;
     ImlibImage *blurbeeld;

     int w,h,i,j,k,l,somr,somg,somb, range;
     Display *disp;

    disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
    dechtbeeld =Imlib_init(disp);
    dblurbeeld=Imlib_init(disp);

 /* Load the image specified as the first argument */
    echtbeeld =Imlib_load_image(dechtbeeld,"deruddere03.tif");
    blurbeeld=Imlib_load_image(dblurbeeld,"deruddere03.tif");
 /* Suck the image's original width and height out of the Image structure */
    w=echtbeeld->rgb_width;
    h=echtbeeld->rgb_height;

    range = mask/2;

    i = range;
   while (i<w-range) {
     j = range;
     while (j<h-range) {
       int index = (i+w*j)*3;
       somr = 0;
       for (k= -range; k<=range; k++) {
	   for (l= -range; l<=range; l++) {
		somr += echtbeeld->rgb_data[index+(k*w+l)*3];
           }
       }
       blurbeeld->rgb_data[index] =somr/(mask*mask);
       somg = 0;
       for (k= -range; k<=range; k++) {
	   for (l= -range; l<=range; l++) {
		somg += echtbeeld->rgb_data[index+(k*w+l)*3+1];
           }
       }
       blurbeeld->rgb_data[index+1] = somg/(mask*mask);

       somb = 0;
       for (k= (-1)*range; k<=range; k++) {
	   for (l= (-1)*range; l<=range; l++) {
		somb += echtbeeld->rgb_data[index+(k*w+l)*3+2];
           }
       }
       blurbeeld->rgb_data[index+2] =somb/(mask*mask);
       j ++;
     }
     i ++;
   }
   printf("%d",range);
   Imlib_save_image_to_ppm(dblurbeeld, blurbeeld, "derudd03blur11x11.ppm");
   return 1;
}









