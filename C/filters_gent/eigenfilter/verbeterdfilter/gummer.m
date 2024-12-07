function result=gummer(orig, slang)
%neemt de rode pixels over op het origineel (bv het resultaat of 
%begin van een slang)
s=size(orig);
result=slang;
for ver=1:s(1)
   for hor=1:s(2)
      if slang(ver,hor,3)>slang(ver,hor,1)
         result(ver,hor,1)=orig(ver,hor);
      end
   end
end
result=result(:,:,1);
result=uint8(result);
   