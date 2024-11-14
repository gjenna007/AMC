for i=1057:3800
    i
    if (i<10)
        c='00000000';
        d='000';
    elseif (i>9 && i<100)
        c='0000000';
        d='00';
    elseif (i>99 && i<1000)
        c='000000';
        d='0';
    elseif (i>999)
        c='00000';
        d='';
    end
    a=['schieplein met delft blauw      ' c num2str(i) '.bmp'];
    beeld=imread(a);
    b=[d num2str(i) '.bmp'];
    imwrite (beeld,b,'bmp');
end