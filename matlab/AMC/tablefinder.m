for directorynr=49:50%de buitenste for-loop. Hier bewerk ik de beelden nog maar 1 keer, ik moet dus nog die tweede loop uitvoeren om uitschieters eruit te halen  
    sizevenster=410;
    disp(directorynr)   
    tic
    directory=['anoniem' num2str(directorynr)];%hier wordt de namen van de gebruikte directories gemaakt....zijn die nog goed?
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(directory,'tabletops');%hier wordt de directory aangemaakt waarin de resultaten worden weggeschreven (niet meer nodig in uiteindelijke versie).
    directorycontent=dir([directory '/origs/*']);%hier wordt een ls gedaan van de inhhoud van de map. Zo worden dus automatisch alle files in die directory bewerkt.
    for beeld=1:length(directorycontent)-2%de eerste twee regels van die automatisch gegenereerde directory zijn . en ..
        if beeld < 10
            naam=['000' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['00' num2str(beeld)];
        else naam=['0' num2str(beeld)];
        end
        if mod(beeld,30)==0%dit is slechts om een beetje bij te houden waar je bent, kan dus weg.
            disp([directorynr beeld length(directorycontent)])
        end
        readname=directorycontent(beeld+2).name;%de naam van de file die je inleest
        writename=['plot' naam '.png'];%de naam waaronder je het resulterende plaatje met grafiek en afgelijnde tafel wegschrijft.
        load ([directory '/origs/' readname]);% laad het beeld
        h=figure('visible','off');%dit is alleen om het figuur weg te kunnen schrijven. Voor de werkign van het filter dus onnodig.
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
            subplot(1,3,1);%dit is allemaal plotterij die weg kan
            plot(diff(verbody),'k');%dit is allemaal plotterij die weg kan
            hold on;%dit is allemaal plotterij die weg kan
            title(['Scan: ' num2str(directorynr) ' Image: ' num2str(beeld)])%dit is allemaal plotterij die weg kan
            axis([0 size(image,1) min(diff(verbody)) max(diff(verbody))])%dit is allemaal plotterij die weg kan

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
                    plot([minima(counter,2);minima(counter,2)],[min(diff(verbody));max(diff(verbody))],'r:')%dit is allemaal plotterij die weg kan
                end
            end
            deepestpoints=sort(deepestpoints,'descend');%alle locatie zijn positieve nummers, dus alle 0-en komen nu achteraan;
            deepestpoints=deepestpoints(1:find(deepestpoints==0,1,'first'));%deepestpoints wordt op de juiste lengte afgeknipt
            tabletop2=[];
            tabletop=[];%eerst alle horizontale lijnen vinden die aan criterium1 voldoen
            n_o_peaks=min(5,length(deepestpoints));%ten hoogste de vijf diepste pieken worden bekeken
            if n_o_peaks>2%als er maar twee pieken zijn, dan is er geen keus :-)
            while isempty(tabletop2)%volgens mij moet ik dit omschrijven, want dit vertraagt het algoritme enorm!
                while isempty(tabletop)
                    for counter1=1:n_o_peaks-1%hier worden alle lijnen paren gezocht die ong. 30 rijen uit elkaar liggen.
                        for counter2=counter1+1:n_o_peaks
                            if deepestpoints(counter1)-deepestpoints(counter2)>=27 && deepestpoints(counter1)-deepestpoints(counter2)<=33
                                tabletop=cat(1,tabletop,[deepestpoints(counter1) deepestpoints(counter2)]);%tabletop bevat nu al die paren
                            end
                        end
                    end
                    n_o_peaks=n_o_peaks+1;
                end

                %dan de horizontale lijnenparen selecteren die aan criterium2 voldoen
                for counter3=1:size(tabletop,1)%hier verwachten we dat het gebied boven het tafalbald lichter is dan dat tussen de tafelgrenzen
                    between=sum(verbody(tabletop(counter3,2)+1:tabletop(counter3,1)-1));%je maakt hier gebruik dan het feit dat de meeste hulpstukken niet zo dik zijn.
                    above=sum(verbody(2*tabletop(counter3,2)-tabletop(counter3,1)+1:tabletop(counter3,2)-1));
                    if above >= 1.2*between%het dubbele zal wel een goed criterium zijn
                        tabletop2=cat(1,tabletop2,[tabletop(counter3,1) tabletop(counter3,2)]);%tabletop2 bevat alle paren uit tabletop met juiste grijswaardeverdeling van de omgeving
                    end
                end
                tabletop=[];
            end
            tabletop3=find(verbody==max(verbody),1,'last');%hier bepalen we het breedste deel van het lichaam, hierna zwaartepunt genoemd.
            counter4=find(tabletop2(:,1)-tabletop3==min(tabletop2(:,1)-tabletop3),1,'first');%hier zoeken we het paar uit tabletop2 dat het dichtst bij het zwaartepunt ligt.
            plot([tabletop2(counter4,1);tabletop2(counter4,1)],[min(diff(verbody));max(diff(verbody))],'b--')%dit is allemaal plotterij die weg kan
            plot([tabletop2(counter4,2);tabletop2(counter4,2)],[min(diff(verbody));max(diff(verbody))],'b--')%dit is allemaal plotterij die weg kan
            hold off%dit is allemaal plotterij die weg kan
            timage=image;%dit is allemaal plotterij die weg kan
            timage(tabletop2(counter4,1)-1,:)=max(timage(:));%dit is allemaal plotterij die weg kan
            timage(tabletop2(counter4,2)-1,:)=max(timage(:));%dit is allemaal plotterij die weg kan
            subplot(1,2,2);%dit is allemaal plotterij die weg kan
            imshow(timage,[]);%dit is allemaal plotterij die weg kan
            end
            saveas(h,[directory '/tabletops/' writename],'png');%dit is allemaal plotterij die weg kan
            close(h);%dit is allemaal plotterij die weg kan
        end%if-loop; als de scancirkel niet het hele beeld beslaat doen we niets, en gaan verder met de volgende file.
    end%de loop die alle beeldne in de directory afgaat
    toc
    if mod(directorynr,4)==0%ik geloof dat het gebruik van keep het algoritme uiteindelijk wel versneld.
        keep('directorynr');%dit veronderstelt dat je de functie keep.m in testimages gedownload hebt.
    end
end%de loop de alle directories afgaat



