function pngmaker(start,step)
cd images
for teller=start:step:17980
    teller
    cd ../images
    beeld=imread(['Frame' num2str(teller) '.bmp']);
    cd ../pngimages
    name=['0000' num2str(teller)];
    imwrite(beeld,['Frame' name(length(name)-4: length(name)) '.png'],'png')
    
end