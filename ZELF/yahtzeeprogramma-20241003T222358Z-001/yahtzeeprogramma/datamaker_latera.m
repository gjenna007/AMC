function datamaker_latera(aantvrij,init,step)
cd data
AANTVAKJESVRIJ=aantvrij;
load filled.mat
%load choice.mat
load dice.mat
load baseval63.mat
tic
for uppertotal=init:step:63
    disp(['uppertotal=' num2str(uppertotal)])
    eval(['load baseval' num2str(uppertotal) '.mat'])
    eval(['basevalb=baseval' num2str(uppertotal) ';']);
    eval(['load fillin' num2str(uppertotal) '.mat'])
    eval(['fillb=fillin' num2str(uppertotal) ';']);
    for forminvulling=1:2^15
        if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
            welkeVakjesVrij=find(filled(forminvulling,:)==0);%dit is een vector met lengte AANTVAKJESVRIJ
            for huidigeWorp=1:252
                worp=dice(huidigeWorp,:);
                fullUitkomst=zeros(1,AANTVAKJESVRIJ);
                %fullInvul=zeros(1,AANTVAKJESVRIJ);
                fullInvulVak=zeros(1,AANTVAKJESVRIJ);
                for aanDeBeurt=1:AANTVAKJESVRIJ
                    invulVak=welkeVakjesVrij(aanDeBeurt);
                    if invulVak<=6
                        uitkomst=invulVak*sum(worp==invulVak);
                        invul=(worp==invulVak);
                        if uppertotal<63 && uppertotal+uitkomst>=63
                            uitkomst=uitkomst+35+baseval63(forminvulling+2^(15-invulVak));
                        else
                            uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                        end
                    elseif invulVak==7%pair
                        if worp(1)==worp(2)|| worp(2)==worp(3)|| worp(3)==worp(4)|| worp(4)==worp(5)
                            uitkomst=sum(worp);
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                     elseif invulVak==8%two pair
                        if (worp(1)==worp(2)&&worp(3)==worp(4))||(worp(1)==worp(2)&&worp(4)==worp(5))||(worp(2)==worp(3)&&worp(4)==worp(5))
                            uitkomst=sum(worp);
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==9%three-of-a-kind
                        if worp(1)==worp(3)|| worp(2)==worp(4)|| worp(3)==worp(5)
                            uitkomst=sum(worp);
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==10%carre
                        if worp(1)==worp(4)|| worp(2)==worp(5)
                            uitkomst=sum(worp);
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==11%kleine straat
                        uitkomst=0;
                        invul=[0 0 0 0 0];
                        if length(unique(worp))>=4
                            uworp=unique(worp);
                            if (min(uworp(1:4)==(1:4))==1||min(uworp(1:4)==(2:5))==1||min(uworp(length(uworp)-3:length(uworp))==(3:6))==1)
                                uitkomst=30;
                                invul=[1 1 1 1 1];
                            end
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==12%grote straat
                        if min(worp==(1:5))==1||min(worp==(2:6))==1
                            uitkomst=40;
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==13%full house
                        if (worp(1)==worp(3)&&worp(4)==worp(5))||(worp(3)==worp(5)&&worp(1)==worp(2))
                            uitkomst=25;
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==14%chance
                        uitkomst=sum(worp);
                        invul=[1 1 1 1 1];
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    elseif invulVak==15%yahtzee
                        if worp(1)==worp(5)
                            uitkomst=50;
                            invul=[1 1 1 1 1];
                        else uitkomst=0;
                            invul=[0 0 0 0 0];
                        end
                        uitkomst=uitkomst+basevalb(forminvulling+2^(15-invulVak));
                    end%if invulVak<=6
                    fullUitkomst(aanDeBeurt)=uitkomst;
                    fullInvulVak(aanDeBeurt)=invulVak;
                    %fullInvul(aanDeBeurt)=invul*((2*ones(5,1)).^((4:-1:0)'))+1;
                end%for aanDeBeurt=1:AANTVAKJESVRIJ
                pointer=find(fullUitkomst==max(fullUitkomst),1,'first');
                fillb(1,huidigeWorp,forminvulling)=fullInvulVak(pointer);
            end% for huidigeWorp=1:252
        end%if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
    end% for forminvulling=1:2^15
    eval(['fillin' num2str(uppertotal) '=fillb;']);
    eval(['save(''fillin' num2str(uppertotal) '.mat'',''fillin' num2str(uppertotal) ''')'])
    eval(['clear ' 'fillin' num2str(uppertotal)])
    toc
end%for uppertotal=0:63
cd ..
        