function result=minner(orig,kleur)


s=size(orig);
result=zeros(s(1),s(2));
for v=1:s(1)
   for h=1:s(2)
      if kleur(v,h,1)==kleur(v,h,2)
         if kleur(v,h,1)==kleur(v,h,3)
            result(v,h)=orig(v,h);
         end
      end
   end
end

         