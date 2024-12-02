for beeldnr=7500:17000
    beeldnr
    name=['0000' num2str(beeldnr-1)];
    orig=imread(['pngimages/Frame' name(length(name)-4:length(name)) '.png']);
    smallorig=orig(574:574+271,169:169+1129,:);
    name=['0000' num2str(beeldnr)];
    next=imread(['pngimages/Frame' name(length(name)-4:length(name)) '.png']);
    if mod(beeldnr,1000)==0
        load(['globalmotion/' num2str(floor((double(beeldnr)-1)/1000)+1)]);
        bm=totsse(size(totsse,1),1:3);
        VER=2;HOR=3;
    else%if 0<mod(beeldnr+1,1000)<1000
        load(['globalmotion/' num2str(floor((double(beeldnr)-1)/1000))]);
        bm=totsse(mod(beeldnr,1000)+1,1:3);
        VER=2;HOR=3;
    end
    bm=totsse(mod(beeldnr,1000)+1,1:3);
    VER=2;HOR=3;
    transv=bm(VER); transh=bm(HOR);
    smallnext=next(574+transv:574+271+transv,169+transh:169+1129+transh,:);
    imwrite(smallorig,['stabilized/orig' name(length(name)-4:length(name)) '.png'],'png');
    imwrite(smallnext,['stabilized/translated' name(length(name)-4:length(name)) '.png'],'png');
    diff=double(smallorig)-double(smallnext);
    save(['stabilized/Frame' name(length(name)-4:length(name))],'diff');
    imwrite(uint8(abs(diff)),['stabilized/diffimg' name(length(name)-4:length(name)) '.png'],'png');
    tusdiff=(abs(diff(:,:,1))+abs(diff(:,:,2))+abs(diff(:,:,3)))/3;
    visdiff=255*tusdiff/max(tusdiff(:));
    imwrite(uint8(visdiff),['stabilized/VISdiffimg' name(length(name)-4:length(name)) '.png'],'png');
end