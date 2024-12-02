%totresult=zeros(,);
for directorynr=2:7;%dit is de scan die we gaan bewerken
    deelresult=zeros(133,8);
    rt=1;%rt=resultteller
    disp(directorynr)   
    %directory=['anoniem' num2str(directorynr)];%dit is de directory voor de automatische aflijningen.
    %de files heten contour.... en de variabele erin heet BINcontour
    load(['gof_marlinde/FINanoniem' num2str(directorynr)]);%in deze file zitten de manuele aflijningen van alle slices van de scan
    marcontour=contour;
    load(['gof_donald/FINanoniem' num2str(directorynr)]);%in deze file zitten de manuele aflijningen van alle slices van de scan
    doncontour=contour;
    %nu marlinde overlopen
    for zcoord=min(marcontour(:,3)):max(marcontour(:,3))
        if max(marcontour(:,3)==zcoord)>0%als deze contour in marlinde bestaat
            if max(doncontour(:,3)==zcoord)>0%als deze contour ook bij donald bestaat
                manualmar=zeros(410);
                manualdon=zeros(410);
                for teller=find(marcontour(:,3)==zcoord,1,'first'):find(marcontour(:,3)==zcoord,1,'last')
                    manualmar(min(410,max(1,marcontour(teller,1)-45)),min(410,max(1,marcontour(teller,2)-45)))=1;
                end
                for teller=find(doncontour(:,3)==zcoord,1,'first'):find(doncontour(:,3)==zcoord,1,'last')
                    manualdon(min(410,max(1,doncontour(teller,1)-45)),min(410,max(1,doncontour(teller,2)-45)))=1;
                end
                manualmar=imfill(manualmar,'holes');%het afgelijnde gebied van de manuele contour
                manualdon=imfill(manualdon,'holes');%het afgelijnde gebied van de manuele contour
                deelresult(rt,1)=directorynr;
                deelresult(rt,2)=zcoord;
                deelresult(rt,3)=sum(manualmar(:));%grootte van manueel afgelijnd gebied
                deelresult(rt,4)=sum(manualdon(:));%grootte van automatisch afgelijnd gebied
                deelresult(rt,5)=sum(sum(manualmar&manualdon))/sum(sum(manualmar|manualdon));%jaccard index
                deelresult(rt,6)=2*sum(sum(manualmar&manualdon))/(sum(manualmar(:))+sum(manualdon(:)));%dice index
                deelresult(rt,7)=1-sum(sum(xor(manualmar,manualdon)))/sum(manualmar(:));%precision ratio
                deelresult(rt,8)=1-abs(sum(manualmar(:))-sum(manualdon(:)))/sum(manualmar(:));%match rate
                rt=rt+1;
            end
        end
    end
    findeelresult=deelresult(1:rt-1,:);
    save(['coefficients/marlinde_donald' num2str(directorynr)],'findeelresult');
    wk1write(['coefficients/TABmarlinde_donald' num2str(directorynr)],findeelresult);
end