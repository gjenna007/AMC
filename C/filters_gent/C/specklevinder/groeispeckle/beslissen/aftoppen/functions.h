

void Maketopslist (const ImlibImage* origineel, const ImlibImage *peaks,
                   gpixel* toppen, const int width, const int height);

void Growspeckle (const int seedver, const int seedhor, const int 
                  seedgrey,
                  const ImlibImage* origineel, char* resultaatarray,
                  const ImlibImage* silhouet, const int width,
                  int* specklebox); 

int Randjemaken (const int* specklebox, char * resultaatarray,
                  const int width, const ImlibImage* origineel);
