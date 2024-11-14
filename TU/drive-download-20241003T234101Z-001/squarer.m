%maakt vierkantjes op de plaats van de blobs
for beeldnr=23:88
    [beeldnr 88]
    orig=imread(['R0000000' num2str(beeldnr) '.png']);
    plat=orig(:,:,1)|orig(:,:,2)|orig(:,:,3);
    plat=bwlabel(plat);
    result=zeros(round(double(size(orig,1))/2),round(double(size(orig,2))/2),3);
    %result=zeros(round(double(size(orig,1))),round(double(size(orig,2))),3);
    for region=1:max(plat(:))
        blob=plat==region;
        top=find(sum(blob,2),1,'first');
        bottom=find(sum(blob,2),1,'last');
        left=find(sum(blob,1),1,'first');
        right=find(sum(blob,1),1,'last');
        o1=orig(:,:,1);cr=max(max(o1(blob)));
        o2=orig(:,:,2);cg=max(max(o2(blob)));
        o3=orig(:,:,3);cb=max(max(o3(blob)));
        top=uint16(round(double(top)/2));
        bottom=uint16(round(double(bottom)/2));
        left=uint16(round(double(left)/2));
        right=uint16(round(double(right)/2));
        for p=left:right
            result(top,p,1)=cr;
            result(top+1,p,1)=cr;
            result(bottom-1,p,1)=cr;
            result(bottom,p,1)=cr;
            result(top,p,2)=cg;
            result(top+1,p,2)=cg;
            result(bottom-1,p,2)=cg;
            result(bottom,p,2)=cg;
            result(top,p,3)=cb;
            result(top+1,p,3)=cb;
            result(bottom-1,p,3)=cb;
            result(bottom,p,3)=cb;
        end
        for p=top:bottom
            result(p,left,1)=cr;
            result(p,left+1,1)=cr;
            result(p,right-1,1)=cr;
            result(p,right,1)=cr;
            result(p,left,2)=cg;
            result(p,left+1,2)=cg;
            result(p,right-1,2)=cg;
            result(p,right,2)=cg;
            result(p,left,3)=cb;
            result(p,left+1,3)=cb;
            result(p,right-1,3)=cb;
            result(p,right,3)=cb;
        end
    end
    imwrite(uint8(result),['S' num2str(beeldnr) '.png'],'png');
 end
