function a=gummer(orig,getek)
%blauwe pixels worden gecorrigeerd
s=size(orig);
a=getek;
for ver=1:s(1)
   for hor=1:S(2)
      if getek(ver,hor,3)>getek(ver,hor,2)
         a(s(1),s(2),:)=orig(s(1),s(2),:);
      end
   end
   ver
end
