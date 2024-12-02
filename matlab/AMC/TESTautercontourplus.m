for directorynr=43:50;%de buitenste for-loop. 
    sizevenster=410;
    disp(directorynr)   
    tic
    directory=['anoniem' num2str(directorynr)];%hier wordt de namen van de gebruikte directories gemaakt....zijn die nog goed?
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(directory,'Ttops');%hier wordt de directory aangemaakt waarin de resultaten worden weggeschreven (niet meer nodig in uiteindelijke versie).
    directorycontent=dir([directory '/origs/*']);%hier wordt een ls gedaan van de inhhoud van de map. Zo worden dus automatisch alle files in die directory bewerkt.
    for beeld=1:length(directorycontent)-2%de eerste twee regels van die automatisch gegenereerde directory zijn . en ..
        if beeld < 10
            naam=['000' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['00' num2str(beeld)];
        else naam=['0' num2str(beeld)];
        end
        if mod(beeld,100)==0%dit is slechts om een beetje bij te houden waar je bent, kan dus weg.
            disp([directorynr beeld length(directorycontent)])
        end
        readname=directorycontent(beeld+2).name;%de naam van de file die je inleest
        writename=['plot' naam '.png'];%de naam waaronder je het resulterende plaatje met grafiek en afgelijnde tafel wegschrijft.
        savename=['contour' naam '.mat'];
        load ([directory '/origs/' readname]);% laad het beeld
        image=double(image);
        lb=round(sum(sum(image(1:10,1:10)))/100);
        mask=image>lb;%zoals bekend kijken we alleen naar data binnen de scancirkel.
        if sum(mask(3,:))>0%de scancirkel moet het hele beeld beslaan; in beelden waar dat niet het gaval is, zijn ook geen manuele segmentaties gedaan.
            histandplot=figure('visible','off');%dit is alleen om het figuur weg te kunnen schrijven. Voor de werkign van het filter dus onnodig.
            readname=directorycontent(beeld+2).name;%de naam van de file die je inleest
            writename=['plot' naam '.png'];%de naam waaronder je het resulterende plaatje met grafiek en afgelijnde tafel wegschrijft.
            load ([directory '/origs/' readname]);%laad het beeld
            image=double(image);
            %het originel dicom beeld wordt geladen. Er zijn hier al uint16s van
            %gemaakt.
            image=double(image(:,:,1));
            ORIGimage=image;
            realimage=sort(image(:));
            %de buitenste cirkel wordt weggehaald voor het maken van de histogram
            lb=find(realimage>round(sum(sum(image(1:10,1:10)))/100),1,'first');
            image=realimage(lb:length(realimage));
            %de outliers naar boven worden eruit gehaald
            image=min(image,mean(image)+2.5*std(image));
            [histogram,centers]=hist(image);
            subplot(1,2,1);
            %het tekenen van de histogram zelf
            bar(centers,histogram), hold on
            title(['Image ' naam])
            axis([min(image) max(image) 0 max(histogram)])
            
            
            bhistogram=zeros(1,length(histogram)+2);
            bhistogram(2:length(histogram)+1)=histogram;
            %het vinden van de twee pieken
            %topvalue='f';
            %histpeaks=zeros(1,length(histogram));
            %for t=2:length(bhistogram)-1
            %    if bhistogram(t-1)<bhistogram(t) && bhistogram(t)>bhistogram(t+1)
            %        histpeaks(t-1)=bhistogram(t);
                    %if topvalue=='f'
                    %    fpos=t-1;
                    %    topvalue='l';
                    %else lpos=t-1;
                    %end
            %    end
            %end
            fhistpeaks=histogram;%histpeaks;
            fhistpeaks(centers>=mean(centers))=0;
            fpos=find(fhistpeaks==max(fhistpeaks),1,'last');
            lhistpeaks=histogram;%histpeaks;
            lhistpeaks(centers<mean(centers))=0;
            lpos=find(lhistpeaks==max(lhistpeaks),1,'first');
            %peakpos=zeros(1,2);
            %for teller=1:2
            %    presentpeak=max(histpeaks);
            %    peakpos(teller)=find(histpeaks==presentpeak);
            %    histpeaks(peakpos(teller))=0;
            %end
            %fpos=min(peakpos)-1;
            %lpos=max(peakpos)-1;
            %het plotten van de rode lijntjes
            plot([centers(fpos);centers(fpos)],[0;max(bhistogram)],'r:')
            plot([centers(lpos);centers(lpos)],[0;max(bhistogram)],'r:')
            %HET BEPALEN VAN DE THRESHOLD
            %threshold=(centers(fpos)+centers(lpos))/2;
            threshold=centers(find(bhistogram(fpos+1:lpos+1)==min(bhistogram(fpos+1:lpos+1)),1,'first')-1+fpos);%de threshold is nu dus het minimum tuseen de pieken
            plot([threshold;threshold],[0;max(bhistogram)],'b:')
            a=ORIGimage;
            a=min(a,mean(a(:))+2.5*std(a(:)));
            %a=uint8(a*255/max(a(:)));
            ARTICLEorig=a;
            edges=edge(a,'sobel',[],'thinning');
            ARTICLEedges=edges;
            v=sum(edges,2);
            tableedge=find(v==max(v),1,'first');
            topedge=tableedge;%die '9' hebben we experimenteel gevonden.
            edges(topedge:size(ORIGimage,1))=0;
            numedges=bwlabel(edges,8);
            mask=ORIGimage>threshold;
            %mask2=mask;
            mask(topedge:size(mask,1),:)=0;
            %imwrite(mask,'Traw.png','png')
            mask=imfill(mask,4,'holes');
            %imwrite(mask,'Tmask.png','png')
            %bepalen van de outercontour
            body=bwperim(mask);
            %opvullen eventuele losse puntjes of eilandjes, zodat je echt een solide rand krijgt 
            %Ik denk inderdaad dat het voldoende is te kijken of de horizontale lijn
            %die er al ligt lang genoeg is, en je dan gewoon de hele lijn moet trekken
            opvuller=mask-body;
            [regions,n_o_regions]=bwlabel(opvuller,4);
            %imwrite(regions,'Tregions.png','png')
            regionsizes=zeros(n_o_regions,1);
            for t=1:n_o_regions
                regionsizes(t)=sum(sum(regions==t));
            end
            for ver=1:size(body,1)
                for hor=1:size(body,2)
                    if regions(ver,hor)~=0 && regions(ver,hor)~=find(regionsizes==max(regionsizes),1,'first')
                        body(ver,hor)=1;
                    end
                end
            end
            %alleen randpixels overlaten die echt aan het binnengebied grenzen.
            body2=imfill(body,4,'holes');
            body2=body2-body;
            body3=zeros(size(body,1)+2,size(body,2)+2);
            body3(2:size(body,1)+1,2:size(body,2)+1)=body2;
            for ver=1:size(body,1)
                for hor=1:size(body,2)
                    if body(ver,hor)==1
                        if sum(body3(ver:ver+2,hor+1))+sum(body3(ver+1,hor:hor+2))==0
                            body(ver,hor)=0;
                        end
                    end
                end
            end
            ARTICLEwrong=body;
            %imwrite(ARTICLEwrong,'Tinitialcontour.png','png')
            %imwrite(numedges>0,'Tedges.png','png')
            %variabelen die de tweede keer anders moeten:
            for innerouter=1:1
                %stukken sobelcontour vinden die autercontour echt doorkruisen
                if innerouter==1
                    mask2=imfill(body,4,'holes');
                else mask2=imfill(body,[1 1],4);
                end
                numedges=numedges.*mask2;
                %imwrite(numedges,'Tcrossedges.png','png')
                %imwrite(cat(3,255*(numedges|body),255*xor((body|numedges),numedges),255*xor((body|numedges),numedges)),'Tcontourandedges.png','png')
                whichcontours=unique(numedges.*body);
                crossedges=zeros(size(edges,1),size(edges,2));
                for t=2:length(whichcontours)
                    crossedges=crossedges|(numedges==whichcontours(t));
                end
                combcontour=body+2*crossedges;
                %alle uiteinden bepalen
                %eerst alle stukken sobelcontour die precies op outercontour liggen
                %(dwz geen enkele 2 in de buurt hebben)
                %verwijderen,
                combcontour2=zeros(2+size(combcontour,1),2+size(combcontour,2));
                combcontour2(2:1+size(combcontour,1),2:1+size(combcontour,2))=combcontour;
                for ver=1:size(combcontour,1)
                    for hor=1:size(combcontour,2)
                        if combcontour(ver,hor)==3
                            if max(max(combcontour2(ver:ver+2,hor:hor+2)==2))==0
                                combcontour(ver,hor)=1;
                                combcontour2(ver+1,hor+1)=1;
                            end
                        end
                    end
                end
                %nu een uiteinde maken aan alle sobelstukken
                %merk op dat de lijnen gladjes verondersteld worden, dus dat dit volgens
                %mij niet lukt met alleen de horizontale sobeloperator!
                clockwise=[-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
                currentcrosspoint=3;
                nextcrosspoint=7;
                pixelchanged=1;
                while pixelchanged==1
                    pixelchanged=0;
                    for ver=1:size(combcontour,1)
                        for hor=1:size(combcontour,2)
                            if combcontour(ver,hor)==currentcrosspoint
                                %nu hebben we het beginpunt van een of meer contourstukken te pakken en
                                %gaan we het lijnstuk af op zoek naar eindpunten
                                opweg=1;
                                while opweg==1
                                    v=ver;h=hor;
                                    t=1;
                                    flag=0;
                                    opweg=0;
                                    while flag==0
                                        if combcontour2(v+1+clockwise(t,1),h+1+clockwise(t,2))==2
                                            combcontour(v+clockwise(t,1),h+clockwise(t,2))=4;
                                            combcontour2(v+1+clockwise(t,1),h+1+clockwise(t,2))=4;
                                            if opweg==0
                                              combcontour(v,h)=nextcrosspoint;
                                              combcontour2(v+1,h+1)=nextcrosspoint;
                                              pixelchanged=1;
                                            end
                                            v=v+clockwise(t,1);h=h+clockwise(t,2);
                                            t=1;
                                            opweg=1;
                                        elseif combcontour2(v+1+clockwise(t,1),h+1+clockwise(t,2))==currentcrosspoint && opweg==1
                                            combcontour(v+clockwise(t,1),h+clockwise(t,2))=nextcrosspoint;
                                            combcontour2(v+1+clockwise(t,1),h+1+clockwise(t,2))=nextcrosspoint;
                                            pixelchanged=1;
                                            flag=1;
                                        else t=t+1;
                                        end
                                        if t==9
                                            if opweg==1
                                                combcontour(v,h)=5;
                                                combcontour2(v+1,h+1)=5;
                                            end
                                            flag=1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if pixelchanged==1
                       currentcrosspoint=nextcrosspoint;
                       nextcrosspoint=nextcrosspoint+1;
                    end
                end
                %nextcrosspoint
                %imwrite(combcontour,'Tcombcontour.png','png')
                %nu voor ieder uiteinde het dichtstsbijzijnde punt bepalen en die verbinden
                [vu,hu]=find(combcontour==5);
                [va,ha]=find(combcontour==1);
                pairs=zeros(length(vu),4);pairs(:,1)=vu;pairs(:,2)=hu;
                for t=1:length(vu)
                    vtot=(cat(1,vu,va)-vu(t)).*(cat(1,vu,va)-vu(t))+(cat(1,hu,ha)-hu(t)).*(cat(1,hu,ha)-hu(t));
                    vtot=vtot+max(vtot)*(vtot==0);
                    index=find(vtot==min(vtot),1,'first'); 
                    if index>length(vu)
                        pairs(t,3)=va(index-length(vu));
                        pairs(t,4)=ha(index-length(vu));
                    else pairs(t,3)=vu(index);
                        pairs(t,4)=hu(index);
                    end
                end
                %teken rechte lijnen
                for t=1:length(vu)
                    for lijn=0:100
                        v=floor((pairs(t,3)-pairs(t,1))*lijn/100+pairs(t,1));
                        h=floor((pairs(t,4)-pairs(t,2))*lijn/100+pairs(t,2));
                        combcontour(v,h)=4;
                        combcontour2(v+1,h+1)=4;
                    end
                end
                %imwrite(combcontour>0,'Trechtelijnen.png','png')
                %alleen randpixels overlaten die echt aan het binnengebied grenzen.
                if innerouter==1
                    tussen=combcontour>0;
                    innerregion=xor(combcontour>0,imfill(combcontour>0,[round(size(combcontour,1)/2) round(size(combcontour,2)/2)],4));
                else innerregion=xor(combcontour>0,imfill(combcontour>0,[1 1],4));
                    tussen=combcontour>0;
                end
                innerregion2=zeros(size(combcontour,1)+2,size(combcontour,2)+2);
                innerregion2(2:size(body,1)+1,2:size(body,2)+1)=innerregion;
                for ver=1:size(combcontour,1)
                    for hor=1:size(combcontour,2)
                        if combcontour(ver,hor)>0
                            if sum(innerregion2(ver+1,hor:hor+2))+sum(innerregion2(ver:ver+2,hor+1))==0
                                combcontour(ver,hor)=0;
                            end
                        end
                    end
                end
                %nu de hele rimram nog eens maar dan voor sobelcontourstukken die buiten de autercontour vallen
                %body=combcontour>0;
            end
            ARTICLEright=combcontour;
            %imwrite(ARTICLEright,'Tarticleright.png','png')
            %overgebleven contour op originele beeld plakken
            a=ORIGimage;
            a=min(a,mean(a(:))+2.5*std(a(:)));
            subplot(1,2,2)
            %tekenen van de outercontour op beeld
            imshow(uint8(a*255/max(a(:))+double(combcontour>0)*255));
            %imshow(uint8(a*255/max(a(:))+double(edges)*255))
            %imshow(edges)
            title(['Image ' naam]);
            hold off
            saveas(histandplot,[directory '/Ttops/' writename],'png');%dit is allemaal plotterij die weg kan
            close(histandplot);%dit is allemaal plotterij die weg kan
            BINcontour=combcontour>0;
            save([directory '/Ttops/' savename],'BINcontour');
            %c=uint8(a*255/max(a(:)));c(tableedge,:)=255;figure,imshow(c)
        end
        keep('directorynr','sizevenster','directory','directorycontent')
    end
    toc
    %keep('directorynr')
end