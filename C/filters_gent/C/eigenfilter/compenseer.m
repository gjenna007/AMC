function C = compenseer(A,depth,gain,M)
% Compensatie voor scanner settings
% A is het te compenseren beeld, C is het gecompenseerde beeld,
% M is een masker. Alle gebieden die niet bedekt worden door het 
% masker, worden gecompenseerd.


% geen masker -> alle pixels


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      EXTRACTIE                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TGC extractie

TGClinks = 649 + 10;
TGConder = 473;
TGCrechts = TGClinks + 69 - 10;
treshold = 100;

% zoek bovenkant TGC-kurve
TGCboven = 1;
while A(TGCboven,TGClinks:TGCrechts)<= treshold 
   TGCboven = TGCboven+1; 
end

% hoogte van de 8 hokjes
hoogte = round((TGConder - TGCboven)/8);

% extraheer TGC-waarde aan de bovenkant van elk hokje
TGCpunten = [];
for hokje = 1:8
   wittepixels = [];
   for pos = TGClinks:TGCrechts
      if A(TGCboven+(hokje-1)*hoogte,pos)>treshold
         wittepixels = [wittepixels pos];
      end
   end 
   TGCpunten = [TGCpunten mean(wittepixels')];
end
TGCpunten = [TGCpunten mean(wittepixels')];

% bepaal TGC-waarden in bereik [0-48]
TGCpunten = round(-1.16 + 0.842 * (TGCpunten-TGClinks));

% afleiding volledige TGC-kurve
for hokje = 1:8
   top = (hokje-1) * hoogte;
   for i = 1:hoogte 
      TGC(top+i+20)= TGCpunten(hokje)+(TGCpunten(hokje+1)-TGCpunten(hokje))/hoogte*i; 
   end
end
% Uitbreiding TGC-kurve, zodat geen fouten optreden wanneer een
% volledige figuur wordt gecompenseerd (punten buiten het echo-scan-
% gebied) hebben geen overeenkomnstige TGC-waarde
TGC(1:20) = TGCpunten(1);
TGC(end:700) = TGCpunten(9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extractie Grijswaardenbalk

hoogte = 24;
for i = 1:16
   boven = -6+(i-1)*24;
   onder = -6+i*24;
   grijsschaal(i) = round(mean(mean(A(boven+7:onder-3,62:66))'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Depth en Gain

% zijn momenteel funktie-inputs
% nog te vervangen door GUI voor parameterextractie

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extraheer Basispunt Scansector

A = double(A);
treshold = 6;
midden = 364;
c1 = 270; c2 = 460;
x1 = []; x2 = []; y = []; 
for r = 21:180
   c1 = c1 - 20;
   c2 = c2 + 20;
   while (abs(A(r,c1)-A(r,c1-4))) <= treshold 
       c1 = c1+1; 
   end
   while (abs(A(r,c2)-A(r,c2+4))) <= treshold 
       c2 = c2-1; 
   end  
   if abs((midden - c1)-(c2-midden)) <= 2
      x1 = [x1 c1]; x2 = [x2 c2]; y = [y r];
   end   
end
p1 = polyfit(x1,y,1);
x1 = [midden:-1:76];
l1 = polyval(p1,x1);
p2 = polyfit(x2,y,1);
x2 = [midden:2*midden-76];
l2 = polyval(p2,x2);
y_midden = round((polyval(p1,midden) +  polyval(p2,midden))/2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      COMPENSATIE                         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Correctiefunktie voor niet-lineaire grijsschaal: f1(pixelwaarde+1) 
% 8-bit niet-lineaire grijsschaal -> 6 bit lineaire grijsschaal

for i=1:15
   x3(i) = grijsschaal(i+1);
   y3(i) = 64/15*i-1;
end   
coeff = polyfit(x3,y3,3);
x = 0:255;
for i = 1:256
   f1(i) = round(polyval(coeff,x(i)));
   if f1(i) < 0, f1(i) = 0;
   elseif f1(i) > 63, f1(i) = 63;
   end		
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Correctiematrix voor gain en TGC, afhankelijk van de depth d

% factor 1,5: toegevoegd 16/04/99
% geeft betere resultaten op reele echobeelden correcte waarde 
% coeff's dient nog bepaald te worden, liefst adhv fantoom-metingen
a1 = 1.5* 0.019789450;
a2 = 1.5* 0.023241990;
a3 = 1.5* 0.000715756;
s = size(A);
for i = 1:s(2)
   row(i) = (i - midden)^2;
end
for i = 1:s(1)
   col(i) = (i - y_midden)^2;   
end
corr = round(sqrt((ones(s(1),1)*row)+(col'*ones(1,s(2))))-(TGCboven-y_midden));
corr = TGC(round(corr*depth/192)+20);
% origineel: corr = log10(exp(a1*gain)*exp(a2+a3*gain)*corr)*26.8;
corr = 26.8/log(10) * (a1*gain + (a2+a3*gain)*corr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eigenlijke Compensatie 

B = f1(A+1);
mask = (B==0);
C = B - corr + 1.5 * 78;
% herschaling
C(mask) = B(mask)* 2.9;
C = uint8(round(C));

% nog te programmeren: enkel verwerking binnen masker!!

% teken origineel en gecompenseerd echobeeld 
figure
subplot(1,2,1), imshow(uint8(A))
subplot(1,2,2), imshow(C)
