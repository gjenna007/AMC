#include <iostream.h>
#include <fstream.h>
#define D_USRectangle
#define D_USCilinder
#define D_USTissue
#define D_USSphericalScatterer
#define D_USGrid2D
#define D_USSphere
#define D_USTriangle
#include <mrprel.hxx>
#include <rw/math/mathvec.h>
#include <rw/tvordvec.h>
#include <stdlib.h>

int main(){
char temp[10];

// Define some variables
USUint nr_columns=6;
USString balk="/images/vicar/tissue_models/balk";
USString paal="/images/vicar/tissue_models/paal";
USString zuil="/images/vicar/tissue_models/zuil";
USString stalactiet="/images/vicar/tissue_models/stalactiet";
USString rechtsstalagmiet="/images/vicar/tissue_models/rechtsstalagmiet";
USString linksstalagmiet="/images/vicar/tissue_models/linksstalagmiet";
USString total_tissue="/images/vicar/tissue_models/total_tissue";
USString tissuename;

//Define elementary shapes
USPosition direction1(1,0,0);
USPosition direction2(0,1,0);
RWTRandUniform<RWRandGenerator> the_generator;
USTissue<USTriangle, USPointScatterer> stalactiet(uninitialized);
USTissue<USRectangle, USPointScatterer> balk (uninitialized);
USTissue<USRectangle, USPointScatterer> paal (uninitialized);
USTissue<USRectangle, USPointScatterer> zuil (uninitialized);
USTissue<USTriangle, USPointScatterer> rechtsstalagmiet (uninitialized);
USTissue<USTriangle, USPointScatterer> linksstalagmiet (uninitialized);

for (USUint i=0; i<nr_columns-1;i++){

  // Define the position and orientation of the stalactiet
  USPosition center(.080,0,0);
  stalactiet.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USTriangle*)stalactiet.GetSpatialInformation())->
  SetFirstCorner(USPosition (.075,0,0));
  ((USTriangle*)stalactiet.GetSpatialInformation())->
  SetSecondCorner(USPosition (-.075,-.005,0));
  ((USTriangle*)stalactiet.GetSpatialInformation())->
  SetThirdCorner(USPosition (-.075,.005,0));


  // Define the position and orientation of the balk
  balk.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USRectangle*)balk.GetSpatialInformation())->
  SetAxes(.0025,.06);

  // Define the position and orientation of the paal
  paal.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USRectangle*)paal.GetSpatialInformation())->
  SetAxes(.075,.0025);

  // Define the position and orientation of the zuil
  zuil.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USRectangle*)zuil.GetSpatialInformation())->
  SetAxes(.075,.005);

  // Define the position and orientation of the rechtsstalagmiet
  rechtsstalagmiet.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USTriangle*)rechtsstalagmiet.GetSpatialInformation())->
  SetFirstCorner(USPosition (.075,-.005,0));
  ((USTriangle*)rechtsstalagmiet.GetSpatialInformation())->
  SetSecondCorner(USPosition (.075,.005,0));
  ((USTriangle*)rechtsstalagmiet.GetSpatialInformation())->
  SetThirdCorner(USPosition (-.075,.005,0));

  // Define the position and orientation of the linksstalagmiet
  linksstalagmiet.GetSpatialInformation()->
  Set(center,center+direction1,center+direction2);
  ((USTriangle*)linksstalagmiet.GetSpatialInformation())->
  SetFirstCorner(USPosition (.075,-.005,0));
  ((USTriangle*)linksstalagmiet.GetSpatialInformation())->
  SetSecondCorner(USPosition (.075,.005,0));
  ((USTriangle*)linksstalagmiet.GetSpatialInformation())->
  SetThirdCorner(USPosition (-.075,-.005,0));


  //Distribute the scatterers
  balk.DistributeScatterersPseudoRandom(the_generator,
  (i+1+nr_columns)*0.0001,2,1,(i+1)*0.0001,2,1);
  //Distribute the scatterers
  paal.DistributeScatterersPseudoRandom(the_generator,
  (i+1+nr_columns)*0.0001,2,1,(i+1)*0.0001,2,1);
  //Distribute the scatterers
  zuil.DistributeScatterersPseudoRandom(the_generator,
  (i+1+nr_columns)*0.0001,2,1,(i+1)*0.0001,2,1);
  //Distribute the scatterers
  stalactiet.DistributeScatterersPseudoRandom(the_generator,
  (i+1+nr_columns)*0.0001,2,1,(i+1)*0.0001,2,1);
  //Distribute the scatterers
  rechtsstalagmiet.DistributeScatterersPseudoRandom(the_generator,
  (i+1+nr_columns)*0.0001,2,1,(i+1)*0.0001,2,1);
  //Distribute the scatterers
  linksstalagmiet.DistributeScatterersPseudoRandom(the_generator,
  (i+1+nr_columns)*0.0001,2,1,(i+1)*0.0001,2,1);

  //Save components to disk
  sprintf(temp,"%d",(USUint) i+nr_columns);// Maakt een character van de variabele i
  tissuename=balk+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<balk_model;
  balk_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  balk.ClearScatterers();

  sprintf(temp,"%d",(USUint) i+nr_columns);// Maakt een character van de variabele i
  tissuename=paal+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<paal_model;
  paal_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  paal.ClearScatterers();

  sprintf(temp,"%d",(USUint) i+nr_columns);// Maakt een character van de variabele i
  tissuename=zuil+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<zuil_model;
  zuil_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  zuil.ClearScatterers();

  sprintf(temp,"%d",(USUint) i+nr_columns);// Maakt een character van de variabele i
  tissuename=stalactiet+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<stalactiet_model;
  stalactiet_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  stalactiet.ClearScatterers();

  sprintf(temp,"%d",(USUint) i+nr_columns);// Maakt een character van de variabele i
  tissuename=rechtsstalagmiet+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<rechtsstalagmiet_model;
  rechtsstalagmiet_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  rechtsstalagmiet.ClearScatterers();

  sprintf(temp,"%d",(USUint) i+nr_columns);// Maakt een character van de variabele i
  tissuename=linksstalagmiet+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<linksstalagmiet_model;
  linksstalagmiet_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  linksstalagmiet.ClearScatterers();
}

//Save empty components to disk
  sprintf(temp,"%d",(USUint) 2*nr_columns-1);// Maakt een character van de variabele i
  tissuename=balk+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<balk_model;
  balk_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  balk.ClearScatterers();

  sprintf(temp,"%d",(USUint) 2*nr_columns-1);// Maakt een character van de variabele i
  tissuename=paal+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<paal_model;
  paal_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  paal.ClearScatterers();

  sprintf(temp,"%d",(USUint) 2*nr_columns-1);// Maakt een character van de variabele i
  tissuename=zuil+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<zuil_model;
  zuil_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  zuil.ClearScatterers();

  sprintf(temp,"%d",(USUint) 2*nr_columns-1);// Maakt een character van de variabele i
  tissuename=stalactiet+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<stalactiet_model;
  stalactiet_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  stalactiet.ClearScatterers();

  sprintf(temp,"%d",(USUint) 2*nr_columns-1);// Maakt een character van de variabele i
  tissuename=rechtsstalagmiet+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<rechtsstalagmiet_model;
  rechtsstalagmiet_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  rechtsstalagmiet.ClearScatterers();

  sprintf(temp,"%d",(USUint) 2*nr_columns-1);// Maakt een character van de variabele i
  tissuename=linksstalagmiet+temp;

  ofstream outFile(tissuename, ios::out);
  outFile<<linksstalagmiet_model;
  linksstalagmiet_model.Tissue2Matlab(tissuename);//Alleen nodig als je het in Matlab wil kunnen bekijken
  linksstalagmiet.ClearScatterers();

//Zet alle componenten op hun plaats
USTissue<USRectangle,USPointScatterer> total_tissue_model(uninitialized);
//Define the position and the size of the total tissue model
USPosition middle(0.10,0,0);
total_tissue_model.GetSpatialInformation()->Set(middle,middle+direction1,
middle+direction2);
((USRectangle*) total_tissue_model.GetSpatialInformation())->SetAxes(0.060,
0.08);

//Define the scatterers in the total tissue model
total_tissue_model.SetNumberOfScatterers(0);
for(USUintversie=0;versie<nr_columns;versie++){
  for(USUint column=0;column<nr_columns-1;column++){
    //Read the stalactiet from disk
    sprintf(temp,"%d",(USUint) column+nr_columns);
    tissuename=stalactiet+temp;
    ifstream inFile(tissuename, ios::in);
    inFile>>stalactiet_model;

    total_tissue_model.SetNumberOfScatterers(total_tissue_model.
    GetNumberOfScatterers()+stalactiet_model.GetNumberOfScatterers());
    USPointScatterer tmp_scatterer;
    for(USUint scatterernummer=0;scatterernummer<stalactiet_model.getNumberOfScatterers();
                                                                        scatterernummer++){
      USPosition scattererposition;
      scattererposition=stalactiet_model.GetGlobalCoordinateScatterer(stalactiet_model.
      GetScatterer(scatterernummer));
		  USPrecision ycoordinate=scattererposition.GetY()-.08;
		  USPrecision xcoordinate=scattererposition.GetX()-.055+column*.02;
		  scattererposition.SetX(xcoordinate);
		  scattererposition.SetY(ycoordinate);
	    total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
    }
  }

 //Read the zuil from disk
    sprintf(temp,"%d",(USUint) versie+nr_columns);
    tissuename=zuil+temp;
    ifstream inFile(tissuename, ios::in);
    inFile>>zuil_model;

    for(j=0;j<nr_columns-2;j++){
      total_tissue_model.SetNumberOfScatterers(total_tissue_model.
      GetNumberOfScatterers()+zuil_model.GetNumberOfScatterers());
      USPointScatterer tmp_scatterer;
      for(USUint scatterernummer=0;scatterernummer<zuilmodel.getNumberOfScatterers();
                                                                   scatterernummer++){
         USPosition scattererposition;
         scattererposition=zuil.GetGlobalCoordinateScatterer(zuil_model.
         GetScatterer(scatterernummer));
		     USPrecision ycoordinate=scattererposition.GetY()-.08;
		     USPrecision xcoordinate=scattererposition.GetX()-.05+j*.02;
		     scattererposition.SetX(xcoordinate);
		     scattererposition.SetY(ycoordinate);
	       total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
       }
     }

    //Read the rechtsstalagmiet from disk
    sprintf(temp,"%d",(USUint) versie+nr_columns);
    tissuename=rechtsstalagmiet+temp;
    ifstream inFile(tissuename, ios::in);
    inFile>>rechtsstalagmiet_model;

    for(j=0;j<nr_columns;j++){
      total_tissue_model.SetNumberOfScatterers(total_tissue_model.
      GetNumberOfScatterers()+rechtsstalagmiet_model.GetNumberOfScatterers());
      USPointScatterer tmp_scatterer;
      for(USUint scatterernummer=0;scatterernummer<rechtsstalagmiet_model.getNumberOfScatterers();
                                                                               scatterernummer++){
        USPosition scattererposition;
        scattererposition=rechtsstalagmiet_model.GetGlobalCoordinateScatterer(rechtsstalagmiet_model.
        GetScatterer(scatterernummer));
		    USPrecision ycoordinate=scattererposition.GetY()-.08;
		    USPrecision xcoordinate=scattererposition.GetX()-.0375+j*.02;
		    scattererposition.SetX(xcoordinate);
		    scattererposition.SetY(ycoordinate);
	      total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
      }
    }

     //Read the linksstalagmiet from disk
    sprintf(temp,"%d",(USUint) versie+nr_columns);
    tissuename=linksstalagmiet+temp;
    ifstream inFile(tissuename, ios::in);
    inFile>>linksstalagmiet_model;

    for(j=0;j<nr_columns;j++){
      total_tissue_model.SetNumberOfScatterers(total_tissue_model.
      GetNumberOfScatterers()+linksstalagmiet_model.GetNumberOfScatterers());
      USPointScatterer tmp_scatterer;
      for(USUint scatterernummer=0;scatterernummer<linksstalagmiet_model.getNumberOfScatterers();
                                                                              scatterernummer++){
        USPosition scattererposition;
        scattererposition=linksstalagmiet_model.GetGlobalCoordinateScatterer(linksstalagmiet_model.
        GetScatterer(scatterernummer));
		    USPrecision ycoordinate=scattererposition.GetY()-.08;
		    USPrecision xcoordinate=scattererposition.GetX()-.0425+j*.02;
		    scattererposition.SetX(xcoordinate);
		    scattererposition.SetY(ycoordinate);
	      total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
      }
    }

    //Read the paal from disk
    sprintf(temp,"%d",(USUint) versie+nr_columns);
    tissuename=paal+temp;
    ifstream inFile(tissuename, ios::in);
    inFile>>paal_model;
		    USPrecision ycoordinate=scattererposition.GetY()-.08;

    for(j=0;j<=1;j++){
      total_tissue_model.SetNumberOfScatterers(total_tissue_model.
      GetNumberOfScatterers()+paal_model.GetNumberOfScatterers());
      USPointScatterer tmp_scatterer;
      for(USUint scatterernummer=0;scatterernummer<paal_model.getNumberOfScatterers();
                                                                         scatterernummer++){
        USPosition scattererposition;
        scattererposition=paal_model.GetGlobalCoordinateScatterer(paal_model.
        GetScatterer(scatterernummer));
		    USPrecision ycoordinate=scattererposition.GetY()-.08;
		    USPrecision xcoordinate=scattererposition.GetX()-.0575+j*11.5;
		    scattererposition.SetX(xcoordinate);
		    scattererposition.SetY(ycoordinate);
	      total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
      }
    }

    //Read the balk from disk
    sprintf(temp,"%d",(USUint) versie+nr_columns);
    tissuename=balk+temp;
    ifstream inFile(tissuename, ios::in);
    inFile>>balk_model;

    for(j=0;j<=1;j++){
      total_tissue_model.SetNumberOfScatterers(total_tissue_model.
      GetNumberOfScatterers()+balk_model.GetNumberOfScatterers());
      USPointScatterer tmp_scatterer;
      for(USUint scatterernummer=0;scatterernummer<balk_model.getNumberOfScatterers();
                                                                   scatterernummer++){
        USPosition scattererposition;
        scattererposition=balk_model.GetGlobalCoordinateScatterer(balk_model.
        GetScatterer(scatterernummer));
		    USPrecision ycoordinate=scattererposition.GetY()-.08-.0725+j*15.5;
		    USPrecision xcoordinate=scattererposition.GetX();
		    scattererposition.SetX(xcoordinate);
		    scattererposition.SetY(ycoordinate);
	      total_tissue_model.SetScatterer(tmp_scatterer, scattererposition);
      }
    }

  //Finally, save the total tissue model
  sprintf(temp,"%d",(USUint) versie+nr_columns);
  tissuename=total_tissue+temp;
  ofstream outFile2(tissuename,ios::out);
  outFile2<<total_tissue_model;
  total_tissue_model.Tissue2Matlab(tissuename);
}
return 0;
}                                            				