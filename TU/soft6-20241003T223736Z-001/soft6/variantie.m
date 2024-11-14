function matchblok=variantie(inputbeeld,VENSTERSIZE)
%We hebben ontdekt dat de variantie berekenen een stuk gemakkelijker kan:
%in een blok met n punten is de variantie: \Sum ( x_i -\mu )^2=
% (\sum x_i^2) - ((\sum x_i)^2)/n
%global VENSTERSIZE
%tic
a=double(inputbeeld);
b=a.*a;
c=filter2(ones(VENSTERSIZE),b,'same');%som van de kwadraten
d=filter2(ones(VENSTERSIZE),a,'same');%kwadraat van de som
e=d.*d/(VENSTERSIZE*VENSTERSIZE);
f=c-e;
%toc
%je moet in ieder geval zorgen dat het venster geheel binnen het beeld valt
mask=a==0;
mask(1,:)=1;mask(:,1)=1;mask(size(mask,1),:)=1;mask(:,size(mask,2))=1;
se=strel('square',2*VENSTERSIZE+1);
mask2=imdilate(mask,se);
f=f.*(1-double(mask2));
[i,j]=find(f==max(f(:)),1,'first');
matchblok=inputbeeld(i-floor(VENSTERSIZE/2):i+floor(VENSTERSIZE/2),j-floor(VENSTERSIZE/2):j+floor(VENSTERSIZE/2));
