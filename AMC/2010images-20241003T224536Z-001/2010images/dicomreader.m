%Gebruiksaanwijzing; kijk eerst in MRICRO (met RAW view) wat de afmeting van de beelden is
%Pas die waarden aan in sizever en sizehor.
%Het beeld wordt ingelezen als uint16s, en als een matrix genaamd 'image' weggeschreven.
sizevenster=410;%270,410,500 zijn de enig mogelijke waarden voor small, medium, of large FOV
%totaal_aantal_beelden=264;
for directorynr=61:61
    disp(directorynr)
    tic
    directory='arendse_fr1H1';
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(directory,'origs');
    index=dir([directory '/*.DCM']);
    for beeld=1:length(index)
        if beeld < 10
            naam=['00' num2str(beeld)];
        elseif beeld >=10 && beeld<100
            naam=['0' num2str(beeld)];
        else naam=num2str(beeld);
        end
        if mod(beeld,30)==0
            disp([directorynr beeld length(index)])
        end
        readname=index(beeld).name;%de naam die je inleest
        writename=['img' naam '.mat'];%de naam waaronder je het resultaat wil wegschrijven
        %pngname=['xexp' name '.png'];
        fid=fopen([directory '/' readname],'r');
        a=fread(fid,'uint16');
        b=a(length(a)-(sizevenster*sizevenster)+1:length(a));
        image=uint16(reshape(b,sizevenster,sizevenster))';
        save([directory '/origs/' writename],'image');
        %hier kun je evt wat regels toevoegen om een beeld weg te schrijven
        fclose(fid);
    end
    toc
     keep('directorynr');
end