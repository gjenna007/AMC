
CC=gcc -Wall -ggdb -I/usr/X11R6/include -I/usr/local/include -L/usr/X11R6/lib -L/usr/local/lib -lX11 -lXext -ljpeg -lpng -ltiff  -lz -lgif -lm -lImlib
OBJECTEN= hoofdfie.o growspeckle.o randjemaken.o  maketopslist.o

hoofd: $(OBJECTEN)
	$(CC) $(OBJECTEN) -o hoofd

maketopslist.o: maketopslist.c structures.h definitions.h
	$(CC) -c maketopslist.c  

growspeckle.o: growspeckle.c structures.h definitions.h
	$(CC) -c growspeckle.c

randjemaken.o: randjemaken.c definitions.h structures.h
	$(CC) -c randjemaken.c

hoofdfie.o: hoofdfie.c definitions.h structures.h functions.h
	$(CC) -c hoofdfie.c
                   
clear:
	rm *.o
