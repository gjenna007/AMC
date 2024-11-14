function basevuller(aantvrij,init,step)
%dit berekent de verwachte waarde van ieder invulformulier (nog voor de
%eerste worp, en schrijft deze weg in baseval
cd data
AANTVAKJESVRIJ=aantvrij;
load filled.mat
load initfreqs.mat
tic
for uppertotal=init:step:63
    disp(uppertotal)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eval(['load baseval' num2str(uppertotal) '.mat'])
    eval(['load exp' num2str(uppertotal) '.mat'])
    eval(['baseb=baseval' num2str(uppertotal) ';']);
    eval(['expb=exp' num2str(uppertotal) ';']);
    for forminvulling=1:2^15
        if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
            a=expb(1,:,forminvulling)*initfreqs;
            baseb(forminvulling)=a;
        end
    end
    eval(['baseval' num2str(uppertotal) '=baseb;']);
    eval(['save(''baseval' num2str(uppertotal) '.mat'',''baseval' num2str(uppertotal) ''')'])
    eval(['clear ' 'exp' num2str(uppertotal) ' baseval' num2str(uppertotal)])
    toc
end
cd ..   