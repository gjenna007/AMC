%We nemen een venster van 7*29=203
%global VENSTERSIZE 
VENSTERSIZE=201;
basebeeld=1;
begin=2;
eind=2;
data_naam='3B_1';
name=['00000000' num2str(basebeeld)];name=name(length(name)-8:length(name));
orig=imread(['Adam' data_naam '/' data_naam ' ' name '.tif']);
if begin==basebeeld+1
    theta_old=0;transv_old=0;transh_old=0;
else sse=zeros(1,4);
     name=['00000000' num2str(begin-1)];name=name(length(name)-8:length(name));
     load (['matchresults' data_naam '/' num2str(basebeeld) '-' name])
     theta_old=sse(2);transv_old=sse(3);transh_old=sse(4);
end
for beeldnr=begin:eind
    name=['00000000' num2str(beeldnr)];name=name(length(name)-8:length(name));
    next=imread(['Adam' data_naam '/' data_naam ' ' name '.tif']);
    sse=zeros(1,4)';
    index=-1;
    v=[];
    for theta=-0.2:0.1:-0.2
            [beeldnr begin theta]
        baseimage=imrotate(orig,theta+theta_old,'bilinear');
        %s1=ceil(size(baseimage,1)/2);s2=ceil(size(baseimage,2)/2);
        disp('variantie:')
        tic
        matchblok=variantie(baseimage,VENSTERSIZE);%moet ik nog nagaan, maar wil ik best geloven
        figure,imshow(matchblok)
        imwrite(uint8(matchblok),['matchresults' data_naam '/' num2str(basebeeld) '-' num2str(theta) '-' name '.png'],'png');
        toc
        disp('SSE:')
        tic
        transl=SSE(next,matchblok,VENSTERSIZE);%transl(2) and transl(3) zijn nu gewoon de coordinaten in next
        toc
        v=cat(1,v,[transl(1) theta transl(2) transl(3)]);
    end
    w=v(:,1); goodmatch=find(w==min(w),1,'first');
    theta_old=theta_old+v(goodmatch,2);
    tempimage=cutwith(next,v(goodmatch,3),v(goodmatch,4));%nakijken of dit echt *precies* goed gaat
    result=imrotate(tempimage,-theta_old,'bilinear');
    %r1=ceil(size(result,1)/2);r2=ceil(size(result,2)/2);
    result=cutaround(result,v(goodmatch,3),v(goodmatch,4),size(orig,1),size(orig,2));
    figure,imshow(result)
    imwrite(uint8(result),['matchresults' data_naam '/' num2str(basebeeld) '-' name '.png'],'png');
    save(['matchresults' data_naam '/' num2str(basebeeld) '-' name '.mat'],'v')
end