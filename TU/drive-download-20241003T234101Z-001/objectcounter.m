begin=11002;
eind=12201;
for beeldnr=begin:eind
    [beeldnr begin eind]
    name=['00000000' num2str(beeldnr)];
    baseblobs=imread(['diff3A_3/' name(length(name)-8:length(name)) '.png']);
    baseblobnummers=bwlabel(baseblobs);
    %nu gaan we de objectnummers toekennen
    objecttabel=zeros(max(baseblobnummers(:)),4);
    objecttabel(:,1)=(1:max(baseblobnummers(:)))';
    if beeldnr==begin
    	objecttabel(:,2)=(1:max(baseblobnummers(:)))';
        for currentblob=1:max(baseblobnummers(:))
            [pver,phor]=find(baseblobnummers==currentblob);
            objecttabel(currentblob,3)=mean(pver);
            objecttabel(currentblob,4)=mean(phor);
        end
        oindex=max(baseblobnummers(:))+1;
    else
        name=['00000000' num2str(beeldnr-1)];
        previousblobs=imread(['diff3A_3/' name(length(name)-8:length(name)) '.png']);
        name=['00000000' num2str(beeldnr)];
        baseblobs=imread(['diff3A_3/' name(length(name)-8:length(name)) '.png']);

        baseblobnummers=bwlabel(baseblobs);
        previousblobnummers=bwlabel(previousblobs);
        tempbasetabel=zeros(max(baseblobnummers(:)),3);
        basetabel=zeros(max(baseblobnummers(:)),2);
        tempbasetabel(:,1)=1:max(baseblobnummers(:));
        tempprevioustabel=zeros(max(baseblobnummers(:)),2);
        for currentblob=1:max(baseblobnummers(:))
            [beeldnr begin eind currentblob max(baseblobnummers(:))]
            [pver,phor]=find(baseblobnummers==currentblob);
            objecttabel(currentblob,3)=mean(pver);
            objecttabel(currentblob,4)=mean(phor);
            mmal=(baseblobnummers==currentblob);
            for previousblob=1:max(previousblobnummers(:))
                pixelcount=sum(sum(mmal&(previousblobnummers==previousblob)));
                if pixelcount>tempbasetabel(currentblob,3)%hier wordt de blob uit het voorgaande frame waarmee de grootste overlap is gekozen
                    tempbasetabel(currentblob,2)=previousblob;
                    tempbasetabel(currentblob,3)=pixelcount;
                end
            end
        end
        
        
        previousmatches=tempprevioustabel(:,1);
        pc=tempprevioustabel(:,2);
        v=sort(previousmatches);
        w=find(([1;diff(v)]==0));%als er meer blobs zijn die met dezelfde blob uit het voorgaande frame corresponderen, wordt nu alleen die met 
        %de grootste overlap als de echte opvolger uitgekozen; alle andere blobs
        %hebben dan geen voorganger meer.
        for teller=1:length(w)
            if v(w(teller))>0
                reps=previousmatches==v(w(teller));
                x=reps.*pc;
                peak=find(x==max(x),1,'first');
                reps(peak)=0;
                previousmatches(reps)=0;%alle occurrences behalve die van de grootste overlap zijn nu =0
            end
        end%previousmatches is tempprevioustabel zonder herhalingen
        
        %nu hebben we dus een vector waarop de plaats van iedere blob uit het
        %huidig frame het blobnummer staat van de blob uit het vorige frame
        %waar het mee correspondeert
        for currentblob=1:max(baseblobnummers(:))
            if previousmatches(currentblob)==0
                objecttabel(currentblob,2)=oindex;
                oindex=oindex+1;
            else objecttabel(currentblob,2)=objectnrsprevious(previousmatches(currentblob));
            end
        end
    end
    name=['0000' num2str(beeldnr)];
    save(['diff3A_3/BBobjects' name(length(name)-4:length(name)) '.mat'],'objecttabel')
    previousblobnummers=baseblobnummers;
    objectnrsprevious=objecttabel(:,2);
end
           