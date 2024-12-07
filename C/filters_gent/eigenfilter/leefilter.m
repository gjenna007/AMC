function filt=leefilter(orig,width,est)
%Lee filters the image. est is the estimated noise variance over the complete image, width
%is the half-length of the side of the square window in which the local variance is calculated.
%The border is padded with zeros.
%load rlvolume;
%c=b;
%for teller=1:18
%   teller
%   orig=b(:,:,teller);
mask=ones(2*width+1)/((2*width+1)*(2*width+1));
avgfilt=filter2(mask,orig);
varfilt=double(orig)-avgfilt;
varfilt=varfilt.*varfilt;
varfilt=filter2(mask,varfilt);
varfilt=varfilt+.0001*(varfilt==0);
beta=max((varfilt-est)./varfilt,0);
filt=uint8(beta.*double(orig)+(1-beta).*avgfilt);
%c(:,:,teller)=filt;
%end
%save('rlleew3e250','c')
%figure,imshow(filt)