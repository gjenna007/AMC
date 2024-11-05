
CC=gcc -Wall -ggdb -I/usr/X11R6/include -I/usr/local/include -L/usr/X11R6/lib -L/usr/local/lib -lX11 -lXext -ljpeg -lpng -ltiff  -lz -lgif -lm -lImlib
OBJECTEN= specklevinder.o kaderen.o zoektop.o groeispeckle.o randjemaken.o  specklekleuren.o

speckle: $(OBJECTEN)
	$(CC) $(OBJECTEN) -o speckle

zoektop.o: zoektop.c structures.h definitions.h
	$(CC) -c zoektop.c  

groeispeckle.o: groeispeckle.c structures.h definitions.h
	$(CC) -c groeispeckle.c

randjemaken.o: randjemaken.c definitions.h  
	$(CC) -c randjemaken.c

specklekleuren.o: specklekleuren.c structures.h definitions.h
	$(CC) -c specklekleuren.c

specklevinder.o: specklevinder.c structures.h definitions.h
	$(CC) -c specklevinder.c

kaderen.o: kaderen.c definitions.h
	$(CC) -c kaderen.c
clear:
	rm *.o
