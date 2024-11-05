function filt=frostfilter(orig,width,est)
%Frost filters the image. est is a coefficient that determines the filter strength, width
%is the half-length of the side of the square window in which the local variance is calculated.
%The border is padded with zeros.
%width=3;
%est=1;

mask=ones(2*width+1);
mask=mask/sum(mask(:));
line=abs([-width:width]);
mask2=[];
for j=1:2*width+1
    mask2=[mask2;line];
end
mask2=mask2+mask2';
avgfilt=filter2(mask,orig);
varfilt=double(orig)-avgfilt;
varfilt=varfilt.*varfilt;
varfilt=filter2(mask,varfilt);
avgfilt=avgfilt.*avgfilt;
avgfilt=avgfilt+.00001*(avgfilt==0);
exponent=-est*varfilt./avgfilt;
filt=orig;
s=size(orig);
padded=zeros(s(1)+2*width,s(2)+2*width);
padded(width+1:width+s(1),width+1:width+s(2))=double(orig);
for ver=1:s(1)
    for hor=1:s(2)
        kernel=exp(exponent(ver,hor)*mask2);
        filt(ver,hor)=sum(sum(kernel.*padded(ver:ver+2*width,hor:hor+2*width)))/sum(kernel(:));
    end
end
filt=uint8(filt);
%figure,imshow(filt)