gm=[0 0];
EIND=100;
v=zeros(1,EIND);
w=zeros(1,EIND);
for beeldnr=1:EIND
    if mod(beeldnr,1000)==0
        load(['globalmotion/' num2str(floor((double(beeldnr)-1)/1000)+1)]);
        bm=totsse(1,1:3);
    else%if 0<mod(beeldnr,1000)<1000
        load(['globalmotion/' num2str(floor((double(beeldnr)-1)/1000))]);
        bm=totsse(mod(beeldnr,1000)+1,1:3);
    end
    v(beeldnr)=bm(2);
    w(beeldnr)=bm(3);
    gm(1)=gm(1)+bm(2);%Dit is de globalmotionvector van het current frame
    gm(2)=gm(2)+bm(3);
end
figure,plot(v)
figure,plot(w)
'median(v)', median(v)
'median(w)', median(w)
gm
