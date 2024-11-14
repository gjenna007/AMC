MINPERC=.5;
cd masker7
initchance=zeros(size(beeld,1),size(beeld,2));
for nummer=10:96
    [nummer 96 1]
    beeld=imread(['result' num2str(nummer) '.bmp']);
    slice=(beeld(:,:,1)==255&beeld(:,:,2)==0);
    initchance=initchance+double(slice);
end
mask=initchance>MINPERC*97;
figure, imshow(initchance,[])
figure, imshow(mask,[])
se=strel('disk',30);
fframe=imdilate(mask, se);

beeld=imread('result10.bmp');
chance=zeros(size(beeld,1),size(beeld,2));
for nummer=11:96
    [nummer 96  2]
    beeld=imread(['result' num2str(nummer) '.bmp']);
    slice=(beeld(:,:,1)==255&beeld(:,:,2)==0);
    blobnummers=bwlabel(slice);
    for bn=1:max(blobnummers(:))
        singleblob=blobnummers==bn;
        overlap=fframe&singleblob;
        if sum(singleblob(:))==sum(overlap(:))
            chance=chance+double(singleblob);
        end
    end
end
figure, imshow(chance,[])
cd ..