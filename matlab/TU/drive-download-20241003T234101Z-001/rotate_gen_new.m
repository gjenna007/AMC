%rotate_gen
%basebeeld=1;
%begin=2;
%eind=13973;
%data_naam='3B_1';
fid=fopen('../inputvariabelen_final.txt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    eval(tline)
end
fclose(fid);
name=['00000000' num2str(basebeeld)];name=name(length(name)-8:length(name));
eval(cIMAGE);
orig=imread(IMAGE);
s1=size(orig,1);s2=size(orig,2);
vw=MATCHVENSTERSIZE_VER;hw=MATCHVENSTERSIZE_HOR;
ORIGINver=round(s1/2);ORIGINhor=round(s2/2);%DE OORSPRONG VAN ALLE TRANSLATIES EN ROTATIES
if begin==basebeeld+1
    theta_old=0;transv_old=0;transh_old=0;
else sse=zeros(1,4);
     name=['00000000' num2str(begin-1)];name=name(length(name)-8:length(name));
     eval(cSAVEIMAGE);
     load (SAVEIMAGE)
     theta_old=sse(2);transv_old=sse(3);transh_old=sse(4);
end
for beeldnr=begin:eind
    name=['00000000' num2str(beeldnr)];name=name(length(name)-8:length(name));
    eval(cIMAGE);
    next=imread(IMAGE);
    origblok=double(next(ORIGINver-vw:ORIGINver+vw,ORIGINhor-hw:ORIGINhor+hw));
    sse=zeros(1,4);
    index=-1;
    for theta=mintheta:steptheta:maxtheta
            [beeldnr begin theta]
        mask=imrotate(orig,theta+theta_old,'bilinear','crop');
        for transv=mintransv:maxtransv
            for transh=mintransh:maxtransh
                matchblok=double(mask(ORIGINver-vw+transv+transv_old:ORIGINver+vw+transv+transv_old,ORIGINhor-hw+transh+transh_old:ORIGINhor+hw+transh+transh_old));
                minvalue=sum(sum((matchblok-origblok).*(matchblok-origblok)));
                if (index==-1 || minvalue<index)
                    sse(1)=minvalue;
                    sse(2)=theta+theta_old;
                    sse(3)=transv+transv_old;
                    sse(4)=transh+transh_old;
                    index=minvalue;
                    %%%%%%%%%%%%%%%%%%%%%%%%
                    %mb=matchblok;
                    %ob=origblok;
                    %%%%%%%%%%%%%%%%%%%%%%%%%
                end
            end
        end
    end
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
    eval(cWRITEIMAGE);
    imwrite(imrotate(cropped,-sse(2),'bilinear','crop'),WRITEIMAGE,'png');
    %imwrite(uint8(mb),[WRITEIMAGE 'matchblok'],'png');
    %imwrite(uint8(ob),[WRITEIMAGE 'origblok'],'png');
    eval(cSAVEIMAGE);
    save(SAVEIMAGE,'sse','vw','hw')
    theta_old=sse(2);transv_old=sse(3);transh_old=sse(4);
end