function framerepairer(basebeeld,begin,eind)
%basebeeld=1;
%begin=2;
%eind=13973;
data_naam='3A_3';
for beeldnr=begin:eind
    beeldnr
    name=['00000000' num2str(beeldnr)];name=name(length(name)-8:length(name));
    next=imread(['Adam' data_naam '/' data_naam ' ' name '.tif']);
    s1=size(next,1);s2=size(next,2);
    load (['matchresults' data_naam '/' num2str(basebeeld) '-' name])
    cropped=next;
    if sse(3)>0
        cropped=cat(1,zeros(sse(3),s2),cropped(1:s1-sse(3),:));
    end
    if sse(3)<0
        cropped=cat(1,cropped(1-sse(3):s1,:),zeros(-sse(3),s2));
    end
    if sse(4)>0
        cropped=cat(2,zeros(s1,sse(4)),cropped(:,1:s2-sse(4)));
    end
    if sse(4)<0
        cropped=cat(2,cropped(:,1-sse(4):s2),zeros(s1,-sse(4)));
    end
    imwrite(imrotate(cropped,-sse(2),'bilinear','crop'),['fillupmatchresults' data_naam '/' num2str(basebeeld) '-' name '.png'],'png');
 end