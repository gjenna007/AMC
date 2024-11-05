#include "mex.h" 
#include <math.h>
void mexFunction (int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[]){

int sref[3];
int i,depth,ver,hor;
double *ref, *top;
double *rot;
double *histogram;
double sum;
// int teller;
histogram=(double*)mxMalloc(256*256*sizeof(double));
for(i=0;i<256*256;i++){histogram[i]=1;}
for (i=0;i<3;i++){sref[i]=(mxGetDimensions(prhs[0]))[i];}
// teller=0;
ref=mxGetPr(prhs[0]);
top=mxGetPr(prhs[1]);
rot=mxGetPr(prhs[2]);
// mexPrintf("%d%c%d%c%d\n",sref[0],' ',sref[1],' ',sref[2]);
for(depth=0;depth<sref[2];depth++){
for(ver=0;ver<sref[0];ver++){
for(hor=0;hor<sref[1];hor++){ 
  if(rot[depth*sref[1]*sref[0]+hor*sref[0]+ver]>0&&
  rot[sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]>0&&
  rot[2*sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]>0&&
  rot[depth*sref[1]*sref[0]+hor*sref[0]+ver]<=sref[0]&&
  rot[sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]<=sref[1]&&
  rot[2*sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]<=sref[2]){
double tt,rr; 
tt=top[depth*sref[1]*sref[0]+hor*sref[0]+ver]; 
 /* if(tt>0){ */
/*    teller++; */
/*    mexPrintf("%d%c%d%c%d%c%f\n",ver,' ',hor,' ',depth,' ',tt);} */
/*  if (teller==100){while(1);} */
rr=ref[(int)(ceil(rot[2*sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]-1)*sref[1]*sref[0]+
ceil(rot[sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]-1)*sref[0]+
ceil(rot[depth*sref[1]*sref[0]+hor*sref[0]+ver]-1))];
// if(1){
//   double f;
//   f=ceil(rot[2*sref[2]*sref[1]*sref[0]+depth*sref[1]*sref[0]+hor*sref[0]+ver]);
//mexPrintf("%d%c%d%c%d%c%f\n",ver,' ',hor,' ',depth,' ',rr);//}
//if (teller==2500){while(1);}
histogram[(int)(rr*256+tt)]++;
}}}}
sum=0;
for(i=0;i<256*256;i++){sum+=histogram[i];}
for(i=0;i<256*256;i++){histogram[i]=histogram[i]/sum;}
plhs[0]=mxCreateDoubleMatrix(256,256,mxREAL);
mxSetPr(plhs[0],histogram);
//mxFree(histogram);
}
