function datamaker(aantvrij,init,step)
cd data
tic
AANTVAKJESVRIJ=aantvrij;%het aantal vakjes dat op het formulier nog vrij is
load filled.mat
load choice.mat
load dice.mat
for uppertotal=init:step:63
    disp(uppertotal)
    eval(['load states' num2str(uppertotal) '.mat'])
    eval(['load exp' num2str(uppertotal) '.mat'])
    eval(['statesb=states' num2str(uppertotal) ';']);
    eval(['expb=exp' num2str(uppertotal) ';']);
    eval(['load baseval' num2str(uppertotal) '.mat'])
    eval(['basevalb=baseval' num2str(uppertotal) ';']);
    for forminvulling=1:2^15
        if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
            mogInvullingen=zeros(AANTVAKJESVRIJ,2);
            alleOpenvakken=find(filled(forminvulling,:)==0);
            for i=1:252
                worp=dice(i,:);
                for mogelijkheden=1:AANTVAKJESVRIJ
                    openvak=alleOpenvakken(mogelijkheden);
                    form=filled(forminvulling,:);
                    form(openvak)=1;
                    finder=form*((2*ones(15,1)).^((14:-1:0)'))+1;% dus altijd finder > forminvulling!!
                    mogInvullingen(mogelijkheden,1)=expb(3,i,finder)+basevalb(finder);
                    mogInvullingen(mogelijkheden,2)=choice(statesb(3,i,finder),:)*((2*ones(5,1)).^((4:-1:0)'))+1;
                end
                expb(3,i,forminvulling)=max(mogInvullingen(:,1));
                tetra=find(mogInvullingen(:,1)==max(mogInvullingen(:,1)),1,'first');
                statesb(3,i,forminvulling)=mogInvullingen(tetra,2);
            end
        end
    end
    eval(['states' num2str(uppertotal) '=statesb;']);
    eval(['exp' num2str(uppertotal) '=expb;']);
    eval(['save(''states' num2str(uppertotal) '.mat'',''states' num2str(uppertotal) ''')'])
    eval(['save(''exp' num2str(uppertotal) '.mat'',''exp' num2str(uppertotal) ''')'])
    eval(['clear ' 'exp' num2str(uppertotal) ' states' num2str(uppertotal) ' baseval' num2str(uppertotal)])
end
cd ..     