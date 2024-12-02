function JIHmaker(START,STEP,EIND)
%je maakt in deze functie de JIH's van START en START+1 etc.
index=1;
cd images
distmeasures=zeros(3000,5)+1;
first=imread(['Frame' num2str(START) '.bmp'])+1;
for beeld=START:STEP:EIND
    [beeld START STEP EIND]
    second=imread(['Frame' num2str(beeld+1) '.bmp'])+1;
    avgfirst=double((first(:,:,1)+first(:,:,2)+first(:,:,3))/3);
    avgsecond=double((second(:,:,1)+second(:,:,2)+second(:,:,3))/3);
    histfirst=hist(avgfirst(:),256)+1;
    histsecond=hist(avgsecond(:),256)+1;
    redhist=ones(256);
    greenhist=ones(256);
    bluehist=ones(256);
    for ver=1:1080
        for hor=1:1440
            redhist(first(ver,hor,1),second(ver,hor,1))=redhist(first(ver,hor,1),second(ver,hor,1))+1;
            greenhist(first(ver,hor,2),second(ver,hor,2))=greenhist(first(ver,hor,2),second(ver,hor,2))+1;
            bluehist(first(ver,hor,3),second(ver,hor,3))=bluehist(first(ver,hor,3),second(ver,hor,3))+1;
        end
    end
    distmeasures(index,1)=beeld;
    distmeasures(index,2)=sum(histsecond.*log(histsecond./histfirst));
    
    MIr=0;MIg=0;MIb=0;
    prhor=zeros(1,256);
    prver=zeros(1,256);
    pghor=zeros(1,256);
    pgver=zeros(1,256);
    pbhor=zeros(1,256);
    pbver=zeros(1,256);
    for ver=1:256
        prhor(ver)=sum(redhist(ver,:));
    end
    for hor=1:256
        prver(hor)=sum(redhist(:,hor));
    end
    for ver=1:256
        pghor(ver)=sum(greenhist(ver,:));
    end
    for hor=1:256
        pgver(hor)=sum(greenhist(:,hor));
    end
    for ver=1:256
        pbhor(ver)=sum(bluehist(ver,:));
    end
    for hor=1:256
        pbver(hor)=sum(bluehist(:,hor));
    end
    for ver=1:256
        for hor=1:256
            MIr=MIr+redhist(ver,hor)*log(redhist(ver,hor)/max((prhor(ver)*prver(hor)),.0001));
            MIg=MIg+greenhist(ver,hor)*log(greenhist(ver,hor)/max((pghor(ver)*pgver(hor)),.0001));
            MIb=MIb+bluehist(ver,hor)*log(bluehist(ver,hor)/max((pbhor(ver)*pbver(hor)),.0001));
        end
    end

    distmeasures(index,3)=MIr;
    distmeasures(index,4)=MIg;
    distmeasures(index,5)=MIb;
    index=index+1;
    cd ../histograms
    %if mod(index,500)==0
    save(['dist-' num2str(START) '-' num2str(EIND)],'distmeasures')
    %end
    save(['hists-' num2str(beeld) '-' num2str(beeld+1)],'redhist','greenhist','bluehist');
    cd ../images
    first=second;
end
cd ../histograms
save(['dist-' num2str(START) '-' num2str(EIND)],'distmeasures')
cd ..

