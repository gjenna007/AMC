function a=lijndikker(b)
%maakt van rode pixels witte
a=b;
s=size(b);
for ver=1:s(1)
   for hor=1:s(2)
      if b(ver,hor,1)>b(ver,hor,2)
         a(ver,hor,1)=255;
         a(ver,hor,2)=255;
         a(ver,hor,3)=255;
      end
   end
end

   