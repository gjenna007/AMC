%vierkantjes op beeld zetten
beeld=imread(['20-0000000' num2str(beeldnr) '.png']);
result=uint8(imresize(beeld,0.5,'bilinear')<-10);
for beeldnr=23:88
    [beeldnr 88]
    beeld=imread(['20-0000000' num2str(beeldnr) '.png']);
    beeld=imresize(beeld,0.5,'bilinear');
    cars=imread(['S' num2str(beeldnr) '.png']);
    mask=cars(:,:,1)|cars(:,:,2)|cars(:,:,3);
    beeld1=double(beeld).*double(1-double(mask))+double(cars(:,:,1));
    beeld2=double(beeld).*double(1-double(mask))+double(cars(:,:,2));
    beeld3=double(beeld).*double(1-double(mask))+double(cars(:,:,3));
    result(:,:,1)=uint8(beeld1);
    result(:,:,2)=uint8(beeld2);
    result(:,:,3)=uint8(beeld3);
    imwrite(uint8(result),['FIN' num2str(beeldnr) '.png'],'png')
end