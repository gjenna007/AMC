for directorynr=1:1%de buitenste for-loop. Hier bewerk ik de beelden nog maar 1 keer, ik moet dus nog die tweede loop uitvoeren om uitschieters eruit te halen  
    sizevenster=410;
    disp(directorynr)   
    tic
    directory=['anoniem' num2str(directorynr)];%hier wordt de namen van de gebruikte directories gemaakt....zijn die nog goed?
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(directory,'tabletops');%hier wordt de directory aangemaakt waarin de resultaten worden weggeschreven (niet meer nodig in uiteindelijke versie).
    directorycontent=dir([directory '/origs/*']);%hier wordt een ls gedaan van de inhhoud van de map. Zo worden dus automatisch alle files in die directory bewerkt.
    alltops=zeros(length(directorycontent)-2,2);
    alltops(:,2)=(1:length(directorycontent)-2)';%de tweede entry is het beeldnummer, de eerste entry is de positie van het tafelblad in dit beeld
    for beeld=1:length(directorycontent)-2%de eerste twee regels van die automatisch gegenereerde directory zijn . en ..
        if beeld < 10
            naam=['000' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['00' num2str(beeld)];
        else naam=['0' num2str(beeld)];
        end
        readname=directorycontent(beeld+2).name;%de naam van de file die je inleest
        writename=['plot' naam '.png'];%de naam waaronder je het resulterende plaatje met grafiek en afgelijnde tafel wegschrijft.
        load ([directory '/origs/' readname]);%laad het beeld
        image=double(image);
        lb=round(sum(sum(image(1:10,1:10)))/100);
        mask=image>lb;%zoals bekend kijken we alleen naar data binnen de scancirkel.
        if sum(mask(3,:))>0%de scancirkel moet het hele beeld beslaan; in beelden waar dat niet het gaval is, zijn ook geen manuele segmentaties gedaan.
            image=image.*double(mask);
            realimage=sort(image(:));
            startrealscan=find(realimage>0,1,'first');
            realimage=realimage(startrealscan:length(realimage));
            image=min(image,mean(realimage)+3.5*std(realimage));%de hoogste pieken worden uit het beeld verwijderd.
            verbody=sum(image,2);
            da=min(0,diff(verbody));
            da(length(da))=0;%je moet zorgen dat hij het laatste dieptepunt (van bv de onderste tafelrand ook meeneemt)
            
            minima=zeros(length(da),2);%hier wordt een matrix aangemaakt waarine de plaats van de piekn en hun diepte opgeslagen gaat worden
            minima_index=1;
            for counter=1:length(da)-2
                if da(counter)>da(counter+1) && da(counter+1)<da(counter+2)%hier worden de echte pieken geidentificeerd
                    minima(minima_index,1)=da(counter+1);%de waarde van de diepte van de piek
                    minima(minima_index,2)=counter+1;%de plaats waar de piek zich bevindt.
                    minima_index=minima_index+1;
                end 
            end
            minima=minima(1:minima_index-1,:);%de vector wordt op de juiste lengte afgeknipt
            minima=-sortrows(-minima,1);%de waarden van de minima wroden gesorteerd van groot (i.e., minst negatief) naar klein 
            threshold=min(minima(:,1))/5;%een dremplewaarde om alle onbetekenende pieken over te slaan.
            deepestpoints=zeros(size(minima,1),1);%deepestpoints zijn de locaties van alle minima die onder de threshold liggen
            for counter=size(minima,1):-1:1
                if minima(counter,1)<threshold
                    deepestpoints(counter)=minima(counter,2);%hier wordt de locatie van de paar allerdiepste pieken geidentificeerd.
                end
            end
            deepestpoints=sort(deepestpoints,'descend');%alle locatie zijn positieve nummers, dus alle 0-en komen nu achteraan;
            deepestpoints=deepestpoints(1:find(deepestpoints==0,1,'first'));%deepestpoints wordt op de juiste lengte afgeknipt
            n_o_peaks=min(5,length(deepestpoints));%ten hoogste de vijf diepste pieken worden bekeken
            tabletop=zeros(uint8((n_o_peaks*(n_o_peaks-1))/2),2);
            tabletop2=zeros(size(tabletop,1),2);
            flag_tabletop2=1;%eerst alle horizontale lijnen vinden die aan criterium1 voldoen
            if n_o_peaks>2%als er maar twee pieken zijn, dan is er geen keus :-)
                while flag_tabletop2
                    index1=1;
                    tabletop=zeros(uint8((n_o_peaks*(n_o_peaks-1))/2),2);
                    flag_tabletop=1;
                    while flag_tabletop
                        for counter1=1:n_o_peaks-1%hier worden alle lijnen paren gezocht die ong. 30 rijen uit elkaar liggen.
                            for counter2=counter1+1:n_o_peaks
                                if deepestpoints(counter1)-deepestpoints(counter2)>=27 && deepestpoints(counter1)-deepestpoints(counter2)<=33
                                    tabletop(index1,1)=deepestpoints(counter1);%tabletop bevat nu al die paren
                                    tabletop(index1,2)=deepestpoints(counter2);
                                    index1=index1+1;
                                    flag_tabletop=0;
                                end
                            end
                        end
                        if flag_tabletop%als er geen enkel paar aan het criterium voldoet, dan nemen we er een zesde piek bij en gaan opnieuw zoeken
                            n_o_peaks=n_o_peaks+1;
                            tabletop=zeros(uint8((n_o_peaks*(n_o_peaks-1))/2),2);
                        end
                    end

                    %dan de horizontale lijnenparen selecteren die aan criterium2 voldoen
                    index2=1;
                    tabletop2=zeros(size(tabletop,1)+1,2);
                    for counter3=1:size(tabletop,1)%hier verwachten we dat het gebied boven het tafelblad lichter is dan dat tussen de tafelgrenzen
                        between=sum(verbody(tabletop(counter3,2)+1:tabletop(counter3,1)-1));%je maakt hier gebruik dan het feit dat de meeste hulpstukken niet zo dik zijn.
                        above=sum(verbody(2*tabletop(counter3,2)-tabletop(counter3,1)+1:tabletop(counter3,2)-1));
                        if above >= 1.2*between%het dubbele zal wel een goed criterium zijn
                            tabletop2(index2,1)=tabletop(counter3,1);%tabletop2 bevat alle paren uit tabletop met juiste grijswaardeverdeling van de omgeving
                            tabletop2(index2,2)=tabletop(counter3,2);
                            flag_tabletop2=0;%tabletop2 kan dus nooit meer groter worden dan we hem aan het begin van deze for-loop gemaakt hebben
                            index2=index2+1;
                        end
                    end
                    tabletop2=tabletop2(1:find(tabletop(:,1)~=0,1,'last'),:);
                end%dit is de while loop waarin de twee criteria (lichter gebied boven het tafelblad dan ertussen) als selectie gebruikt worden.
            tabletop3=find(verbody==max(verbody),1,'last');%hier bepalen we het breedste deel van het lichaam.
            counter4=find(tabletop2(:,1)-tabletop3==min(tabletop2(:,1)-tabletop3),1,'first');%hier zoeken we het paar uit tabletop2 dat het dichtst bij het breedste deel van het lichaam ligt
            %tabletop2(counter4,1) is de bovenste table top!
            %tabletop2(counter4,2) is de onderste table top!
            end
        alltops(beeld,1)=tabletop2(counter4,1);%hier worden alle tabletopposities verzameld
        end%if-loop; als de scancirkel niet het hele beeld beslaat doen we niets, en gaan verder met de volgende file.
    end%de loop die alle beelden in de directory afgaat
    %Hier moeten we nu die mediaantruc uit gaan voeren
    alltops=sortrows(alltops,1);%de beelden die niet gebruikt zijn, werden niet ingevuld,en bevatten dus nullen in de eerste entry 
    borderval=find(alltops(:,1),1,'first');%wat is de eerste entry die ~=0 is?
    alltops=alltops(borderval:size(alltops,1),:);%nu worden die nullen (i.e., de  niet gebruikte beelden) ervan afgeknipt
    realtoppos=median(alltops(:,1));% dit is die beruchte mediaan van alle tabletop posities die we zoeken
    faultimages=unique(abs((alltops(:,1)-realtoppos)>3).*alltops(:,2));%de beeldnummers van de beelden die echt verkeerd geinterpreteerd zijn
    if length(faultimages)>1%dwz als er beelden zijn waar de tafel meer dan 3 pixels afwijkt
        %dan doen we de hele reutemeteut speciaal voor die uitzonderingen
        %over
        
        for hulpbeeld=2:length(faultimages)
            beeld=faultimages(hulpbeeld);
            if beeld < 10
                naam=['000' num2str(beeld)];
            elseif beeld >=10 && beeld<100
                naam=['00' num2str(beeld)];
            else naam=['0' num2str(beeld)];
            end
            readname=directorycontent(beeld+2).name;%de naam van de file die je inleest
            writename=['plot' naam '.png'];%de naam waaronder je het resulterende plaatje met grafiek en afgelijnde tafel wegschrijft.
            load ([directory '/origs/' readname]);%laad het beeld
            image=double(image);
            lb=round(sum(sum(image(1:10,1:10)))/100);
            mask=image>lb;%zoals bekend kijken we alleen naar data binnen de scancirkel.
            if sum(mask(3,:))>0%de scancirkel moet het hele beeld beslaan; in beelden waar dat niet het gaval is, zijn ook geen manuele segmentaties gedaan.
                image=image.*double(mask);
                realimage=sort(image(:));
                startrealscan=find(realimage>0,1,'first');
                realimage=realimage(startrealscan:length(realimage));
                image=min(image,mean(realimage)+3.5*std(realimage));%de hoogste pieken worden uit het beeld verwijderd.
                verbody=sum(image,2);
                da=min(0,diff(verbody));
                da(length(da))=0;%je moet zorgen dat hij het laatste dieptepunt (van bv de onderste tafelrand ook meeneemt)

                minima=zeros(length(da),2);%hier wordt een matrix aangemaakt waarine de plaats van de piekn en hun diepte opgeslagen gaat worden
                minima_index=1;
                for counter=1:length(da)-2
                    if da(counter)>da(counter+1) && da(counter+1)<da(counter+2)%hier worden de echte pieken geidentificeerd
                        minima(minima_index,1)=da(counter+1);%de waarde van de diepte van de piek
                        minima(minima_index,2)=counter+1;%de plaats waar de piek zich bevindt.
                        minima_index=minima_index+1;
                    end 
                end
                minima=minima(1:minima_index-1,:);%de vector wordt op de juiste lengte afgeknipt
                minima=-sortrows(-minima,1);%de waarden van de minima wroden gesorteerd van groot (i.e., minst negatief) naar klein 
                threshold=min(minima(:,1))/5;%een dremplewaarde om alle onbetekenende pieken over te slaan.
                deepestpoints=zeros(size(minima,1),1);%deepestpoints zijn de locaties van alle minima die onder de threshold liggen
                for counter=size(minima,1):-1:1
                    if minima(counter,1)<threshold
                        deepestpoints(counter)=minima(counter,2);%hier wordt de locatie van de paar allerdiepste pieken geidentificeerd.
                    end
                end
                deepestpoints=sort(deepestpoints,'descend');%alle locatie zijn positieve nummers, dus alle 0-en komen nu achteraan;
                deepestpoints=deepestpoints(1:find(deepestpoints==0,1,'first'));%deepestpoints wordt op de juiste lengte afgeknipt
                %tabletop2=zeros(size(tabletop,1),2);
                flag_tabletop2=1;%eerst alle horizontale lijnen vinden die aan criterium1 voldoen
                n_o_peaks=min(5,length(deepestpoints));%ten hoogste de vijf diepste pieken worden bekeken
                if n_o_peaks>2%als er maar twee pieken zijn, dan is er geen keus :-)
                    while flag_tabletop2
                        index1=1;
                        tabletop=zeros(uint8((n_o_peaks*(n_o_peaks-1))/2),2);
                        flag_tabletop=1;
                        while flag_tabletop
                            for counter1=1:n_o_peaks-1%hier worden alle lijnen paren gezocht die ong. 30 rijen uit elkaar liggen.
                                for counter2=counter1+1:n_o_peaks
                                    if deepestpoints(counter1)-deepestpoints(counter2)>=27 && deepestpoints(counter1)-deepestpoints(counter2)<=33
                                        tabletop(index1,1)=deepestpoints(counter1);%tabletop bevat nu al die paren
                                        tabletop(index1,2)=deepestpoints(counter2);
                                        index1=index1+1;
                                        flag_tabletop=0;
                                    end
                                end
                            end
                            if flag_tabletop%als er geen enkel paar aan het criterium voldoet, dan nemen we er een zesde piek bij en gaan opnieuw zoeken
                                n_o_peaks=n_o_peaks+1;
                                tabletop=zeros(uint8((n_o_peaks*(n_o_peaks-1))/2),2);
                            end
                        end
                    end
                end
            end%als scan het hele beeld beslaat (is nu zeker zo, maar goed...)
            differencevec=tabletop(:,1)-realtoppos;%het verschil in gevonden tabeltops en de mediaanwaarde
            betterpos= find(abs(differencevec)==min(abs(differencevec)),1,'first');%de bovenste tabletopwaarde die het dichts bij de mediaanwaarde ligt
            alltops(find(alltops(:,2)==beeld,1,'first'),1)=tabletop(betterpos,1);%vul op de juiste plaats in alltops deze nieuwe table top waarde in
        end%hulpbeeldloop
        %en hier moet je nu dan de tabletop pakken die het dichts bij de mediaanwaarde realtoppos ligt 
        %de nu gevonden tabletops moet je nu trouwens weer opslaan in een
        %vector die je gebruikt voor je FILTER!
        %vervang de coeffiecienten in de foute rijen van alltops.   
    end%if-loop of er ueberhaupt beelden zijn waarvan de gevonden tafelrand teveel afwijkt
    toc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %dit houdt zich alleen maar bedig met het wegschrijven van plaatjes
    for beeld=1:length(alltops(:,2))
        if alltops(beeld,2)~=0
            if beeld < 10
                naam=['000' num2str(beeld)];
            elseif beeld >=10 && beeld<100
                naam=['00' num2str(beeld)];
            else naam=['0' num2str(beeld)];
            end
            readname=directorycontent(beeld+2).name;%de naam van de file die je inleest
            writename=['plot' naam '.png'];%de naam waaronder je het resulterende plaatje met grafiek en afgelijnde tafel wegschrijft.
            load ([directory '/origs/' readname]);% laad het beeld
            timage=image;%dit is allemaal plotterij die weg kan
            timage(alltops(find(alltops(:,2)==beeld,1,'first'),1),:)=max(timage(:));%dit is allemaal plotterij die weg kan
            h=figure('visible','off');
            imshow(timage,[]);
            saveas(h,[directory '/tabletops/' writename],'png');%dit is allemaal plotterij die weg kan
            close(h);%dit is allemaal plotterij die weg kan
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
   % if mod(directorynr,4)==0%ik geloof dat het gebruik van keep het algoritme uiteindelijk wel versneld.
    %    keep('directorynr');%dit veronderstelt dat je de functie keep.m in testimages gedownload hebt.
    %end
end%de loop de alle directories afgaat