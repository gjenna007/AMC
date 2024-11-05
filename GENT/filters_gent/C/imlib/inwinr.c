#include <Imlib.h>
#include <stdlib.h>

     ImlibData *id;
     ImlibImage *im;
     int w,h,i,j,innersize ;
     typedef struct{int pixel[9];} window;
	 window *helebeeldr;
         window *helebeeldg;
         window *helebeeldb;
	
     Display *disp;

 int main() {

     disp=XOpenDisplay(NULL);
 /* Immediately afterwards Intitialise Imlib */
     id=Imlib_init(disp);
 /* Load the image specified as the first argument */
     im=Imlib_load_image(id,"gbright.bmp");
 /* Suck the image's original width and height out of the Image structure */
    w=im->rgb_width;
    h=im->rgb_height; 

    innersize=(w-2)*(h-2);
    helebeeldr = malloc(sizeof(window) * innersize);
    helebeeldg = malloc(sizeof(window) * innersize);
    helebeeldb = malloc(sizeof(window) * innersize);
     i=1;
     while (i<w-1) {
     j = 1;
     while (j<h-1) {
       int index = (i+w*j)*3;
        helebeeldr[(i-1)+(j-1)*w].pixel[0] = im->rgb_data[index+(-w-1)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[1] = im->rgb_data[index+(-w)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[2] = im->rgb_data[index+(-w+1)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[3] = im->rgb_data[index+(-1)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[4] = im->rgb_data[index];
       helebeeldr[(i-1)+(j-1)*w].pixel[5] = im->rgb_data[index+(1)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[6] = im->rgb_data[index+(w-1)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[7] = im->rgb_data[index+(w)*3];
       helebeeldr[(i-1)+(j-1)*w].pixel[8] = im->rgb_data[index+(w+1)*3];
    

       j ++;
     }
     i ++;
     }
       
   return 1;
}












