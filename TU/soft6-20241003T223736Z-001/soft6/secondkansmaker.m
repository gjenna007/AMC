cd masker7
beeld=imread('result10.bmp');
chance=zeros(size(beeld,1),size(beeld,2));
slice=(beeld(:,:,1)==255&beeld(:,:,2)==0);
se=strel('disk',10);
fframe=imdilate(slice, se);
for nummer=11:96
    [nummer 96]
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

cd ..