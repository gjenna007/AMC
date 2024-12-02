
extern int hor,ver,width;
extern int* blurbeeld;
extern int* scanbijhouder;
struct Venster{
	int lrand;
	int rrand;
	int trand;
	int brand;};
extern struct Venster* venster;
extern int Groeiregio(int horl, int verl, int widthl, const int
			*blurbeeld, int *scanbijhouder, struct Venster
			*venster);	
