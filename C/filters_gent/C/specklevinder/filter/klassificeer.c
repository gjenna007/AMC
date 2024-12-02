#include <Imlib.h>
#include <stdio.h>
#include "definitions.h"
#include "structures.h"

int Klassificeer(const ImlibImage *compbeeld, const pixel witstepunt){

//int boven,onder,links,rechts;
int ver,hor,width,beslissing;
double sum,mean,var,snr,i,a;

beslissing=0;
sum=0;
i=0;
width=compbeeld->rgb_width;

for(ver=witstepunt.ver-7;ver<=witstepunt.ver+7;ver++){
  for(hor=witstepunt.hor-7;hor<=witstepunt.hor+7;hor++){
     sum+=compbeeld->rgb_data[(hor+ver*width)*3];
     i++;
  }
}
mean=sum/i;

sum=0;
for(ver=witstepunt.ver-7;ver<=witstepunt.ver+7;ver++){
  for(hor=witstepunt.hor-7;hor<=witstepunt.hor+7;hor++){
     a=compbeeld->rgb_data[(hor+ver*width)*3];
     sum+=(a-mean)*(a-mean);
  }
}
var=sum/(i-1);

if(mean==0) mean=0.0001;
snr=var/mean;
//printf("%f\n",snr);
//if(compbeeld->rgb_data[witstepunt.hor+width*witstepunt.ver]==255) beslissing=255;
//printf("%d",beslissing);
if (snr<=5.0) beslissing=255;
return(beslissing);
}

