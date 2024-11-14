%function newdetector(BEELDSTART,STEP)
Tg1=15;T2=230;Tk1=10;RAND=5;%FORMER=.82;NOW=.82;
%
%BEELDSTART=14; 
%STEP=1;
BEELDEIND=17960;
N_O_FRAMES=20; 
MASKSTART=1;MASKEIND=200;
MASKAVAILABLE=1;%0 als er nog geen mask is, 1 als er al een mask is
BLOBSAVAILABLE=0;%idem asl er al blobs gemaakt zijn
MINPERC=.45;
MINOVERLAP=.25;
TOPW=1;BOTTOMW=2;LEFTW=3;RIGHTW=4;
%cd ..
%roadpixels=zeros(256,256,256);
se=strel('disk',RAND);
%se2=strel('disk',30);
%initchance = zeros(size(backg,1),size(backg,2));
if (MASKAVAILABLE==1 &&  BLOBSAVAILABLE==0)

for beeld=BEELDSTART:BEELDEIND
    [beeld BEELDEIND]
    name=['0000' num2str(beeld)];
    backg=imread(['pngimages/Frame' name(length(name)-4:length(name)) '.png']);
    avgim=double(sum(backg,3))/3;
    dbackg1=double(backg(:,:,1));
    dbackg2=double(backg(:,:,2));
    dbackg3=double(backg(:,:,3));
    newcars=sum(imextendedmax(backg,50),3)>0;
    localregioncount=bwlabel(newcars);
    cars2 = zeros(size(backg,1),size(backg,2));
    max(localregioncount(:))
    rectnr=1;
    finger=mod(finger+1,20)+1;
    for teller=1:max(localregioncount(:))
        singleblob=(localregioncount==teller);
        if sum(singleblob(:))>4%0
            localregion=imdilate(singleblob,se)&(localregioncount==0);%andere punten in de buurt van singleblob moeten ook uitgesloten worden
            if median(abs(avgim(localregion)-dbackg1(localregion)))<Tk1&&median(abs(avgim(localregion)-dbackg2(localregion)))<Tk1&&median(abs(avgim(localregion)-dbackg3(localregion)))<Tk1
                ver=sum(singleblob,2);
                hor=sum(singleblob,1);
                top=find(ver,1,'first');
                bottom=find(ver,1,'last');
                left=find(hor,1,'first');
                right=find(hor,1,'last');
                if 1==1%~(bottom-top<4 || (right-left)>6*(bottom-top))
                    if 1==1%sum(singleblob(:))>.20*(right-left)*(bottom-top)
                        cars2=cars2|singleblob;
                        overlap=singleblob;%&mask;%hier wordt de mask gebruikt
                        if 1==1%sum(overlap(:))<MINOVERLAP*sum(singleblob(:))
                            b1=backg(:,:,1);
                            b2=backg(:,:,2);
                            b3=backg(:,:,3);
                            ttop=max(1,top-1);bbottom=min(size(b1,1),bottom+1);
                            lleft=max(1,left-1);rright=min(size(b1,2),right+1);
                            b1(ttop:bbottom,lleft:left)=255;
                            b1(ttop:bbottom,right:rright)=255;
                            b1(ttop:top,lleft:rright)=255;
                            b1(bottom:bbottom,lleft:rright)=255;
                            b2(ttop:bbottom,lleft:left)=0;
                            b2(ttop:bbottom,right:rright)=0;
                            b2(ttop:top,lleft:rright)=0;
                            b2(bottom:bbottom,lleft:rright)=0;
                            b3(ttop:bbottom,lleft:left)=0;
                            b3(ttop:bbottom,right:rright)=0;
                            b3(ttop:top,lleft:rright)=0;
                            b3(bottom:bbottom,lleft:rright)=0;
                            backg(:,:,1)=b1;
                            backg(:,:,2)=b2;
                            backg(:,:,3)=b3;
                            rectangles(rectnr,TOPW,finger)=ttop;
                            rectangles(rectnr,BOTTOMW,finger)=bbottom;
                            rectangles(rectnr,LEFTW,finger)=lleft;
                            rectangles(rectnr,RIGHTW,finger)=rright;
                            rectnr=rectnr+1;
                        end                                                                                                                             
                    end
                end
            end
        end
    end
    save(['newresults/cars' num2str(beeld)],'cars2')
    backg=min(255,backg);
    backg=uint8(max(0,backg));
    name=['0000' num2str(beeld)];
    imwrite(backg,['newresults/' name(length(name)-4:length(name)) '.png'],'png')
end
cd ..
end

if (MASKAVAILABLE==1 && BLOBSAVAILABLE==1)
    AANTALBEELDEN_M_EEN=-1;
    rectangles = zeros(50,6,N_O_FRAMES);
    rectcoordinates=zeros(1,10);
    rectcoordrow=1;
    rectcoordcol=2;
cd blobdata
load(['sumblobs' num2str(MASKSTART) '-' num2str(MASKEIND) '.mat'])
mask=initchance>MINPERC*(MASKEIND-MASKSTART+1);
temprectangles_old=ones(50,5);
rectnr_old=51;
temprectangles_old(:,BOTTOMW)=1080.*temprectangles_old(:,BOTTOMW);
temprectangles_old(:,RIGHTW)=1440.*temprectangles_old(:,RIGHTW);
temprectangles_older=temprectangles_old;
rectnr_older=rectnr_old;
for beeld=BEELDSTART:STEP:BEELDEIND
    [beeld BEELDSTART STEP BEELDEIND]
    cd ../blobdata
    load(['cars' num2str(beeld) '.mat'])
    blobnummers=bwlabel(cars2);
    cd ../images
    orig=imread(['Frame' num2str(beeld) '.bmp']);
    smallorig=imresize(orig,.5,'nearest');
    cd ../results21-4-3
    b1=orig(:,:,1);
    b2=orig(:,:,2);
    b3=orig(:,:,3);
    rectnr=1;
    ffinger=mod(AANTALBEELDEN_M_EEN,N_O_FRAMES)+1;
    AANTALBEELDEN_M_EEN=AANTALBEELDEN_M_EEN+1;
    finger=mod(AANTALBEELDEN_M_EEN,N_O_FRAMES)+1;
    temprectangles=zeros(50,5);
    for bn=1:max(blobnummers(:))
        singleblob=blobnummers==bn;
        if (sum(singleblob(:)))>40
            ver=sum(singleblob,2);
            hor=sum(singleblob,1);
            top=find(ver,1,'first');
            bottom=find(ver,1,'last');
            left=find(hor,1,'first');
            right=find(hor,1,'last');
            if ~(bottom-top<4 || (right-left)>6*(bottom-top))
                if sum(singleblob(:))>.20*(right-left)*(bottom-top)
                overlap=mask&singleblob;%hier wordt de mask gebruikt
                    if sum(overlap(:))<MINOVERLAP*sum(singleblob(:))
                            temprectangles(rectnr,TOPW)=top;
                            temprectangles(rectnr,BOTTOMW)=bottom;
                            temprectangles(rectnr,LEFTW)=left;
                            temprectangles(rectnr,RIGHTW)=right;
                            temprectangles(rectnr,5)=-1;
                            rectnr=rectnr+1;
                        %end
                    end
                end
            end
        end
    end
    %Rechthoeken aan elkaar plakken
    eerste=1;
    while eerste<rectnr
        if temprectangles(eerste,5)==-1
            tweede=eerste+1;
            while tweede<=rectnr
                if temprectangles(tweede,5)==-1
                    ET=temprectangles(eerste,TOPW);
                    EB=temprectangles(eerste,BOTTOMW);
                    EL=temprectangles(eerste,LEFTW);
                    ER=temprectangles(eerste,RIGHTW);
                    TT=temprectangles(tweede,TOPW);
                    TB=temprectangles(tweede,BOTTOMW);
                    TL=temprectangles(tweede,LEFTW);
                    TR=temprectangles(tweede,RIGHTW);
                    tmatch=ET-4<=TT&&EB+4>=TT&&TL<=ER+4&&TR>=EL-4;
                    bmatch=ET-4<=TB&&EB+4>=TB&&TL<=ER+4&&TR>=EL-4;
                    lmatch=EL-4<=TL&&ER+4>=TL&&TT<=EB+4&&TB>=ET-4;
                    rmatch=EL-4<=TR&&ER+4>=TR&&TT<=EB+4&&TB>=ET-4;
                    if(tmatch||bmatch||lmatch||rmatch)
                       TOMH=min(ET,TT);
                       BOMH=max(EB,TB);
                       LOMH=min(EL,TL);
                       ROMH=max(ER,TR);
                       if sum(sum(cars2(TOMH:BOMH,LOMH:ROMH)))>.4*(BOMH-TOMH)*(ROMH-LOMH)
                           temprectangles(eerste,TOPW)=TOMH;
                           temprectangles(eerste,BOTTOMW)=BOMH;
                           temprectangles(eerste,LEFTW)=LOMH;
                           temprectangles(eerste,RIGHTW)=ROMH;
                           temprectangles(tweede,5)=0;
                           tweede=eerste+1;%Opnieuw de rechthoeken overlopen
                       end
                    end
                end
                tweede=tweede+1;
            end
        end
        eerste=eerste+1;
    end
    
    %Weghalen sporadische rechthoeken 
    for thisframe=1:rectnr-1
        if temprectangles(thisframe,5)~=0
            lastframe=1;
            %if (1==1)%temprectangles_old(lastframe,5)~=0
                buffer=temprectangles(thisframe,5);
                temprectangles(thisframe,5)=0;
                while lastframe<rectnr_old
                    ET=temprectangles_old(lastframe,TOPW);
                    EB=temprectangles_old(lastframe,BOTTOMW);
                    EL=temprectangles_old(lastframe,LEFTW);
                    ER=temprectangles_old(lastframe,RIGHTW);
                    TT=temprectangles(thisframe,TOPW);
                    TB=temprectangles(thisframe,BOTTOMW);
                    TL=temprectangles(thisframe,LEFTW);
                    TR=temprectangles(thisframe,RIGHTW);
                    if(TB-TT)*(TR-TL)>200&&(TB-TT)*(TR-TL)<9000
                        temprectangles(thisframe,5)=buffer;
                        lastframe=rectnr_old;
                    end
                    tmatch=ET-5<=TT&&EB+5>=TT&&TL<=ER+5&&TR>=EL-5;
                    bmatch=ET-5<=TB&&EB+5>=TB&&TL<=ER+5&&TR>=EL-5;
                    lmatch=EL-5<=TL&&ER+5>=TL&&TT<=EB+5&&TB>=ET-5;
                    rmatch=EL-5<=TR&&ER+5>=TR&&TT<=EB+5&&TB>=ET-5;
                    if (tmatch||bmatch||lmatch||rmatch)
                        temprectangles(thisframe,5)=buffer;
                        lastframe=rectnr_old;
                    end
                    lastframe=lastframe+1;
                end;
                
                while lastframe<rectnr_older
                    ET=temprectangles_older(lastframe,TOPW);
                    EB=temprectangles_older(lastframe,BOTTOMW);
                    EL=temprectangles_older(lastframe,LEFTW);
                    ER=temprectangles_older(lastframe,RIGHTW);
                    TT=temprectangles(thisframe,TOPW);
                    TB=temprectangles(thisframe,BOTTOMW);
                    TL=temprectangles(thisframe,LEFTW);
                    TR=temprectangles(thisframe,RIGHTW);
                    if(TB-TT)*(TR-TL)>200&&(TB-TT)*(TR-TL)<9000
                        temprectangles(thisframe,5)=buffer;
                        lastframe=rectnr_older;
                    end
                    tmatch=ET-5<=TT&&EB+5>=TT&&TL<=ER+5&&TR>=EL-5;
                    bmatch=ET-5<=TB&&EB+5>=TB&&TL<=ER+5&&TR>=EL-5;
                    lmatch=EL-5<=TL&&ER+5>=TL&&TT<=EB+5&&TB>=ET-5;
                    rmatch=EL-5<=TR&&ER+5>=TR&&TT<=EB+5&&TB>=ET-5;
                    if (tmatch||bmatch||lmatch||rmatch)
                        temprectangles(thisframe,5)=buffer;
                        lastframe=rectnr_older;
                    end
                    lastframe=lastframe+1;
                end
            %end
        end
    end
    temprectangles_older=temprectangles_old;
    rectnr_older=rectnr_old;
    temprectangles_old=temprectangles;
    rectnr_old=rectnr;
   
    %Nu rechthoeken op beeld zetten
    %eerste=1;
    rectcoordcol=2;
    rectcoordinates(rectcoordrow,1)=beeld;
    for tweede=1:50
        if temprectangles(tweede,5)==-1
            top=temprectangles(tweede,TOPW);
            bottom=temprectangles(tweede,BOTTOMW);
            left=temprectangles(tweede,LEFTW);
            right=temprectangles(tweede,RIGHTW);
            ttop=max(1,top-1);bbottom=min(size(b1,1),bottom+1);
            lleft=max(1,left-1);rright=min(size(b1,2),right+1);
            b1(ttop:bbottom,lleft:left)=255;
            b1(ttop:bbottom,right:rright)=255;
            b1(ttop:top,lleft:rright)=255;
            b1(bottom:bbottom,lleft:rright)=255;
            b2(ttop:bbottom,lleft:left)=0;
            b2(ttop:bbottom,right:rright)=0;
            b2(ttop:top,lleft:rright)=0;
            b2(bottom:bbottom,lleft:rright)=0;
            b3(ttop:bbottom,lleft:left)=0;
            b3(ttop:bbottom,right:rright)=0;
            b3(ttop:top,lleft:rright)=0;
            b3(bottom:bbottom,lleft:rright)=0;
            rectcoordinates(rectcoordrow,rectcoordcol)=.5*(left+right);
            rectcoordinates(rectcoordrow,rectcoordcol+1)=.5*(top+bottom);
            rectcoordcol=rectcoordcol+2;
        end
    end
    rectcoordrow=rectcoordrow+1;
    
    orig(:,:,1)=b1;
    orig(:,:,2)=b2;
    orig(:,:,3)=b3;
    name=['0000' num2str(beeld)];
    imwrite(orig,[name(length(name)-4:length(name)) '.png'],'png')
    wk1write(['RECTCOORDS' num2str(BEELDSTART) '-' num2str(STEP) '-' num2str(beeld) '.xls'],rectcoordinates);
    cd small
    smallorig=imresize(orig,.5,'nearest');
    imwrite(smallorig,[name(length(name)-4:length(name)) '.png'],'png')
    cd ..
end
wk1write(['ARECTCOORDS' num2str(BEELDSTART) '-' num2str(STEP) '-' num2str(beeld) '.xls'],rectcoordinates);
cd ..
end