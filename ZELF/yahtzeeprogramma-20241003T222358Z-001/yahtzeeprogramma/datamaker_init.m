function datamaker_init(init,step)
%de functie levert voor ieder invulformulier waarvan nog 1 vakje open is,
%voor ieder van de 252 worpen voor ieder invulcombinatie de waarde daarvan
%(opgeslagen in exp). In states wordt opgeslagen welke dobbelstenen
%opnieuwe gegooid moeten worden (hier dus geen zinvolle informatie)
cd data
AANTVAKJESVRIJ=1;%het aantal vakjes dat op het formulier nog vrij is
load filled.mat
load choice.mat
load dice.mat
tic
for uppertotal=init:step:63
    disp(uppertotal)
    eval(['load states' num2str(uppertotal) '.mat'])
    eval(['load exp' num2str(uppertotal) '.mat'])
    eval(['statesb=states' num2str(uppertotal) ';']);
    eval(['expb=exp' num2str(uppertotal) ';']);
    for forminvulling=1:2^15
        if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
            openvak=find(filled(forminvulling,:)==0);
            for i=1:252
                worp=dice(i,:);
                if openvak<=6
                    uitkomst=openvak*sum(worp==openvak);
                    invul=(worp==openvak);
                    if uppertotal<63 && uppertotal+uitkomst>=63
                        uitkomst=uitkomst+35;
                    end
                elseif openvak==7%pair
                    if worp(1)==worp(2)|| worp(2)==worp(3)|| worp(3)==worp(4)|| worp(4)==worp(5)
                        uitkomst=sum(worp);
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                 elseif openvak==8%two pair
                    if (worp(1)==worp(2)&&worp(3)==worp(4))||(worp(1)==worp(2)&&worp(4)==worp(5))||(worp(2)==worp(3)&&worp(4)==worp(5))
                        uitkomst=sum(worp);
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                elseif openvak==9%three-of-a-kind
                    if worp(1)==worp(3)|| worp(2)==worp(4)|| worp(3)==worp(5)
                        uitkomst=sum(worp);
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                elseif openvak==10%carre
                    if worp(1)==worp(4)|| worp(2)==worp(5)
                        uitkomst=sum(worp);
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                elseif openvak==11%kleine straat
                    uitkomst=0;
                    invul=[0 0 0 0 0];
                    if length(unique(worp))>=4
                        uworp=unique(worp);
                        if (min(uworp(1:4)==(1:4))==1||min(uworp(1:4)==(2:5))==1||min(uworp(length(uworp)-3:length(uworp))==(3:6))==1)
                            uitkomst=30;
                            invul=[1 1 1 1 1];
                        end
                    end
                elseif openvak==12%grote straat
                    if min(worp==(1:5))==1||min(worp==(2:6))==1
                        uitkomst=40;
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                elseif openvak==13%full house
                    if (worp(1)==worp(3)&&worp(4)==worp(5))||(worp(3)==worp(5)&&worp(1)==worp(2))
                        uitkomst=25;
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                elseif openvak==14%chance
                    uitkomst=sum(worp);
                    invul=[1 1 1 1 1];
                elseif openvak==15%yahtzee
                    if worp(1)==worp(5)
                        uitkomst=50;
                        invul=[1 1 1 1 1];
                    else uitkomst=0;
                        invul=[0 0 0 0 0];
                    end
                end
                expb(3,i,forminvulling)=uitkomst;
                statesb(3,i,forminvulling)=1+invul*[16 8 4 2 1]';
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
        