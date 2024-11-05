% input: maximum(aantal segmenten) ; par(nummer van de textuurparameter)
% output: kolommatrix met van ieder segment de berekende textuurparameter

function tex = texture(maximum, par, bobo, water, im, theta, D)

% Oppervlakte per gebied
opp=regionprops(water, 'Area');
oppStats=[opp.Area]';
s=size(im);

switch par
    
     
%==================================================================
%               Uniformity
%==================================================================

                 case 1
                    uniformiteit=zeros(maximum,1);  
                    for i=1:maximum
                        coocc1=coocc(i, im, bobo, water, oppStats, theta, D);        
                        som=sum(coocc1(:));
                        if som > 0  
                        cooc2=coocc1/som;
                        unif=cooc2.*cooc2;
                        uniformiteit(i,1)=sum(unif(:));
                        else uniformiteit(i,1)=NaN;    %voor segmenten < 20
                        end
                    end
                    tex=uniformiteit;
                                       
%==================================================================
%               Contrast
%==================================================================       

                case 2
                    contrast=zeros(maximum,1);
                    iminj=zeros(256,256);
                    for i=1:256
                        for j=1:256
                            iminj(i,j)=(i-j)*(i-j);
                        end
                    end
                    for i=1:maximum
                        coocc1=coocc(i, im, bobo, water, oppStats, theta, D);
                        som = sum(coocc1(:));
                        if som > 0
                        coocc2=coocc1/som;
                        contr=iminj.*coocc2;
                        contrast(i,1)=sum(contr(:));
                        else
                        contrast(i,1)=NaN;   %voor segmenten < 20
                        end                        
                    end
                    tex=contrast;
                
%==================================================================
%               Inverse Difference Moment
%==================================================================

                case 3
                    IDM=zeros(maximum,1);
                    iminj=zeros(256,256);
                    for i=1:256
                        for j=1:256
                            iminj(i,j)=1/(1+(i-j)*(i-j));
                        end
                    end
                    for i=1:maximum 
                        coocc1=coocc(i, im, bobo, water, oppStats, theta, D);    
                        som=sum(coocc1(:));
                        if som > 0
                        coocc2=coocc1/(som);                
                        tussen_IDM=iminj.*coocc2;
                        IDM(i,1)=sum(tussen_IDM(:));
                        else
                        IDM(i,1)=NaN;  %voor segmenten < 20
                        end
                    end
                    tex=IDM;
                       
%==================================================================
%               Entropy
%==================================================================
                case 4
                    entropie=zeros(maximum,1);
                    for i=1:maximum
                        coocc1=coocc(i, im, bobo, water, oppStats, theta, D);
                        som = sum(coocc1(:));
                        if som > 0
                        coocc2=coocc1/(som);
                        alles1 = coocc2 == 0;   %nullen op één zetten, enen op nul, nodig bij onderstaande log
                        coocc3= coocc2 + alles1;
                        coocc3=log(coocc3);             
                        entr=coocc2.*coocc3;
                        entropie(i,1)=-sum(entr(:));
                        else
                        entropie(i,1)=NaN;    %voor segmenten < 20
                        end   
                    end
                    tex=entropie;

%==================================================================
%               Signal to Noise Ratio
%==================================================================
                case 5
                    SNR=zeros(maximum,1);                   
                    for i=1:maximum 
                        k=1;
                        hulp=[];
                        for ver = floor(bobo(i,1)) : ceil(bobo(i,1)+bobo(i,3))
                            if (ver > s(1)) break; end
                            for hor = floor(bobo(i,2)) : ceil(bobo(i,2)+bobo(i,4))
                                if (ver == 0 | hor > s(2)) break; end
                                if (hor ~= 0)  
                                    if water(ver,hor) == i
                                        hulp(k,1)=im(ver,hor);
                                        k=k+1;
                                    end
                                end
                            end
                        end
                    gemiddelde(i,1)=mean(hulp);
                    stand(i,1)=std2(hulp);
                    if stand(i,1)~=0 %sommige segmenten zijn maar 1 pixel groot => std = 0 => deling door nul => naar else gaan
                        SNR(i,1)=gemiddelde(i,1)/stand(i,1);
                    else %indien er deling door nul zou zijn, zet de SNR op NaN
                        SNR(i,1)=NaN; 
                    end
                    end
                    tex=SNR;
                    

%==================================================================
%               Variation Coefficient
%==================================================================
                case 6
                    varcoef=zeros(maximum,1);
                    for i=1:maximum 
                        k=1;
                        hulp=[];
                         for ver = floor(bobo(i,1)) : ceil(bobo(i,1)+bobo(i,3))
                            if (ver > s(1)) break; end
                            for hor = floor(bobo(i,2)) : ceil(bobo(i,2)+bobo(i,4))
                                if (ver == 0 | hor > s(2)) break; end
                                if (hor ~= 0)  
                                    if water(ver,hor) == i
                                        hulp(k,1)=im(ver,hor);
                                        k=k+1;
                                    end
                                end
                            end
                         end
                    gemiddelde(i,1)=mean(hulp);
                    stand(i,1)=pow2(std(hulp));
                    varcoef(i,1)=stand(i,1)/gemiddelde(i,1);
                    end
                    tex=varcoef;
                    
                    
                    
  %==================================================================
  %               Correlation
  %==================================================================                          
                case 7  
                    correlatie=zeros(maximum,1);
                    for i=1:maximum
                        coocc1=coocc(i, im, bobo, water, oppStats, theta, D);
                        som = sum(coocc1(:));
                        if som > 0
                            coocc2=coocc1/som;      %p(i,j)
                            som_kolom= sum(coocc2); %som over j (rijmatrix)
                            som_rij= sum(coocc2,2); %som over i (kolommatrix)
                            
                            mux= sum([0:255].*som_kolom);
                            muy= sum([0:255].*som_rij');
                            
                            k= [0 : 255];
                            
                            sigmax= sqrt(sum((k - mux).*(k - mux).*som_kolom));
                            sigmay= sqrt(sum((k - muy).*(k - muy).*som_rij'));
                            
                            tussen_correl= k'* k .* coocc2;
                            tussen_correl= sum(tussen_correl(:));

                            produkt_mu= mux * muy;
                            produkt_sigma= sigmax * sigmay;
                            
                            if produkt_sigma~=0
                            correlatie(i,1)=(tussen_correl - produkt_mu)/produkt_sigma;
                            else
                            correlatie(i,1)=NaN;   
                            end
                            
                        else correlatie(i,1)=NaN;   
                        end
                    end
                    tex=correlatie;
                    
                    
%==================================================================
%               Mean Gray Value
%==================================================================                   
                case 8
                   
                    mean_gray=zeros(maximum,1);
                    s=size(im);
                    for i =1:maximum 
                        grayValue=0;
                        for ver = floor(bobo(i,1)) : ceil(bobo(i,1)+bobo(i,3))
                             if (ver > s(1)) break; end
                         for hor = floor(bobo(i,2)) : ceil(bobo(i,2)+bobo(i,4))
                             if (ver == 0 | hor > s(2)) break; end
                             if (hor ~= 0)  
                                if water(ver,hor) == i
                                    grayValue = grayValue + double(im(ver,hor));  
                                end
                             end                                    
                         end  
                        end
                        mean_gray(i) = grayValue/oppStats(i);   
                    end    
                    tex=mean_gray;
                     
                    
 end   % end switch
 


                
