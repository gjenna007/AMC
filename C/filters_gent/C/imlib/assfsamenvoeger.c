#include <Imlib.h>

int main (int argc, char **argv)
{
Display *disp;
ImlibData *id;
XSetWindowAttributes attr;
Window win;
ImlibImage *im;
Pixmap p,m;
int w,h;
int result, i, j;
char beeld;

if (argc<=1)
  {
 printf("Usage:\n %s image_file\n",argv[0]); exit(1);
  }
disp=XOpenDisplay(NULL);
id=Imlib_init(disp);
im=Imlib_load_image(id,argv[1]);
w=im->rgb_width; h=im->rgb_height;
for(i=1; i<=w; ++i){
  for (j=1; j<=h; ++j){
  im->rgb_data[i+j*w]=255-im->rgb_data[i+j*w];
  }
}  
  
result=Imlib_save_image_to_ppm(id,im,beeld);
}



