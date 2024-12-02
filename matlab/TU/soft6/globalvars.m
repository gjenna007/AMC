function globalvars(begin)
totvars=zeros(1000,4);
for beeld=begin:begin+997
    load(['matchresults/' num2str(begin-1) '-' num2str(begin+997) '/vars0000' num2str(beeld)])
    totvars(mod(beeld,1000)+1,1)=WINver;
    totvars(mod(beeld,1000)+1,2)=WINhor;
    totvars(mod(beeld,1000)+1,3)=vw;
    totvars(mod(beeld,1000)+1,4)=hw;
end
save(['globalmotion/' num2str(floor(begin/1000)) 'vars.mat'],'totvars')
    
