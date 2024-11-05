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
%groeispeckle
            silhouetuit=zeros(s(1),s(2));
				%beeld=double(beeld).*double(silhouetin);
				grijswaarde=beeld(witstepuntver,witstepunthor);
				silhouetuit(witstepuntver,witstepunthor)=1;
				aantalpixels=1;
				borand=[witstepuntver-1 witstepuntver+1];
				lrrand=[witstepunthor-1 witstepunthor+1];
				ietsveranderd=1;
				while ietsveranderd
   				venster=beeld(borand(1):borand(2),lrrand(1):lrrand(2));
   				hsilhouet=silhouetuit(borand(1)+1:borand(2)-1,lrrand(1):lrrand(2));
   				vsilhouet=silhouetuit(borand(1):borand(2),lrrand(1)+1:lrrand(2)-1);
   				hbeeld=beeld(borand(1)+1:borand(2)-1,lrrand(1):lrrand(2));
   				vbeeld=beeld(borand(1):borand(2),lrrand(1)+1:lrrand(2)-1);
   				hrand=zeros(2,size(venster,2));
   				vrand=zeros(size(venster,1),2);
   
   				natuurlijkegroei=(silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))|[hsilhouet;hrand]|[hrand;hsilhouet]|[vsilhouet vrand]|[vrand vsilhouet]);
   				tolerantierem=((grijswaarde-venster)<tolerantie);
   				monotoondalend=((venster-[hbeeld;hrand])<=0|(venster-[hrand;hbeeld])<=0|(venster-[vbeeld vrand])<=0|(venster-[vrand vbeeld])<=0);
   
   				silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))=silhouet(borand(1):borand(2),lrrand(1):lrrand(2)) & natuurlijkegroei & tolerantierem & monotoondalend;
   				nieuwaant=sum(sum(silhouetuit));
   				if nieuwaant>aantalpixels
      				aantalpixels=nieuwaant;
      				borand=[borand(1)-max(silhouetuit(borand(1),lrrand(1):lrrand(2))) borand(2)+max(silhouetuit(borand(2),lrrand(1):lrrand(2)))];
      				lrrand=[lrrand(1)-max(silhouetuit(lrrand(1),borand(1):borand(2))) lrrand(2)+max(silhouetuit(lrrand(2),borand(1):borand(2)))];
   				else
      				for i=size(venster,1):size(venster,1)*(size(venster,2)+1)-1
          				venster(i+1-size(venster,1))=i;
      				end
   				schema=reshape(silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2)).*venster,1,size(venster,1)*size(venster,2));
   				horcoord=floor(schema/(size(venster,1)))-1+borand(1)*(schema>0);
               vercoord=mod(schema,size(venster,1))+lrrand(1)*(schema>0); 
               ietsveranderd=0;
   				end
				end
			hsilhouet=silhouetuit(borand(1)+1:borand(2)-1,lrrand(1):lrrand(2));
			vsilhouet=silhouetuit(borand(1):borand(2),lrrand(1)+1:lrrand(2)-1);
			natuurlijkegroei=(silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))|[hsilhouet;hrand]|[hrand;hsilhouet]|[vsilhouet vrand]|[vrand vsilhouet]);
			silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))=silhouet(borand(1):borand(2),lrrand(1):lrrand(2)) & natuurlijkegroei;
         silhouetuit=silhouet & (1-silhouetuit);        
         [transducerhor,transducerver]=transducerpositie(beeld);
         teller=aantalpixels*sum(horcoord.*vercoord)-sum(horcoord)*sum(vercoord);
         noemer=aantalpixels*sum(horcoord.*horcoord)-sum(horcoord)*sum(horcoord);
         if noemer==0
            janee=0;
         else
            r=teller/noemer;
            centrumhor=sum(horcoord)/aantalpixels;
            centrumver=sum(vercoord)/aantalpixels;
            radiaal=[transducerhor-centrumhor;centrumver-transducerver];
            tangent=[1;-r];
            janee=(subspace(radiaal,tangent)<maxafwijking);
         end
         for i=1:size(horcoord,2)
            if horcoord(i)
               resultaat(vercoord(i),horcoord(i),1)=janee*255;
               resultaat(vercoord(i),horcoord(i),3)=255-255*janee;
            end
         end 
      end
    end
  end
end
resultaat=uint8(resultaat);
         
         