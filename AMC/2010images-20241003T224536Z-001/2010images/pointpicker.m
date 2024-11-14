directory='arendse_fr1H1';%hier wordt de namen van de gebruikte directories gemaakt....zijn die nog goed?
    resultsdirectory='gofs';
    %nu wordt de directory aangemaakt waarin de resultaten worden
    %weggeschreven (niet meer nodig in uiteindelijke versie).
    eval(['[SUCCESS,MESSAGE,MESSAGEID]=mkdir(directory,' '''' resultsdirectory ''''  ');']);
    directorycontent=dir([directory '/results/contour*']);%hier wordt een ls gedaan van de inhhoud van de map. Zo worden dus automatisch alle files in die directory bewerkt.
    jaccards=zeros(length(directorycontent),1);
    clockwise=[-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
    for beeld=1:1%length(directorycontent)%de eerste twee regels van die automatisch gegenereerde directory zijn . en ..
        if beeld < 10
            naam=['00' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['0' num2str(beeld)];
        else naam=num2str(beeld);
        end
        readname=directorycontent(beeld).name;%de naam van de file die je inleest
        load ([directory '/results/' readname]);% laad het beeld
        BINcontour2=zeros(412);
        BINcontour2(2:411,2:411)=BINcontour;
        slang=zeros(sum(BINcontour(:)),2);
        index=1;
        [v,h]=find(BINcontour);
        v=v(1);h=h(1);
        slang(1,:)=[v h];
        %BINcontour2(v(1)+1,h(1)+1)=2;
        t=1;
        while index<sum(BINcontour(:))
            if  BINcontour2(v+1+clockwise(t,1),h+1+clockwise(t,2))==1
                BINcontour2(v+1,h+1)=2;
                v=v+clockwise(t,1); h=h+clockwise(t,2);
                index=index+1;
                slang(index,:)=[v h];
                t=1;
            else t=t+1;
            end
        end
        punten=zeros(99,2);
        index=1;
        for counter=1:ceil(double(sum(BINcontour(:)))/99):sum(BINcontour(:))
            punten(index,:)=slang(counter,:);
            index=index+1;
        end
        punten=punten(1:index-1,:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %nu maken we polygoon en berekenen jaccard index
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        polygoon=zeros(410);
        for pencil=2:size(punten,1)
            for t=0:100
                polygoon(floor(punten(pencil,1)+t/100*(punten(pencil-1,1)-punten(pencil,1))),floor(punten(pencil,2)+t/100*(punten(pencil-1,2)-punten(pencil,2))))=1;
            end    
        end
        pencil=size(punten,1);
        for t=0:100
            polygoon(floor(punten(pencil,1)+t/100*(punten(1,1)-punten(pencil,1))),floor(punten(pencil,2)+t/100*(punten(1,2)-punten(pencil,2))))=1;
        end   
    end
    
    