cd data
tic
choice=zeros(32,5);
choice2=choice;
i=1;for d1=0:1;for d2=0:1; for d3=0:1; for d4=0:1; for d5=0:1;choice(i,:)=[d1 d2 d3 d4 d5];i=i+1;end;end;end;end;end;save choice.mat choice
for i=2:32
    j=find(choice(i,:));
    l=0;
    for k=length(j):-1:1
        choice2(i,j(k))=10^l;
        l=l+1;
    end
end
save choice2.mat choice2
filled=zeros(2^15,15);
i=1;for d1=0:1;for d2=0:1; for d3=0:1; for d4=0:1; for d5=0:1;for d6=0:1;for d7=0:1; for d8=0:1;
                                for d9=0:1; for d10=0:1;for d11=0:1;for d12=0:1; for d13=0:1; for d14=0:1; for d15=0:1;
                                    filled(i,:)=[d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15];
                                    i=i+1;
                                end;end;end;end;end;end;end;
    end;end;end;end;end;end;end;end; save filled.mat filled
dice=zeros(6^5,5);
i=1;for d1=1:6;for d2=1:6; for d3=1:6; for d4=1:6; for d5=1:6;dice(i,:)=[d1 d2 d3 d4 d5];i=i+1;end;end;end;end;end
dice2=sort(dice,2,'ascend');
dice=sortrows(dice2);
dice=unique(dice,'rows');
save dice.mat dice
dice2=dice2*[10000 1000 100 10 1]';
dice=dice*[10000 1000 100 10 1]';
initfreqs=zeros(252,1);
for i=1:252
    initfreqs(i)=sum(dice2==dice(i));
end
initfreqs=initfreqs/6^5;
save initfreqs.mat initfreqs
exp99=zeros(3,252,2^15);
for i=0:63
    eval(['exp' num2str(i) '=exp99;']);
    eval(['save(''exp' num2str(i) '.mat'',''exp' num2str(i) ''')']);
    eval(['clear exp' num2str(i)]);
end
clear exp99
states99=zeros(3,252,2^15);
for i=0:63
    eval(['states' num2str(i) '=states99;']);
    eval(['save(''states' num2str(i) '.mat'',''states' num2str(i) ''')']);
    eval(['clear states' num2str(i)]);
end
clear states99
fillin99=zeros(1,252,2^15);
for i=0:63
    eval(['fillin' num2str(i) '=fillin99;']);
    eval(['save(''fillin' num2str(i) '.mat'',''fillin' num2str(i) ''')']);
    eval(['clear fillin' num2str(i)]);
end
clear fillin99
baseval99=zeros(2^15,1);
for i=0:63
    eval(['baseval' num2str(i) '=baseval99;']);
    eval(['save(''baseval' num2str(i) '.mat'',''baseval' num2str(i) ''')']);
    eval(['clear baseval' num2str(i)]);
end
clear baseval99
cd ..
toc