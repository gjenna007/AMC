function transl=SSE(inputbeeld,matchblok,VENSTERSIZE)
%matchblok is de matrix waarvan de beste match gevonden moet worden
%transl kunnen we ook op een nieuwe manier berekenen
%\Sum (x_i-y_i)^2=\sum x_i^2 - 2\sum x_i y_i + \sum y_i^2.
%Omdat je alleen het minimum zoekt, kun je die laatste (constante) term
%weglaten; als je een grafiek wil maken is die constante term misschien
%weer werl interessant.
%global VENSTERSIZE
transl=zeros(1,3);
a=double(inputbeeld);
b=a.*a;
c=filter2(ones(VENSTERSIZE),b,'same');
d=filter2(double(matchblok),a,'same');
e=c-2*d;
e(1:VENSTERSIZE-1,:)=max(e(:));
e(size(a,1)-VENSTERSIZE+2:size(a,1),:)=max(e(:));
e(:,1:VENSTERSIZE-1)=max(e(:));
e(:,size(a,2)-VENSTERSIZE+2:size(a,2))=max(e(:));
[i,j]=find(e==min(e(:)),1,'first');
transl(1)=min(e(:))+sum(sum(double(matchblok).*double(matchblok)));transl(2)=i;transl(3)=j;