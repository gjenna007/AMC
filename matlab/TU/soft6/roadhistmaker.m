se=strel('disk',5);
redhist=zeros(256,1);
greenhist=zeros(256,1);
bluehist=zeros(256,1);
totalwhite=0;
cd images
for beeld=4700:4799
    beeld
    cd ../images
    orig=imread(['Frame' num2str(beeld) '.bmp']);
    cd ../blobdata
    load(['cars' num2str(beeld)])
    mask=imdilate(cars2,se)&(~cars2);
    totalwhite=totalwhite+sum(mask(:));
    redhist=redhist+imhist(uint8(double(mask).*double(orig(:,:,1))));
    greenhist=greenhist+imhist(uint8(double(mask).*double(orig(:,:,2))));
    bluehist=bluehist+imhist(uint8(double(mask).*double(orig(:,:,3))));
end
cd ..
redhist(1)=redhist(1)-(100*1440*1080-totalwhite);
greenhist(1)=greenhist(1)-(100*1440*1080-totalwhite);
bluehist(1)=bluehist(1)-(100*1440*1080-totalwhite);
redhist1=double(redhist)./double(sum(redhist(:)));
greenhist1=double(greenhist)./double(sum(greenhist(:)));
bluehist1=double(bluehist)./double(sum(bluehist(:)));
save('redhist4700-4799','redhist','redhist1')
save('greenhist4700-4799','greenhist','greenhist1')
save('bluehist4700-4799','bluehist','bluehist1')
figure,plot(redhist1),title('redhist4700-4799')
figure,plot(greenhist1),title('greenhist4700-4799')
figure,plot(bluehist1),title('bluehist4700-4799')