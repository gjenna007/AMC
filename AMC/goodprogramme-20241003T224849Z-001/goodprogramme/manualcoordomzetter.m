cd gof_marlinde
for anoniemnummer=10:13;%de te veranderen waarde
        disp(anoniemnummer)
    fid=fopen(['Tanoniem' num2str(anoniemnummer) '.txt'],'r');
    layer=0;row=1;
    currentz=1000000;
    maxnumb=0;
    temp=zeros(100,4);%,300);
    contours=[];
    while 1
        line=fgetl(fid);
        maxnumb=maxnumb+1;
        if ~ischar(line), break, end
        if isempty(line), break,end
        nocoordinates=0;
        %line=[line ' '];
        xtxt='';
        ytxt='';
        ztxt='';
        t=1;
        %Eerst de eerste paar tekens overslaan
         while (line(t)~='(')
            t=t+1;
            if t>length(line)
                nocoordinates=1;
                break
            end
         end
        t=t+1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if nocoordinates==0
            while (line(t)~=' ')
                xtxt=[xtxt line(t)];
                t=t+1;
            end
            t=t+1;
            while (line(t)~=' ')
                ytxt=[ytxt line(t)];
                t=t+1;
            end
            t=t+1;
            while (line(t)~=')')
                ztxt=[ztxt line(t)];
                t=t+1;
            end
            x=str2double(xtxt);y=str2double(ytxt);z=str2double(ztxt);
            if z~=currentz
                layer=layer+1;
                %disp(layer)
                if row>1
                    temp=temp(1:row-1,:);
                end
                contours=cat(1,contours,temp);
                row=1;
                currentz=z;
            end
            temp(row,1)=x;
            temp(row,2)=y;
            temp(row,3)=z;
            temp(row,4)=layer;
            %maxnumb=max(maxnumb,row);
            row=row+1;
        end
    end
    disp(layer)
    if row>1
       temp=temp(1:row-1,:);
    end
    contours=cat(1,contours,temp);
    matrixcoords=contours;
    matrixcoords(:,1:2)=cat(2,contours(:,2),contours(:,1))*1000+250;%dit moet 205 zijn!!
    matrixcoords(:,3)=contours(:,3)*1000;
    matrixcoords=round(matrixcoords);
    writename=['Manoniem' num2str(anoniemnummer) '.mat'];
    save(writename,'contours','matrixcoords')
    fclose(fid);
end
cd ..