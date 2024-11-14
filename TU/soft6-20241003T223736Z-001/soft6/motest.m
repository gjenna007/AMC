function motest(begin,STEP,beeldnr)
name=['0000' num2str(beeldnr)];
orig=imread(['Adam1B_1/Frame' name(length(name)-4:length(name)) '.png']);
name=['0000' num2str(beeldnr+1)];
next=imread(['Adam1B_1/Frame' name(length(name)-4:length(name)) '.png']);
%cd matchresults
s1=size(orig,1);s2=size(orig,2);
%Je neem nu van ieder vierkantje het gemiddelde, en beschouwt al die gemiddelden als data waarvan je de variantie berekent
%Je berekent die van negen vierkanten en kiest het vierkant met de
%grootste variantie.
%blokje=next(368:368+399,421:421+617);
blokje=next(31:s1-30,31:s2-30);
for ver=1:60
    for hor=1:60
        mask=double(orig(ver:s1-60+ver,hor:s2-60+hor))-double(blokje);
    end
end


mask=matchblok>0;
centre=imrotate(centreindicator,theta);
[cv,ch]=find(centre,1,'first');
origblok=double(mask).*double(orig(ORIGINver-cv+1:ORIGINver-cv+bv,ORIGINhor-ch+1:ORIGINhor-ch+bh,:));

sse(index,1)=sum(sum(sum((double(matchblok)-origblok).*(double(matchblok)-origblok))))/sum(mask(:));
sse(index,2)=theta;
sse(index,3)=transv;
sse(index,4)=transh;
index=index+1;



