beeld=imread('deruddere03.tif');
silhouet=imread('silhouetderuddere03.tif');
%Deze functie heeft een echografiebeeld en het bijbehorende silhouet als invoer. De output is een beeld waarin 
%alleen de speckles gekleurd zijn.
%De gebruikte functieaanroepen zijn:
%groeispeckle
%richtingscoefficient
%transducerpositie
%loodrecht
%specklekleuren
%De instelbare parameters zijn:
tolerantie=3;%Dit controleert de groei van de speckletjes adhv de grijswaarden.
maxafwijking=20;%Dit controleert de striktheid van wat onder "loodrecht" verstaan wordt.(Wordt in graden verwacht).
specklegrens=80;%Dit is de minimale grijswaarde waarboven een pixel als potentieel speckle aangemerkt wordt.
TOPVOLGORDE=[0 3 6;1 4 7;2 5 8];
s=size(beeld);
resultaat=zeros(s(1),s(2));
silhouet=double(silhouet)/255;
silhouet(1:80,:)=0;
silhouet(s(1)-79:s(1),:)=0;
for ver=120:121
   for hor=1:s(2)
      if silhouet(ver,hor)~=0
%zoektop
         witstepuntver=ver;
		   witstepunthor=hor;
         beeld=double(beeld).*double(silhouet);
         doorzoeken=1; 
         while doorzoeken
            doorzoeken=0;
				omhoog=max(max(beeld(witstepuntver-1:witstepuntver+1,witstepunthor-1:witstepunthor+1)));
   			if omhoog>beeld(witstepuntver,witstepunthor)
      			volgorde=max(max((beeld(witstepuntver-1:witstepuntver+1,witstepunthor-1:witstepunthor+1)>=omhoog).*TOPVOLGORDE));
   				witstepuntver=witstepuntver+mod(volgorde,3)-1;
      			witstepunthor=witstepunthor+floor(volgorde/3)-1;
      			doorzoeken=1;
   			end
			end
         
         if beeld(witstepuntver,witstepunthor)>specklegrens
        		temp=groeispeckle(beeld,silhouet,witstepuntver,witstepunthor,tolerantie);
        		horcoord=temp(1,:,2);
         	vercoord=temp(2,:,2);
         	n=rank(diag(horcoord));
            silhouet=temp(:,:,1);
            ver, hor
         	horcoord=horcoord(1:n);
            vercoord=vercoord(1:n);
            [transducerx,transducery]=transducerpositie(beeld);
            r=richtingscoeff(horcoord,vercoord);
            if r==pi
               janee=0;
            else janee=loodrecht(horcoord,vercoord,r,maxafwijking,transducerx,transducery);
            end
            resultaat=specklekleuren(resultaat,horcoord,vercoord,janee);
         end
   	end
   end
end
resultaat=uint8(resultaat);
         
         