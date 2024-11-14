BEGIN=30;AANTAL=10;RAND=5;
backg=imread([num2str(BEGIN) '.bmp']);
result = ones(size(backg,1),size(backg,2));
se=strel('disk',RAND);
for beeld=BEGIN+1:BEGIN+AANTAL
    beeld
    foreg=imread([num2str(beeld) '.bmp']);
    avgim=double(sum(backg,3))/3;
    dbackg1=double(backg(:,:,1));
    dbackg2=double(backg(:,:,2));
    dbackg3=double(backg(:,:,3));
    road=abs(avgim-dbackg1)<Tg1&abs(avgim-dbackg2)<Tg1&abs(avgim-dbackg3)<Tg1&avgim<T2&avgim>40;
    fillroad=imfill(road,'holes');
    newcars=fillroad&(~road);
    result=result&newcars;
    backg=foreg;
end
figure, imshow(result,[])