BEGIN=10;T1=15;T2=230;FORMER=.82;NOW=.82;
backg=imread([num2str(BEGIN) '.bmp']);
oldcars = zeros(size(backg,1),size(backg,2));
oldcarcount = ones(size(backg,1),size(backg,2));
oldcarcount(1,1)=0;
for beeld=BEGIN+4:4:BEGIN+86
    beeld
    foreg=imread([num2str(beeld) '.bmp']);
    avgim=double(sum(backg,3))/3;
    dbackg1=double(backg(:,:,1));
    dbackg2=double(backg(:,:,2));
    dbackg3=double(backg(:,:,3));
    road=abs(avgim-dbackg1)<T1&abs(avgim-dbackg2)<T1&abs(avgim-dbackg3)<T1&avgim<T2&avgim>40;
    %figure, imshow(road)
    fillroad=imfill(road,'holes');
    %figure, imshow(fillroad)
    newcars=fillroad&(~road);
    newcarcount=bwlabel(newcars);
    cd beelden
    imwrite(newcars,['Dmask' num2str(beeld) '.bmp'],'bmp');
    save(['Dmaska' num2str(beeld)],'newcarcount');
    cd ..
    cars = zeros(size(backg,1),size(backg,2));
    max(newcarcount(:))
    for teller=1:max(newcarcount(:))
        if mod(teller,100)==0
            teller
        end
        singleblob=(newcarcount==teller);
        overlap=(oldcars>0)&singleblob;
        if max(overlap(:))==1
            oldblobs=unique(oldcarcount(singleblob));
            origin = zeros(size(backg,1),size(backg,2));
            if oldblobs(1)==0
                init=2;
            else
                init=1;
            end
            for teller2=init:length(oldblobs)
                origin=origin|(oldcarcount==oldblobs(teller2));
            end
            so=sum(overlap(:));
            if (so<FORMER*sum(singleblob(:))&&so<NOW*sum(origin(:))&&sum(singleblob(:))<2000)
                cars=cars|singleblob;
            end
        end
    end
    film1=min(255,dbackg1+255*cars);
    film2=max(0,dbackg2-255*cars);
    %film2=dbackg2;
    film3=max(0,dbackg3-255*cars);
    %film3=dbackg3;
    res=backg;
    res(:,:,1)=uint8(film1);
    res(:,:,2)=uint8(film2);
    res(:,:,3)=uint8(film3);
    figure, imshow(res)
    cd beelden
    imwrite(res,['Dbeeld' num2str(beeld) '.bmp'],'bmp')
    cd ..
    backg=foreg;
    oldcars=newcars;
    oldcarcount=newcarcount;
end 