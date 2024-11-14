BEGIN=30;
backg=imread([num2str(BEGIN) '.bmp']);
sedisko=strel('disk',1);
sediskc=strel('disk',1);
for beeld=BEGIN+1:96
    beeld
    foreg=imread([num2str(beeld) '.bmp']);
    avgim=double(sum(backg,3)/3);
    dbackg1=double(backg(:,:,1));
    dbackg2=double(backg(:,:,2));
    dbackg3=double(backg(:,:,3));
    road=abs(avgim-dbackg1)<10&abs(avgim-dbackg2)<10&abs(avgim-dbackg3)<10&avgim<140;
    vroad=sum(road,2);hroad=sum(road,1);
    
    top=find(vroad<(max(vroad)-1000),1,'first');
    bottom=find(vroad<(max(vroad)-500),1,'last');
    left=find(hroad<(max(hroad)-5),1,'first');
    right=find(hroad<(max(hroad)-5),1,'last');
    road(1:top,:)=0;road(bottom:length(vroad),:)=0;
    road(:,1:left)=0;road(:,right:length(hroad))=0;
    figure, imshow(road)
    road=imfill(road,'holes');
    diffim=abs(double(backg)-double(foreg))>20;
    platdiff=double((diffim(:,:,1)|diffim(:,:,2)|diffim(:,:,3))&road);
    diffdo=platdiff;
    %diffdo=imopen(platdiff,sedisko);
    diffdc=imclose(diffdo,sediskc);
    %diffdc=platdiff;
    film1=min(255,dbackg1+255*diffdc);
    film2=max(0,dbackg2-255*diffdc);
    film3=max(0,dbackg3-255*diffdc);
    res=backg;
    res(:,:,1)=uint8(film1);
    res(:,:,2)=uint8(film2);
    res(:,:,3)=uint8(film3);
    %imwrite(res,['G13M' num2str(beeld) '.bmp'],'bmp')
    backg=foreg;
end 