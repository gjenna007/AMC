%op het eind kan je gewoon het minimum van alle tien vectoren nemen
STEP=20;
for beeldnr=3012:3012
    beeldnr
    if beeldnr<87
    STEP=20; VER=3; HOR=4;
elseif beeldnr>=87 &&  beeldnr<2039
    STEP=20; VER=2; HOR=3;
else
    STEP=10; VER=2; HOR=3;
end
%cd pngimages/
name=['0000' num2str(beeldnr)];
orig=imread(['pngimages/Frame' name(length(name)-4:length(name)) '.png']);
name=['0000' num2str(beeldnr+1)];
next=imread(['pngimages/Frame' name(length(name)-4:length(name)) '.png']);
%cd ../matchresults
name=['0000' num2str(beeldnr+1)];
load(['matchresults/vars' name '.mat']);
load(['matchresults/sse' num2str(1) '-' num2str(STEP) '-' name '.mat']);
%matchblok=imread(['block' name '.png']);
be=find(sse(:,1)==min(sse(:,1)),1,'first');
bm=sse(be,:);
for begin=2:STEP;
    load(['matchresults/sse' num2str(begin) '-' num2str(STEP) '-' name '.mat'])
    be=find(sse(:,1)==min(sse(:,1)),1,'first');
    if sse(be,1)<bm(1)
        bm=sse(be,:);
    end
end
%cd ../inpassingen/
[be bm(2) bm(3)]
transv=bm(2); transh=bm(3);%theta=bm(2); 
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
result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,1)=uint8(windowr.*double(1-mask(:,:,1))+255*(matchblok/max(matchblok(:))));
result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,2)=uint8(windowg.*double(1-mask(:,:,1))+255*(matchblok/max(matchblok(:))));
result(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,3)=uint8(windowb.*double(1-mask(:,:,1))+255*(matchblok/max(matchblok(:))));
figure, imshow(result)
%imwrite(result,['inpassingen/' name(length(name)-4:length(name)) '.png'],'png')
%cd ..
end%beeldnr!!
