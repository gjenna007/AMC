function out=cutaround(in,cver,chor,VER,HOR)
%ik heb deze functie nog helemaal niet geschreven
r1=ceil(size(result,1)/2);r2=ceil(size(result,2)/2);
if r1-cver+1<1
    in=cat(1,zeros(-r1+cver,size(in,2)),in);
    top=1;
    cver=cver+(cver-r1);
else top=r1-cver+1;
end
if r1-cver+VER>size(result,1)
    in=cat(1,in,zeros(r1-cver+VER-size(result,1),size(in,2)));
    bottom=VER;
    cver=cver-(r1-cver+VER-size(result,1));
else bottom=r1-cver+VER;
end
if r2-chor+1<1
    in=cat(2,zeros(size(in,1),-r2+chor),in);
    left=1;
    chor=chor+(chor-r2);
else left=r2-chor+1;
end
if r2-chor+HOR>size(result,2)
    in=cat(2,in,zeros(size(in,1),r2-chor+HOR-size(result,2)));
    right=HOR;
    chor=chor-(r2-chor+HOR-size(result,2));
else right=r2-chor+HOR;
end
%hier juiste vierkant uitsnijden
out=in(:cver-i+VER,chor-j:chor-j+HOR);