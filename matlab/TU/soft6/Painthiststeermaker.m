%fuction steermaker(START,EIND)
START=4600;EIND=4700;
RAND=3;
se=strel('disk',RAND);
cd pngimages
FOUTEN=0;
v=zeros(136,766);
dists=[];
for beeld=START:EIND
    beeld
    cd ../blobdata
    bname=['cars' num2str(beeld) '.mat'];
    load(bname);
    cars2=imresize(cars2,0.5,'nearest');
    cd ../smallpaint
    lname=['0000' num2str(beeld)];
    iname=['bFrame' lname(length(lname)-4:length(lname)) '.png'];
    omgevingen=imdilate(cars2,se)&(~cars2);
    orig=double(imread(iname));
    avg=(orig(:,:,1)+orig(:,:,2)+orig(:,:,3))/3;
    dist=abs(orig(:,:,1)-avg)+abs(orig(:,:,2)-avg)+abs(orig(:,:,3)-avg);
    for ver=1:size(orig,1)
        for hor=1:size(orig,2)
            if omgevingen(ver,hor)==1
                if dist(ver,hor)>45
                    FOUTEN=FOUTEN+1;
                else
                    v(uint16(dist(ver,hor)*3)+1,uint16(avg(ver,hor)*3)+1)=1+v(uint16(dist(ver,hor)*3)+1,uint16(avg(ver,hor)*3)+1);
                end
            end
        end
    end
end
cd ..
w2=zeros(46,256);
w1=zeros(46,766);
w1(1,:)=v(1,:)+v(2,:);
w1(46,:)=v(135,:)+v(136,:);
for ver=2:45
    w1(ver,:)=v(3*(ver-1),:)+v(3*(ver-1)+1,:)+v(3*(ver-1)+2,:);
end

w2(:,1)=w1(:,1)+w1(:,2);
w2(:,256)=w1(:,765)+w1(:,766);
for hor=2:255
    w2(:,hor)=w1(:,3*(hor-1))+w1(:,3*(hor-1)+1)+w1(:,3*(hor-1)+2);
end

save(['Paintroad' num2str(START) '-' num2str(EIND) '.mat'],'v','w2','FOUTEN')
