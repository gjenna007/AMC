resulting=zeros(1670,1+66*2);
resulting(:,1)=(1:1670)';
for nummer=1:66
    nummer
    name=['BBobjects000' num2str(nummer+22)];
    load (name)
    l=size(objecttabel,1);
    for entry=1:l
        resulting(objecttabel(entry,2),nummer*2)=objecttabel(entry,4);
        resulting(objecttabel(entry,2),nummer*2+1)=objecttabel(entry,3);
    end
end
