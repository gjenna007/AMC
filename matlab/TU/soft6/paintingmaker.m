cd pngimages
for beeld= 4600:4700
    beeld
    cd ../pngimages
    orig=['Frame0' num2str(beeld) '.png'];
    a=imread(orig);
    cd ../kuwahara-like
    b=painter(double(a),3,8,8);
    imwrite(b,['b' orig],'png');
end
    
    