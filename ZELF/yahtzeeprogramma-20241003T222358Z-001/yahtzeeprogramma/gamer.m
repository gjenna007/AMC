load data/dice
load data/choice
turn=1;
form=zeros(1,15);
bovenhelft=0;
bbovenhelft=0;
while turn<=15
    index=sum(form.*(ones(1,15)*2).^(14:-1:0))+1;
    eval(['load data/states' num2str(bovenhelft)])
    eval(['load data/fillin' num2str(bovenhelft)])
    eval(['statesb=states' num2str(bovenhelft) ';'])
    eval(['fillinb=fillin' num2str(bovenhelft) ';'])
    w=1;
    while w<=3
        t=input([num2str(turn) ' ' num2str(w) ':   worp?'],'s');
        if length(t)==5
%         s1=sort([str2double(t(1)) str2double(t(2)) str2double(t(3)) str2double(t(4)) str2double(t(5))]);
%         s=num2str(sum(s1.*[10000 1000 100 10 1]));
            s=sort(t);
            worp=find(dice(:,1)==str2double(s(1))&dice(:,2)==str2double(s(2))&dice(:,3)==str2double(s(3))&dice(:,4)==str2double(s(4))&dice(:,5)==str2double(s(5)));
            if w<3
                if max(choice(statesb(w,worp,index),:))>0
                    a=find(choice(statesb(w,worp,index),:)==1);
                    disp(s(a))
                    if statesb(w,worp,index)==32
                        w=3;
                    end
                else disp('alles opnieuw gooien')
                end
            end
            if w==3
               form(fillinb(1,worp,index))=1;
               disp(['invullen: ' num2str(fillinb(1,worp,index))]) 
            end
            if fillinb(1,worp,index)<=6
                bbovenhelft=bbovenhelft+fillinb(1,worp,index)*sum(dice(worp,:)==fillinb(1,worp,index));
                bbovenhelft=min(63,bbovenhelft);
            end
            w=w+1;
        end
    end
    turn=turn+1;
    eval(['clear data/states' num2str(bovenhelft) ' data/fillin' num2str(bovenhelft)])
    bovenhelft=bbovenhelft;
end
