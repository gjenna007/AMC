%function NEWdisplayer(beginbeeld,eindbeeld,rect)
%cd ../inpassingen/
beginbeeld=13998;
eindbeeld=14002;
rect='origrect';
xrect=289;
width=244;
yrect=560;
height=163;
for beeldnr=beginbeeld:eindbeeld
    name=['0000' num2str(beeldnr)];
    orig=imread(['pngimages\Frame' name(length(name)-4:length(name)) '.png']);
    name=['0000' num2str(beeldnr+1)];
    next=imread(['pngimages\Frame' name(length(name)-4:length(name)) '.png']);
    if mod(beeldnr+1,1000)==0
        load(['globalmotion/' num2str(floor(beeldnr/1000)+1)]);
        load(['globalmotion/' num2str(floor(beeldnr/1000)+1) 'vars']);
        bm=totsse(1,1:3);
    else%if 0<mod(beeldnr+1,1000)<1000
        load(['globalmotion/' num2str(floor(beeldnr/1000))]);
        load(['globalmotion/' num2str(floor(beeldnr/1000)) 'vars']);
        bm=totsse(mod(beeldnr+1,1000)+1,1:3);
    end
    transv=bm(2); transh=bm(3);%theta=bm(2);
    if strcmp(rect,'origrect')==1
        WINver=totvars(mod(beeldnr+1,1000)+1,1);
        WINhor=totvars(mod(beeldnr+1,1000)+1,2);
        vw=totvars(mod(beeldnr+1,1000)+1,3);
        hw=totvars(mod(beeldnr+1,1000)+1,4);
    else vw=ceil(height/8);
        WINver=yrect;
        hw=ceil(width/8);
        WINhor=xrect;
    end
    %WINver en WINhor moet je vervangen door de afmetingen van het blokje
    %dat je bekijkt.
    matchblok=next(WINver+transv:WINver+transv+8*vw,WINhor+transh:WINhor+transh+8*hw,:);
    %matchblok=imrotate(matchblok_old,theta,'bilinear');
    bv=size(matchblok,1);bh=size(matchblok,2);
    ORIGINver=WINver+4*vw;ORIGINhor=WINhor+4*hw;%DE OORSPRONG VAN ALLE TRANSLATIES EN ROTATIES
    centreindicator=zeros(8*vw+1,8*hw+1);
    centreindicator(4*vw+1,4*hw+1)=1;
    %centre=imrotate(centreindicator,theta,'bilinear');
    [cv,ch]=find(centreindicator,1,'first');
    mask=matchblok>0;
    matchblok=double(matchblok(:,:,1));
    result=orig;
    windowr=double(result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,1));
    windowg=double(result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,2));
    windowb=double(result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,3));
    result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,1)=uint8(windowr.*double(1-mask(:,:,1))+matchblok);%255*(matchblok/max(matchblok(:))));
    result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,2)=uint8(windowg.*double(1-mask(:,:,1))+matchblok);%255*(matchblok/max(matchblok(:))));
    result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,3)=uint8(windowb.*double(1-mask(:,:,1))+matchblok);%255*(matchblok/max(matchblok(:))));
    figure, imshow(result)
    %imwrite(result,['inpassingen/' name(length(name)-4:length(name)) '.png'],'png')
    %cd ..
end%beeldnr!!
