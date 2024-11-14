%fuction steermaker(START,EIND)
START=4600;EIND=4603;
RAND=5;
se=strel('disk',RAND);
cd pngimages
buitenmask=0;
v=zeros(46,766);
for beeld=START:EIND
    beeld
    cd ../blobdata
    bname=['cars' num2str(beeld) '.mat'];
    load(bname);
    cd ../pngimages
    lname=['0000' num2str(beeld)];
    iname=['Frame' lname(length(lname)-4:length(lname)) '.png'];
    omgevingen=imdilate(cars2,se)&(~cars2);
    buitenmask=buitenmask+sum(sum(~omgevingen));
    orig=imread(iname);
    rorig=double(orig(:,:,1)).*double(omgevingen);
    gorig=double(orig(:,:,2)).*double(omgevingen);
    borig=double(orig(:,:,3)).*double(omgevingen);
    for teller=1:256
        v(1,teller)=v(1,teller)+sum(sum(rorig==(teller-1)));
        v(2,teller)=v(2,teller)+sum(sum(gorig==(teller-1)));
        v(3,teller)=v(3,teller)+sum(sum(borig==(teller-1)));
    end
end
v(1,1)=v(1,1)-buitenmask; v(2,1)=v(2,1)-buitenmask; v(3,1)=v(3,1)-buitenmask;
w=double(v); w(1,:)=w(1,:)/max(w(1,:))*255;
w(2,:)=w(2,:)/max(w(2,:))*255;
w(3,:)=w(3,:)/max(w(3,:))*255;
w=uint8(w);
s=size(orig);
result=zeros(s(1),s(2),s(3));
for layer=1:3
    layer
    for ver=1:s(1)
        for hor=1:s(2)
            result(ver,hor,layer)=w(layer,orig(ver,hor,layer));
        end
    end
end    
result=uint8(result);
figure, plot(w(1,:)/(EIND-START+1));
figure, plot(w(2,:)/(EIND-START+1));
figure, plot(w(3,:)/(EIND-START+1));
figure, imshow(result)
cd ..