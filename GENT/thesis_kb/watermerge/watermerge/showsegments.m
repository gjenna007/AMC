% deze functie kleurt de watershedsegmentranden rood in het beeld
function returnsegments = showsegments(segments, im, water)

s=size(im);
imagesegments=zeros(s(1),s(2),3);
imagesegments(:,:,1)=im;
imagesegments(:,:,2)=im;
imagesegments(:,:,3)=im;
   
hulp=(water~=0).*imagesegments(:,:,1); %roodvlak op 255
roodvlak=(hulp==0)*255+hulp;
imagesegments(:,:,1)=roodvlak;
   
imagesegments(:,:,2)=(water~=0).*imagesegments(:,:,2); %groenvlak op 0
imagesegments(:,:,3)=(water~=0).*imagesegments(:,:,3); %blauwvlak op 0

   
returnsegments=uint8(imagesegments);