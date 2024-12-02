%totresult=zeros(,);
for directorynr=7:7;%dit is de scan die we gaan bewerken
    deelresult=zeros(133,8);
    rt=1;%rt=resultteller
    disp(directorynr)   
    tic
    directory=['anoniem' num2str(directorynr)];%dit is de directory voor de automatische aflijningen.
    %de files heten contour.... en de variabele erin heet BINcontour
    load(['gof_donald/FINanoniem' num2str(directorynr)]);%in deze file zitten de manuele aflijningen van alle slices van de scan
    %de variabele in deze file heet contour
    cvn=contour(find(contour(:,3)==0,1,'first'),4);%cvn=centre volgnummer (volgnummer van de middelste slice dus)
    dcn=length(dir([directory '/*.DCM']));%dcn=directory content number (aantal dcm files in de directory dus)
    fs=(dcn/2)+(cvn-1)*2;%dit is het slicenummer dat correspondeert met volgnummer 1. Merk op dat de files in "omgekeerde" volgorde staan
    %van het gezichtspunt van de volgnummers uit gezien.
    exst_conts=dir([directory '/Ttops/contour*']);
    fcont=exst_conts(1).name;bcont=str2double(fcont(8:11));
    lcont=exst_conts(length(exst_conts)).name;econt=str2double(lcont(8:11));
    for volgnummer=1:max(contour(:,4))%dit zijn de volgnummers van de manueel ingetekende slices
        beeld=-(volgnummer-1)*2+fs;
        testbeeld=0;
        if beeld==52
            volgnummer
            testbeeld=1;
        end
        if beeld < 10
            naam=['000' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['00' num2str(beeld)];
        else naam=['0' num2str(beeld)];
        end
        if mod(beeld,80)==0%dit is slechts om een beetje bij te houden waar je bent, kan dus weg.
            disp([directorynr beeld dcn])
        end
        %Hier moet je eerst controleren of die file wel bestaat. 
        if beeld>=bcont && beeld<=econt
            load ([directory '/Ttops/contour' naam '.mat']);% dit is de automatische aflijning; deze worden per slice ingeladen
            if max(BINcontour(:))>0%als er geen automatische contour is ingetekend, gaan we verder en doen we niets
                automatic=imfill(BINcontour,'holes');%het afgelijnde gebied van de automatische contour
                manual=zeros(410);
                for teller=find(contour(:,4)==volgnummer,1,'first'):find(contour(:,4)==volgnummer,1,'last')
                    manual(min(410,max(1,contour(teller,1)-45)),min(410,max(1,contour(teller,2)-45)))=1;%door een bug in het programma 'manualcoordomzetter' 
                    %moeten nu die -45's toegevoegd worden. Later moeten we
                    %alle files Manoniem gaan herschrijven na deze bug hersteld
                    %te hebbben zodat we gewoon goede coordinaten in de files
                    %hebben staan. Verder had ik niet met roud moet
                    %afronden maar met ceil, omdat du negatieve getallen
                    %(tweede kwadrant) naar beneden opschuiven, en
                    %positieve getallen (vierde kwadrant) naar boven. Dit
                    %kun je hier niet meer corrigeren, omdat de getallen al
                    %afgerond ZIJN
                end
                if testbeeld==1
                    testmanual=manual;
                    volgnummer
                end
                manual=imfill(manual,'holes');%het afgelijnde gebied van de manuele contour
                deelresult(rt,1)=directorynr;
                deelresult(rt,2)=beeld;
                deelresult(rt,3)=sum(manual(:));%grootte van manueel afgelijnd gebied
                deelresult(rt,4)=sum(automatic(:));%grootte van automatisch afgelijnd gebied
                deelresult(rt,5)=sum(sum(manual&automatic))/sum(sum(manual|automatic));%jaccard index
                deelresult(rt,6)=2*sum(sum(manual&automatic))/(sum(manual(:))+sum(automatic(:)));%dice index
                deelresult(rt,7)=1-sum(sum(xor(manual,automatic)))/sum(manual(:));%precision ratio
                deelresult(rt,8)=1-abs(sum(manual(:))-sum(automatic(:)))/sum(manual(:));%match rate
                rt=rt+1;
            end
        end
    end
    findeelresult=deelresult(1:rt-1,:);
    %save(['coefficients/marlinde_auto' num2str(directorynr)],'findeelresult');
    %wk1write(['coefficients/TABmarlinde_auto' num2str(directorynr)],findeelresult);
end