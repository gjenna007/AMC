init=1;
step=3;
for aantvrij=1:15
    disp(['aantvrij=' num2str(aantvrij)])
    if aantvrij==1
        datamaker_init(init,step)
        datamaker_initb(init,step)
    else
        datamaker(aantvrij,init,step)%deze maakt de 3e laag van exp aan
    end
    datamaker4a(aantvrij,init,step)%deze maakt de eerste twee lagen van exp aan
    basevuller(aantvrij,init,step)%berekent
    if aantvrij>1
         datamaker_latera(aantvrij,init,step)%hier pas wordt de fillin gemaakt die je in gamer.m gebruikt
    end
end
   