function silhouetuit=groeispeckle(beeld,silhouetin,witstepuntver,witstepunthor,tolerantie)
%vanuit het witste punt wordt een gebiedje gegroeid met grijswaarde binnen de tolerantie
%(Mocht dat niet voldoen, dan kunnen we in de toekomst de mogelijkheid nog onderzoeken
%dat de grijswaarde van de pixels alleen maar monotoon mag dalen).
%De gevonden pixels slaan we niet grafisch op, maar de xcoordinaten en ycoordinaten
%slaan we op in aparte vectoren. Dit omdat dat handiger is om de raaklijn te bepalen
%met behulp van de kleinste kwadraten methode. Als we het speckletje eventueel zouden 
%willen visualiseren, kunnen we daar gemakkelijk een functie voor schrijven.
silhouetuit=silhouetin;
beeld=double(beeld).*double(silhouetin);
grijswaarde=beeld(witstepuntver,witstepunthor);
silhouetuit(witstepuntver,witstepunthor)=2;
borand=witstepuntver;
lrrand=witstepunthor;
vercoord=[];
horcoord=[];
ietsveranderd=1;
while ietsveranderd
   ietsveranderd=0;
   for windowver=min(borand):max(borand)
      for windowhor=min(lrrand):max(lrrand)
         if silhouetuit(windowver,windowhor)==2
            niveau=beeld(windowver,windowhor);
            beeld(windowver,windowhor)=0;
            %silhouetuit(windowver,windowhor)=0;
            vercoord =[vercoord windowver];
            horcoord =[horcoord windowhor];
            for ver=-1:1
               for hor=-1:1
                  if grijswaarde-beeld(windowver+ver,windowhor+hor)<tolerantie
                     if beeld(windowver+ver,windowhor+hor)<=niveau
                     	n=size(horcoord);
                     	if n<200
                     	ietsveranderd=1;
                     	silhouetuit(windowver+ver,windowhor+hor)=2;
                        beeld(windowver+ver,windowhor+hor)=0;
                        silhouetuit(windowver,windowhor)=0;
                     	borand =[borand windowver+ver];
                     	lrrand =[lrrand windowhor+hor]; 
                     	end
                  	end
                  end
               end
            end
         end
      end
   end
end
s=size(silhouetuit);
adjuster=double(ones(s(1),s(2)));
for randjehor=min(lrrand)-1:max(lrrand)+1
   for randjever=min(borand):max(borand)
      if silhouetuit(randjever,randjehor)==2
         adjuster(randjehor-1:randjehor+1,randjever)=0;
      end
   end
end
for randjever=min(borand)-1:max(borand)+1
   for randjehor=min(lrrand):max(lrrand)
      if silhouetuit(randjever,randjehor)==2
         adjuster(randjehor,randjever-1:randjever+1)=0;
      end
   end
end
silhouetuit=silhouetuit.*adjuster;
n=size(horcoord);
silhouetuit(1,1:n(2),2)=horcoord;
silhouetuit(2,1:n(2),2)=vercoord;



                     
                     
