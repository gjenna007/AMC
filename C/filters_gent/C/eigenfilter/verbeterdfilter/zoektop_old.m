function [witstepuntver, witstepunthor]=zoektop(beeld,silhouet,beginver,beginhor)
%begint te lopen op het punt (beginver,beginhor) en stap dan naar een witter punt
%in de omgeving en zo verder tot het niet meer omringd wordt door
%wittere punten; zo wordt een lokale top gevonden
%Hou goed in het achterhoofd dat in silhouet alle pixels die bij de groeiprocedure (in
%de functie 'groeispeckle' betrokken worden, ook anders dan wit gekleurd worden!! Deze
%'silhouet' is dus meer dan louter het masker om het echografiebeeld mee uit te snijden.
global TOPVOLGORDE
beeld=double(beeld).*double(silhouet);
omhoog=max(max(beeld(beginver-1:beginver+1,beginhor-1:beginhor+1)));
doorzoeken=1;
while doorzoeken
   doorzoeken=0;
   if omhoog>beeld(beginver,beginhor)
      volgorde=min(min((beeld(beginver-1:beginver+1,beginhor-1;beginhor+1)>=omhoog).*TOPVOLGORDE))-1
   	beginver=beginver+mod(volgorde,3)-1;
      beginhor=beginhor+floor(volgorde/3)-1;
      doorzoeken=1;
   end
end

   
   
   



doorzoeken=1;
while doorzoeken
   scanhor=-1;
   scanver=-1;
   eindnognietbereikt=1;
   while eindnognietbereikt
      ver=beginver+scanver;
      hor=beginhor+scanhor;
      if beeld(ver,hor)>beeld(beginver,beginhor)
            beginver=ver;
            beginhor=hor;
            eindnognietbereikt=0;
      end
      scanhor=scanhor+1;
      if scanhor>1
         scanhor=-1;
         scanver=scanver+1;
         if scanver>1
            eindnognietbereikt=0;
            doorzoeken=0;
         end
      end
   end
end
witstepuntver=beginver;
witstepunthor=beginhor;


      
