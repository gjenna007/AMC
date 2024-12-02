cd masker7
beeld=imread('result50.bmp');
chance=zeros(size(beeld,1),size(beeld,2));
for nummer=10:96
    [nummer 50]
    beeld=imread(['result' num2str(nummer) '.bmp']);
    slice=double(beeld(:,:,1)==255&beeld(:,:,2)==0);
    chance=chance+slice;
end
cd ..