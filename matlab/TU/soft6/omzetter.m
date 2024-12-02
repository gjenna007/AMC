for beeld=23:88
    beeld
    a=['FIN' num2str(beeld) '.png'];
    b=imread(a);
    imwrite(b,['B' num2str(beeld) 'A.bmp'],'bmp')
    imwrite(b,['B' num2str(beeld) 'B.bmp'],'bmp')
    imwrite(b,['B' num2str(beeld) 'C.bmp'],'bmp')
    imwrite(b,['B' num2str(beeld) 'D.bmp'],'bmp')
end