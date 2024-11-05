#include <iostream.h>
#include <fstream.h>
#define D_USRectangle
#define D_USCilinder
#define D_USTissue
#define D_USSphericalScatterer
#define D_USGrid2D
#define D_USSphere
#define D_USCircle
#include <mrprel.hxx>
#include <rw/math/mathvec.h>
#include <rw/tvordvec.h>
#include <stdlib.h>

int main(){
char temp[10];

// Define some variables
USUint nr_circular_tissues=5;
USString tissuename="/images/vicar/tissue_models/model";
USString tissuename2;

//Define 5 circular tissues
USPosition direction1(0,1,0);
USPosition direction2(1,0,0);
RWTRandUniform<RWRandGenerator> the_generator;
USTissue<USCircle, USPointScatterer> the_tissue_model(uninitialized);

for (USUint i=0; i<nr_circular_tissues;i++){

  // Define the position and orientation of the tissue model
  USPosition center(i*.020,0,0);
  the_tissue_model.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USCircle*)the_tissue_model.GetSpatialInformation())->
  SetRadius(0.005);

  //Distribute the scatterers
  the_tissue_model.DistributeScatterersPseudoRandom(the_generator,
  (i+1)*0.0001,2,1,(i+1)*0.0001,2,1);

  //Save circles to disk
  sprintf(temp,"%d",(USUint) i);
  tissuename2=tissuename+temp;
  the_tissue_model.ClearScatterers();
}

for(i=0;i<nr_cirfcular_tissues;i++){
  //Define a background tissue model
  USTissue<USRectangle, USPointScatterer> the_background_tissue
  (uninitialized);
  USPosition pos (0.08,0,0);
  the_background_tissue.GetSpatialInformation()->Set(pos,pos+direction1,
  pos+direction2);
  ((USRectangle*) the_background_tissue.GetSpatialInformation())->SetAxes
  (0.060,0.015);

  //Distribute the scatterers outside the bounding box
  the_background_tissue.DistributeScatterersPseudoRandom(the_generator,
  (i+1)*0.0001,2,1,(i+1)*0.0001,2,1);

  //Define 5 cystic regions (radius,depth)
  for (USUint j=0;j<nr_circular_tissues;j++){
    USPosition center_cyst(0,-0.040+j*0.020,0);
    the_background_tissue.DefineCyst(.005, center_cyst);
  }

  //Save the rectangle-with-holes to disk
  sprintf(temp,"%d",(USUint) nr_circular_tissues+i);
  tissuename2=tissuename+temp;

  ofstream outFile(tissuename2, ios::out);
  outFile<<the_background_tissue;
  the_background_tissue.Tissue2Matlab(tissuename2);
  the_background_tissue.ClearScatterers();
}

//Merge all tissues
USTissue<USRectangle,USPointScatterer> total_tissue_model(uninitialized);
//Define the position and the size of the total tissue model
USPosition middle(0.08,0,0);
total_tissue_model.GetSpatialInformation()->Set(middle,middle+direction1,
middle+direction2);
((USRectangle*) total_tissue_model.GetSpatialInformation())->SetAxes(0.060,
0.075);

//In dit geval wil ik geen scatterers in het tissuemodel; met het detailfantoom
// is dat uiteraard anders.

//Define the scatterers in the total tissue model
 total_tissue_model.SetNumberOfScatterers(0);
 for (i=0;i<nr_circular_tissues;i++){
  //Read the circular model form disk
   sprintf(temp,"%d",(USUint) i);
   tissuename2=tissuename+temp;
   ifstream inFile(tissuename2, ios::in);
   inFile>>the_tissue_model;
   total_tissue_model.SetNumberOfScatterers(total_tissue_model.
   GetNumberOfScatterers()+the_tissue_model.GetNumberOfScatterers());
   USPointScatterer tmp_scatterer;
   for(j=0;j<the_tissue_model.getNumberOfScatterers();j++){
     for(k=0;k<nr_circular_tissues;k++){
       USPosition scattererposition;
       scattererposition=the_tissue_model.GetGlobalCoordinateScatterer(the_tisue_model.
       GetScatterer(scatterernummer));
       USPrecision ycoordinate=scattererposition.GetY()-.08;
       USPrecision xcoordinate=scattererposition.GetX()-.04+k*.02;
       scattererposition.SetX(xcoordinate);
       scattererposition.SetY(ycoordinate);
       total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
     }
   }
 }

for (i=0;i<nr_circular_tissues;i++){
  //Read the rectangle_with_holes from disk
   sprintf(temp,"%d",(USUint) nr_circular_tissues+i);
   tissuename2=tissuename+temp;
   ifstream inFile(tissuename2, ios::in);
   inFile>>the_tissue_model;
   total_tissue_model.SetNumberOfScatterers(total_tissue_model.
   GetNumberOfScatterers()+the_tissue_model.GetNumberOfScatterers());
   USPointScatterer tmp_scatterer;
   for(j=0;j<the_tissue_model.getNumberOfScatterers();j++){
     for(k=0;k<nr_circular_tissues;k++){
       USPosition scattererposition;
       scattererposition=the_tissue_model.GetGlobalCoordinateScatterer(the_tisue_model.
       GetScatterer(scatterernummer));
       USPrecision ycoordinate=scattererposition.GetY()-.08;
       USPrecision xcoordinate=scattererposition.GetX()-.04+k*.02;
       scattererposition.SetX(xcoordinate);
       scattererposition.SetY(ycoordinate);
       total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
     }
   }
 }



//Finally, save the total tissue model
ofstream outFile2("/images/vicar/tissue_models/total_tissue",ios::out);
outFile2<<total_tissue_model;
total_tissue_model.Tissue2Matlab(tissuename);
return 0;
}
