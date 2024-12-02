function outmask=herschaler2(inmask,beeld)
%geeft een mask terug (die hetzelfde is als de inmask) met de afmetingen van het beeld.

sb=size(beeld);
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
