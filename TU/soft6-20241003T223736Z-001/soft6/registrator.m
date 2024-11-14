cd pngimages
orig=imread('Frame00002.png');
next=imread('Frame00003.png');
cd ..
cform = makecform('srgb2lab');
laborig = applycform(orig, cform);laborig=laborig(:,:,1);
labnext = applycform(next, cform);labnext=labnext(:,:,1);
s1=size(orig,1);s2=size(orig,2);
vw=round(double(s1)/40);hw=round(double(s2)/40);
%Je neem nu van ieder vierkantje het gemiddelde, en beschouwt al die gemiddelden als data waarvan je de variantie berekent
%Je berekent die van negen vierkanten en kiest het vierkant met de
%grootste variantie.
WINvar=[];
for WINver=12*vw+1:4*vw:20*vw+1
    for WINhor=12*hw+1:4*hw:20*hw+1
        vierkantjes=zeros(1,64);
        for ver=0:7
            for hor=0:7
                blokje=laborig(WINver+ver*vw:WINver+(ver+1)*vw,WINhor+hor*hw:WINhor+(hor+1)*hw);
                vierkantjes(ver*8+hor+1)=mean(blokje(:));
            end
        end
        WINvar=[WINvar var(vierkantjes)];
    end
end
bestWIN=find(WINvar==max(WINvar),1,'first');
WINhor=12*hw+mod(bestWIN-1,3)*4*hw;
WINver=12*vw+floor((bestWIN-1)/3)*4*vw;
ORIGINver=WINver+4*vw;ORIGINhor=WINhor+4*vw;%DE OORSPRONG VAN ALLE TRANSLATIES EN ROTATIES
regimg=zeros(8*vw+1,8*hw+1,3);
regimg(:,:,1)=laborig(WINver:WINver+8*vw,WINhor:WINhor+8*hw);
for counter=1:8*vw+1; regimg(counter,:,2)=(-4*hw:4*hw);end;%2 is hor, en 3 is ver
for counter=1:8*hw+1; regimg(:,counter,3)=(-4*vw:4*vw)';end;%vanwege eerst x dan y
%nu we het blokje hebben kunnen we daar meteen ook al een histogram van
%maken. 
%Ik geloof dat de snelle aanpak van dit soort registratie de
%multiresolutie-aanpak is.
alpha=0.602;gamma=0.101;
a=1;c=1;p=3;A=1;n=2;theta=[0;0;0];%theta is je startpunt
%De precieze positie van het blokje hebben we alleen nodig om de latere
%histogrammen te maken. 
regimgplus=regimg;
regimgminus=regimg;
[historig,x]=imhist(laborig);
histnextplus=zeros(1,256);histjointplus=zeros(256);
histnextminus=zeros(1,256);histjointminus=zeros(256);
for k=1:n%n is het aantal iteraties; hier wordt dus gewoon een vast aantal iteraties gekozen
    k
    ak=a/(k+A)^alpha;
    ck=c/k^gamma;
    delta=2*round(rand(p,1))-1;
    thetaplus=theta+ck*delta;
    thetaminus=theta-ck*delta;
    for v=1:8*vw+1
        for h=1:8*hw+1
            Tp=MakeLookUpTable(-thetaplus,max(hw,vw),max(hw,vw));
            regimgplus(v,h,2)=Tp(4*vw+1+regimgplus(v,h,2),4*hw+1+regimgplus(v,h,3),1);
            regimgplus(v,h,3)=Tp(4*vw+1+regimgplus(v,h,2),4*hw+1+regimgplus(v,h,3),2);
            Tm=MakeLookUpTable(-thetaminus,hw,vw);
            regimgminus(v,h,2)=Tm(4*vw+1+regimgminus(v,h,2),4*hw+1+regimgminus(v,h,3),1);
            regimgminus(v,h,3)=Tm(4*vw+1+regimgminus(v,h,2),4*hw+1+regimgminus(v,h,3),2);
        end
    end
   %here we make the joint intensity histograms
    for v=1:8*vw+1
        for h=1:8*hw+1
            index=labnext(ORIGINver+regimgplus(v,h,3),ORIGINhor+regimgplus(v,h,2));
            histnextplus(index)=histnextplus(index)+1;
            histjointplus(regimg(v,h,1),index)=histjointplus(regimg(v,h,1),index)+1;
            index=labnext(ORIGINver+regimgminus(v,h,3),ORIGINhor+regimgminus(v,h,2));
            histnextminus(index)=histnextminus(index)+1;
            histjointminus(regimg(v,h,1),index)=histjointminus(regimg(v,h,1),index)+1;
        end
    end
    %de pdfs
    porig=double(historig)/sum(historig);
    pnextplus=double(histnextplus)/sum(histnextplus);pnextmimus=double(histnextminus)/sum(histnextminus);
    pjointplus=double(histjointplus)/sum(sum(histjointplus));pjointminus=double(histjointminus)/sum(sum(histjointminus));
    %de entropieen
    Horig=-sum(porig.*log(porig+.00001*(porig==0)));
    Hnextplus=-sum(pnextplus.*log(pnextplus+.00001*(pnextplus==0)));
    Hnextminus=-sum(pnextminus.*log(pnextminus+.00001*(pnextminus==0)));
    Hjointplus=-sum(sum(pjointplus.*log(pjointplus+.00001*(pjointplus==0))));
    Hjointminus=-sum(sum(pjointminus.*log(pjointminus+.00001*(pjointminus==0))));
    %de MIs
    yplus=-(Horig+Hnextplus-Hjointplus);
    yminus=-(Horig+Hnextminus-Hjointminus);
    ghat=(yplus-yminus)./(2*ck*delta);
    theta=theta-ak*ghat;
    KLdist=[KLdist theta];
end
theta
for v=1:8*vw+1
    for h=1:8*hw+1
        next(regimgplus(v,h,3),regimgplus(v,h,2),1)=regimgplus(v,h,1);
        next(regimgplus(v,h,3),regimgplus(v,h,2),2)=0;
        next(regimgplus(v,h,3),regimgplus(v,h,2),3)=0;
    end
end
figure,imshow(regimgplus)

