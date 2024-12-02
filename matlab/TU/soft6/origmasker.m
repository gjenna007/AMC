BEGIN=1;Tg1=15;T2=230;Tk1=10;FORMER=.82;NOW=.82;RAND=5;
backg=imread(['Frame' num2str(BEGIN) '.bmp']);
oldcars = zeros(size(backg,1),size(backg,2));
oldcarcount = ones(size(backg,1),size(backg,2));
oldcarcount(1,1)=0;
roadpixels=zeros(256,256,256);
se=strel('disk',RAND);
for beeld=BEGIN+1:1:BEGIN+200
    beeld
    foreg=imread(['Frame' num2str(beeld) '.bmp']);
    avgim=double(sum(backg,3))/3;
    dbackg1=double(backg(:,:,1));
    dbackg2=double(backg(:,:,2));
    dbackg3=double(backg(:,:,3));
    road=abs(avgim-dbackg1)<Tg1&abs(avgim-dbackg2)<Tg1&abs(avgim-dbackg3)<Tg1&avgim<T2&avgim>40;
    for i=1:size(backg,1)
        for j=1:size(backg,2)
            if road(i,j)==1
                roadpixels(backg(i,j,1),backg(i,j,2),backg(i,j,3))=roadpixels(backg(i,j,1),backg(i,j,2),backg(i,j,3))+1;
            end
        end
    end
    figure, imshow(road)
    imwrite(road,['Road' num2str(beeld) '.bmp'],'bmp');
    fillroad=imfill(road,'holes');
    figure, imshow(fillroad)
    newcars=fillroad&(~road);
    newcarcount=bwlabel(newcars);
    figure, imshow(newcars)
    
    cars = zeros(size(backg,1),size(backg,2));
    max(newcarcount(:))
    while(0)%dit stuk wordt dus voorlopig even niet gedaan
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
    end%end while-loop
    %localregions=imdilate(cars,se);
    %figure, imshow(localregions)
    localregioncount=bwlabel(newcars);
    cars2 = zeros(size(backg,1),size(backg,2));
    cars3 = zeros(size(backg,1),size(backg,2));
    max(localregioncount(:))
    for teller=1:max(localregioncount(:))
        if mod(teller,100)==0
            teller
        end
        singleblob=(localregioncount==teller);
        localregion=imdilate(singleblob,se)&(localregioncount==0);%andere punten in de buurt van singleblob moeten ook uitgesloten worden
        cars3=cars3|localregion;
        if median(abs(avgim(localregion)-dbackg1(localregion)))<Tk1&&median(abs(avgim(localregion)-dbackg2(localregion)))<Tk1&&median(abs(avgim(localregion)-dbackg3(localregion)))<Tk1
            cars2=cars2|singleblob;
        end
    end
    figure, imshow(cars3)  
    cd beelden
    imwrite(newcars,['Dmask' num2str(beeld) '.bmp'],'bmp');
    %save(['Emaska' num2str(beeld)],'newcarcount');
    %cd ..
    film1=min(255,dbackg1+255*cars2);
    film2=max(0,dbackg2-255*cars2);
    %film2=dbackg2;
    film3=max(0,dbackg3-255*cars2);
    %film3=dbackg3;
    res=backg;
    res(:,:,1)=uint8(film1);
    res(:,:,2)=uint8(film2);
    res(:,:,3)=uint8(film3);
    figure, imshow(res)
    %cd beelden
    imwrite(res,['Dbeeld' num2str(beeld) '.bmp'],'bmp')
    cd ..
    backg=foreg;
    oldcars=newcars;
    oldcarcount=newcarcount;
end 
cd beelden
save([num2str(begin) '-200' '.mat'],'roadpixels');
cd ..