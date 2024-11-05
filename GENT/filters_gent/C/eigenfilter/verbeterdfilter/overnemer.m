function result=overnemer(orig, slang)
%neemt de rode pixels over op het origineel (bv het resultaat of 
%begin van een slang)
s=size(orig);
result=zeros(s(1),s(2),3);
b=orig;
result(:,:,1)=b;
result(:,:,2)=b;
result(:,:,3)=b;
for ver=1:s(1)
   for hor=1:s(2)
      if slang(ver,hor,1)>slang(ver,hor,2)
         result(ver,hor,1)=slang(ver,hor,1);
         result(ver,hor,2)=slang(ver,hor,2);
         result(ver,hor,3)=slang(ver,hor,3);
      end
   end
end
result=uint8(result);
   