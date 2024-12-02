function [outmask,outbeeld]=herschaler(inmask,beeld)
%geeft een mask terug (die hetzelfde is als de inmask) met de afmetingen van het beeld.
kader=(beeld==0);
shor=sum(kader,1);
sver=sum(kader,2);
hor2=max(find(shor==max(shor)));
shor(hor2)=0;
hor1=max(find(shor==max(shor)));
ver2=max(find(sver==max(sver)));
sver(ver2)=0;
ver1=max(find(sver==max(sver)));
sb=[abs(ver2-ver1)-1 abs(hor2-hor1)-1];
si=size(inmask);
outmask=ones(sb(1),sb(2));
lijsth=[1:sb(2)];
lijstv=[1:sb(1)];
lijsth=ceil(si(2)/sb(2)*lijsth);
lijstv=ceil(si(1)/sb(1)*lijstv);
for ver=1:sb(1)
    for hor=1:sb(2)
        if inmask(lijstv(ver),lijsth(hor))==0
            outmask(ver,hor)=0;
        end
    end
end
outbeeld=beeld(min(ver1,ver2)+1:max(ver1,ver2)-1,min(hor1,hor2)+1:max(hor1,hor2)-1);