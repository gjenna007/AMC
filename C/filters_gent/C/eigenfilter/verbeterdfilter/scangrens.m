function scangrens(A)
% bepaal grenzen echoscan

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
y_midden = round((polyval(p1,midden) +  polyval(p2,midden))/2);

% onderkant
x3 = 76:2*midden-76;
for i=1:(2*(midden-76)+1) 
   y3(i) = sqrt((474-y_midden)^2 - (midden-x3(i))^2) + y_midden;
end   

% bovenkant
x4 = [];
for i = 76:midden
   if polyval(p1,i)< 1
      x4 = [x4 i];
   end
end   
for i = midden+1:2*midden-76
   if polyval(p2,i)< 1
      x4 = [x4 i];
   end   
end   
r = 5;
while (abs(B(r,midden)-B(r-4,midden))) <= treshold 
   r = r+1; 
end
for i=1:x4(end)-x4(1)+1 
  	y4(i) = sqrt((r-y_midden)^2 - (midden-x4(i))^2) + y_midden;
   if y4(i) <= 1
      y4(i) = 1;
   end  
end   


% teken rand
hold on
h1 = plot(x1,l1);
h2 = plot(x2,l2);
h3 = plot(x3,y3);
h4 = plot(x4,y4);
h5 = plot([76 76],[l1(end) y3(1)]);
h6 = plot([2*midden-76 2*midden-76],[l2(end) y3(end)]);

k = [1 0 0]; l = 0.5;
set(h1,'color',k, 'linewidth',l)
set(h2,'color',k, 'linewidth',l)
set(h3,'color',k, 'linewidth',l)
set(h4,'color',k, 'linewidth',l)
set(h5,'color',k, 'linewidth',l)
set(h6,'color',k, 'linewidth',l)


