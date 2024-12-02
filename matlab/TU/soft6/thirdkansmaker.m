MINPERC=.70;
EIND=201;
START=2;
MINOVERLAP=.25;
cd RWS_12min/beelden
beeld=imread('Dbeeld002.bmp');
initchance=zeros(size(beeld,1),size(beeld,2));
for nummer=START:EIND
    [nummer EIND 1]
    if nummer<10
        a='00';
    elseif (nummer>9 && nummer<100)
        a='0';
    else
        a='';
           
    end
    beeld=imread(['Dbeeld' a num2str(nummer) '.bmp']);
    slice=(beeld(:,:,1)==255&beeld(:,:,2)==0);
    se=strel('disk',30);
    slice=imdilate(slice, se);
    initchance=initchance+double(slice);
end
mask=initchance>MINPERC*EIND;
%figure, imshow(initchance,[])
save('sumblobs2-201','initchance');
figure, imshow(mask,[])
%[x,y]=ginput;

chance=zeros(size(beeld,1),size(beeld,2));
for nummer=START:EIND
    [nummer EIND  2]
    if nummer<10
        a='00';
    elseif (nummer>9 && nummer<100)
        a='0';
    else
        a='';
    end
    beeld=imread(['Dbeeld' a num2str(nummer) '.bmp']);
    slice=(beeld(:,:,1)==255&beeld(:,:,2)==0);
    blobnummers=bwlabel(slice);
    for bn=1:max(blobnummers(:))
        singleblob=blobnummers==bn;
        overlap=mask&singleblob;
        if sum(overlap(:))>=MINOVERLAP*sum(singleblob(:))
            chance=chance+double(singleblob);
        end
    end
end
figure, imshow(chance,[])
cd ../..
imwrite(uint8(double(chance)*255/max(chance(:))),'overlap25perc.bmp','bmp')