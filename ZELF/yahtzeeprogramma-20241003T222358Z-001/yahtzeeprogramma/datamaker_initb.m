function datamaker_initb(init,step)
%deze functie geeft voor ieder ingevuld formulier met 1 open vakje voor ieder van de 252
%worpen aan waar de beste cominatie ingevuld moet worden (in dit geval is
%dat dus altijd dat ene open vakje)
cd data
AANTVAKJESVRIJ=1;%het aantal vakjes dat op het formulier nog vrij is
load filled.mat
%load choice.mat
load dice.mat
tic
for uppertotal=init:step:63
    disp(uppertotal)
    eval(['load fillin' num2str(uppertotal) '.mat'])
    eval(['fillb=fillin' num2str(uppertotal) ';']);
    for forminvulling=1:2^15
        if sum(filled(forminvulling,:))==15-AANTVAKJESVRIJ
            openvak=find(filled(forminvulling,:)==0);
            fillb(1,:,forminvulling)=openvak;
        end
    end
    eval(['fillin' num2str(uppertotal) '=fillb;']);
    eval(['save(''fillin' num2str(uppertotal) '.mat'',''fillin' num2str(uppertotal) ''')'])
    eval(['clear ' 'fillin' num2str(uppertotal)])
    toc
end
cd ..
        