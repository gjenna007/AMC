function datamaker4a(aantvrij,init,step)

cd data
%openvak= het vakje dat nog open is op het invulformulier
%worp=stenencomb de er ligt
%uitkomst van de worp n het openvak invullen.
AANTVAKJESVRIJ=aantvrij
load filled.mat
load choice2.mat
load dice.mat
%load dice_metrep.mat
diceCompact=dice*[10000 1000 100 10 1]';%dice(:,5)+10*dice(:,4)+100*dice(:,3)+1000*dice(:,2)+10000*dice(:,1);
keeper1=-ones(252,5);
waarden=zeros(32,1);
keeper1(:,5)=diceCompact;
for row=4:-1:1
    a=unique(mod(diceCompact,10^row));
    keeper1(1:length(a),row)=a;
end
tic
for uppertotal=init:step:63
    disp(uppertotal)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eval(['load states' num2str(uppertotal) '.mat'])
    eval(['load exp' num2str(uppertotal) '.mat'])
    eval(['statesb=states' num2str(uppertotal) ';']);
    eval(['expb=exp' num2str(uppertotal) ';']);
    for REEDSINGEVULD=3:-1:2%;%Dit moet 3 of 2 zijn
        for forminvulling=1:2^15
            if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
                keeper2=zeros(252,5);
                %de keepers invullen
                keeper2(:,5)=expb(REEDSINGEVULD,:,forminvulling)';
                for row=4:-1:1
                    for werpComb=1:sum(keeper1(:,row)>-1)
                        a=num2str(keeper1(werpComb,row));
                        b=sort([a '1';a '2';a '3';a '4';a '5';a '6'],2);
                        c=str2double({b(1,:) b(2,:) b(3,:) b(4,:) b(5,:) b(6,:)})';
                        keeper2(werpComb,row)=1/6*sum(max(cat(2,c(1)==keeper1(:,row+1 ),c(2)==keeper1(:,row+1 ),c(3)==keeper1(:,row+1),c(4)==keeper1(:,row+1),c(5)==keeper1(:,row+1),c(6)==keeper1(:,row+1)),[],2).*keeper2(:,row+1));
                    end
                end
                keeper0=sum(keeper2(:,1))/6;
                for werpComb=1:252
                    worp=dice(werpComb,:);
                    nieuweWorp=sum((ones(32,1)*worp).*choice2,2);
                    for doorgangsMog=1:32
                        if nieuweWorp(doorgangsMog)==0
                           waarden(doorgangsMog)=keeper0;
                        else
                            waarden(doorgangsMog)=sum(sum(keeper2(keeper1==nieuweWorp(doorgangsMog))));
                        end
                    end
                    expb(REEDSINGEVULD-1,werpComb,forminvulling)=max(waarden);%wat is dat gewogen gemiddelde 
                    statesb(REEDSINGEVULD-1,werpComb,forminvulling)=find(waarden==max(waarden),1,'first');%bij welke doorgangsmogelijkheid bereik je die
                end
            end
        end
    end
    eval(['states' num2str(uppertotal) '=statesb;']);
    eval(['exp' num2str(uppertotal) '=expb;']);
    eval(['save(''states' num2str(uppertotal) '.mat'',''states' num2str(uppertotal) ''')'])
    eval(['save(''exp' num2str(uppertotal) '.mat'',''exp' num2str(uppertotal) ''')'])
    eval(['clear ' 'exp' num2str(uppertotal) ' states' num2str(uppertotal)])
    toc
end
cd ..     