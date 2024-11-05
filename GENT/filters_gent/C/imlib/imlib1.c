/* cc imlib1.c -o imlib1 -I/usr/X11R6/include -I/usr/local/include -L/usr/X11R6/lib -L/usr/local/lib -lX11 -lXext -ljpeg -lpng -ltiff -lz -lgif -lm -lImlib */

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/shape.h>
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
if (argc<=1)
{
printf("Usage:\n %s image_file\n",argv[0]);
exit(1);
}
disp=XOpenDisplay(NULL);
id=Imlib_init(disp);
im=Imlib_load_image(id,argv[1]);
w=im->rgb_width; h=im->rgb_height;
win=XCreateWindow(disp, DefaultRootWindow(disp),0,0,w,h,0,id->x.depth,
                  InputOutput, id->x.visual,0,&attr);
XSelectInput(disp,win,StructureNotifyMask);
Imlib_render(id, im, w, h);
p=Imlib_move_image(id, im);
m=Imlib_move_mask(id, im);
XSetWindowBackgroundPixmap(disp,win,p);
if (m) XShapeCombineMask(disp, win, ShapeBounding, 0, 0, m, ShapeSet);
XMapWindow(disp, win);
XSync(disp, False);
for(;;)
{
XEvent ev;
XNextEvent (disp, &ev);
if (ev.type==ConfigureNotify)
{
w=ev.xconfigure.width; h=ev.xconfigure.height;
Imlib_render(id, im, w, h);
Imlib_free_pixmap(id, p);
p=Imlib_move_image(id, im);
m=Imlib_move_mask(id, im);
XSetWindowBackgroundPixmap(disp, win, p);
if (m) XShapeCombineMask(disp, win, ShapeBounding, 0, 0, m, ShapeSet);
XClearWindow(disp, win);
XSync(disp, False);
}
}
}






