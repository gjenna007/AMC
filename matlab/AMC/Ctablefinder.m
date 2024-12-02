for directorynr=49:50
    sizevenster=410;
    disp(directorynr)   
    tic
    directory=['anoniem' num2str(directorynr)];
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(directory,'tabletops');
    directorycontent=dir([directory '/origs/*']);
    for beeld=1:length(directorycontent)-2
        if beeld < 10
            naam=['000' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['00' num2str(beeld)];
        else naam=['0' num2str(beeld)];
        end
        if mod(beeld,30)==0
            disp([directorynr beeld length(directorycontent)])
        end
        readname=directorycontent(beeld+2).name;%de naam die je inleest
        writename=['plot' naam '.png'];%de naam waaronder je het resultaat wil wegschrijven
        load ([directory '/origs/' readname]);
        h=figure('visible','off');
        image=double(image);
        lb=round(sum(sum(image(1:10,1:10)))/100);
        mask=image>lb;
        if sum(mask(3,:))>0%de scancirkel moet het hele beeld beslaan, anders kan bv een tafelrand wegvallen
            image=image.*double(mask);
            realimage=sort(image(:));
            startrealscan=find(realimage>0,1,'first');
            realimage=realimage(startrealscan:length(realimage));
            image=min(image,mean(realimage)+3.5*std(realimage));
            verbody=sum(image,2);
            da=min(0,diff(verbody));
            da(length(da))=0;%je moet zorgen dat hij het laatste dieptepunt (van bv de onderste tafelrand ook meeneemt)
            subplot(1,3,1);
            plot(diff(verbody),'k');
            hold on;
            title(['Scan: ' num2str(directorynr) ' Image: ' num2str(beeld)])
            axis([0 size(image,1) min(diff(verbody)) max(diff(verbody))])

            minima=zeros(length(da),2);
            minima_index=1;
            for counter=1:length(da)-2
                if da(counter)>da(counter+1) && da(counter+1)<da(counter+2)%hier worden de echte pieken geselecteerd
                    minima(minima_index,1)=da(counter+1);
                    minima(minima_index,2)=counter+1;
                    minima_index=minima_index+1;
                end 
            end
            minima=minima(1:minima_index-1,:);
            minima=-sortrows(-minima,1);
            threshold=min(minima(:,1))/5;
            deepestpoints=zeros(size(minima,1),1);%deepestpoints zijn de locaties van alle minima die onder de threshold liggen
            for counter=size(minima,1):-1:1
                if minima(counter,1)<threshold
                    deepestpoints(counter)=minima(counter,2);
                    plot([minima(counter,2);minima(counter,2)],[min(diff(verbody));max(diff(verbody))],'r:')
                end
            end
            deepestpoints=sort(deepestpoints,'descend');
            deepestpoints=deepestpoints(1:find(deepestpoints==0,1,'first'));
            tabletop2=[];
            tabletop=[];%eerst alle horizontale lijnen vinden die aan criterium1 voldoen
            n_o_peaks=min(5,length(deepestpoints));
            if n_o_peaks>2
            while isempty(tabletop2)
                while isempty(tabletop)
                    for counter1=1:n_o_peaks-1
                        for counter2=counter1+1:n_o_peaks
                            if deepestpoints(counter1)-deepestpoints(counter2)>=27 && deepestpoints(counter1)-deepestpoints(counter2)<=33
                                tabletop=cat(1,tabletop,[deepestpoints(counter1) deepestpoints(counter2)]);
                            end
                        end
                    end
                    n_o_peaks=n_o_peaks+1;
                end

                %dan de horizontale lijnenparen selecteren die aan criterium2 voldoen
                for counter3=1:size(tabletop,1)
                    between=sum(verbody(tabletop(counter3,2)+1:tabletop(counter3,1)-1));
                    above=sum(verbody(2*tabletop(counter3,2)-tabletop(counter3,1)+1:tabletop(counter3,2)-1));
                    if above >= 1.2*between%het dubbele zal wel een goed criterium zijn
                        tabletop2=cat(1,tabletop2,[tabletop(counter3,1) tabletop(counter3,2)]);
                    end
                end
                tabletop=[];
            end
            tabletop3=find(sum(verbody,2)==max(sum(verbody,2)),1,'last');
            counter4=find(tabletop2(:,1)-tabletop3==min(tabletop2(:,1)-tabletop3),1,'first');
            plot([tabletop2(counter4,1);tabletop2(counter4,1)],[min(diff(verbody));max(diff(verbody))],'b--')
            plot([tabletop2(counter4,2);tabletop2(counter4,2)],[min(diff(verbody));max(diff(verbody))],'b--')
            hold off
            timage=image;
            timage(tabletop2(counter4,1)-1,:)=max(timage(:));%dit is de bovenste table top!
            timage(tabletop2(counter4,2)-1,:)=max(timage(:));%dit is de onderste table top!
            subplot(1,2,2);
            imshow(timage,[]);
            end
            saveas(h,[directory '/tabletops/' writename],'png');
            close(h);
        end
    end
    toc
    if mod(directorynr,4)==0
        keep('directorynr');%dit veronderstelt dat je de functie keep.m in testimages gedownload hebt.
    end
end



