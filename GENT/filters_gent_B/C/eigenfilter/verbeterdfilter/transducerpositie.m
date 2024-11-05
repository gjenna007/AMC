function [transducerx, transducery] = transducerpositie(A)
% Geeft de coordinaten van de transducer die het beeld opgenomen heeft
% schuine zijkanten en middelpunt sectie
B = double(A)+1;
treshold = 6;
midden = 364;
c1 = 270; c2 = 460;
x1 = []; x2 = []; y = []; 
for r = 21:180
   c1 = c1 - 20;
   c2 = c2 + 20;
   while (abs(B(r,c1)-B(r,c1-4))) <= treshold 
       c1 = c1+1; 
   end
   while (abs(B(r,c2)-B(r,c2+4))) <= treshold 
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
transducery = round((polyval(p1,midden) +  polyval(p2,midden))/2);
transducerx = midden;