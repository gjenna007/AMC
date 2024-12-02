function silhouetuit=groeispeckle(beeld,silhouetin,witstepuntver,witstepunthor,tolerantie)
%vanuit het witste punt wordt een gebiedje gegroeid met grijswaarde binnen de tolerantie
%(Mocht dat niet voldoen, dan kunnen we in de toekomst de mogelijkheid nog onderzoeken
%dat de grijswaarde van de pixels alleen maar monotoon mag dalen).
%De gevonden pixels slaan we niet grafisch op, maar de xcoordinaten en ycoordinaten
%slaan we op in aparte vectoren. Dit omdat dat handiger is om de raaklijn te bepalen
%met behulp van de kleinste kwadraten methode. Als we het speckletje eventueel zouden 
%willen visualiseren, kunnen we daar gemakkelijk een functie voor schrijven.
silhouetuit=silhouetin<-1;
%beeld=double(beeld).*double(silhouetin);
grijswaarde=beeld(witstepuntver,witstepunthor);
silhouetuit(witstepuntver,witstepunthor)=1;
aantalpixels=1;
borand=[witstepuntver-1 witstepuntver+1];
lrrand=[witstepunthor-1 witstepunthor+1];
ietsveranderd=1;
while ietsveranderd
   ietsveranderd=0;
   venster=beeld(borand(1):borand(2),lrrand(1):lrrand(2));
   hsilhouet=silhouetuit(borand(1)+1:borand(2)-1,lrrand(1):lrrand(2));
   vsilhouet=silhouetuit(borand(1):borand(2),lrrand(1)+1:lrrand(2)-1);
   hbeeld=beeld(borand(1)+1:borand(2)-1,lrrand(1):lrrand(2));
   vbeeld=beeld(borand(1):borand(2),lrrand(1)+1:lrrand(2)-1);
   hrand=zeros(2,size(lrrand)(2));
   vrand=zeros(size(borand)(2),2);
   
   natuurlijkegroei=(silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))|[hsilhouet;hrand]|[hrand;hsilhouet]|[vsilhouet vrand]|[vrand vsilhouet]);
   tolerantierem(grijswaarde*ones(size(borand)(2),size(lrrand)(2))-venster)<tolerantie;
   monotoondalend=((venster-[hbeeld;hrand])<=0|(venster-[hrand;hbeeld])<=0|(venster-[vbeeld vrand])<=0|(venster-[vrand vbeeld])<=0);
   
   silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))=silhouetin(borand(1):borand(2),lrrand(1):lrrand(2)) & natuurlijkegroei & tolerantierem & monotoondalend;
   nieuwaant=sum(sum(silhouetuit));
   if nieuwaant>aantalpixels
      aantalpixels=nieuwaant;
      borand=[borand(1)-max(silhouetuit(borand(1),lrrand(1):lrrand(2))) borand(2)+max(silhouetuit(borand(2),lrrand(1):lrrand(2)))];
      lrrand=[lrrand(1)-max(silhouetuit(lrrand(1),borand(1):borand(2))) lrrand(2)+max(silhouetuit(lrrand(2),borand(1):borand(2)))];
      ietsveranderd=1;
   else
      for i=size(venster)(1):size(venster)(1)*(size(venster)(2)+1)-1
          venster(i+1-size(venster)(1))=i;
      end
   schema=reshape(silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2)).*venster,1,size(venster)(1)*size(venster)(2));
   horcoord=floor(schema/(size(venster)(1)))-1+borand(1)*(schema>0);
   vercoord=mod(schema,size(venster)(1))+lrrand(1)*(schema>0);      
   end
end
hsilhouet=silhouetuit(borand(1)+1:borand(2)-1,lrrand(1):lrrand(2));
vsilhouet=silhouetuit(borand(1):borand(2),lrrand(1)+1:lrrand(2)-1);
natuurlijkegroei=(silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))|[hsilhouet;hrand]|[hrand;hsilhouet]|[vsilhouet vrand]|[vrand vsilhouet]);
silhouetuit(borand(1):borand(2),lrrand(1):lrrand(2))=silhouetin(borand(1):borand(2),lrrand(1):lrrand(2)) & natuurlijkegroei;
silhouetuit=silhouetin & (1-silhouetuit);    

   
   

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
                     
                     
