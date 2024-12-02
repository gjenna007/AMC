% deze functie bepaalt de cooccurentiematrix van een watershedsegment
% coocc(label, im, bobo, water, oppStats, theta, D)
% input: 
%   label: watershedlabel van het segment 
%   im: beeld
%   bobo: boundingboxen van de segmenten
%   water: watershedmatrix
%   oppStats: oppervlakte van elk segment
%   theta en D: hoek en afstand voor berekening cooccurentiematrix
% output: cooccurentiematrix voor segment met opgegeven label
% opm: de cooccurentiematrix wordt enkel berekend voor gebieden met een oppervlakte 
% groter dan min_opp (pixels); voor de kleinere gebieden is de cooccurentiematrix de nulmatrix
% de hoek theta wordt beschouwd vanuit de linkeronderhoek van het beeld!!

function cooccreturn = coocc(label, im, bobo, water, oppStats, theta, D)

min_opp=20;
i=label;

theta=str2double(theta);
D=str2double(D);

cooccr=zeros(256,256);
radcos=cos(theta*pi/180);
radsin=sin(theta*pi/180);
s=size(im);


%kwadrant1
if (theta >= 0 & theta < 90)   
    if(oppStats(i) >= min_opp)
        
        for ver = floor(bobo(i,1)+D*radsin) : ceil(bobo(i,1) + bobo(i,3))
            if (ver > s(1)) break; end
            for hor = floor(bobo(i,2)) : ceil(bobo(i,2) + bobo(i,4)-D*radcos)
                if (ver == 0) break; end
                if (hor ~= 0) 
                    if (hor > s(2))  break; end 
                    begin = im(ver,hor);
		            eindver=ceil(ver-D*radsin);
                    eindhor=ceil(hor+D*radcos);
                    if (eindver <= 0) break; end
                    if (eindhor <= 0) break; end
                    if (eindver > s(1)) break; end
                    if (eindhor > s(2)) break; end 
		            eind = im(eindver, eindhor);
                    if water(ver,hor) == i & water(eindver,eindhor) == i
    		            cooccr(begin,eind) = cooccr(begin,eind) + 1;
                    end  
                end
	        end
        end  
    end  
    cooccreturn=cooccr;


%kwadrant2  
elseif (theta >= 90 & theta < 180) 
    if(oppStats(i)>= min_opp)
        for ver = floor(bobo(i,1)+D*radsin) : ceil(bobo(i,1) + bobo(i,3))
            if (ver > s(1)) break; end
            for hor = floor(bobo(i,2)-D*radcos) : ceil(bobo(i,2) + bobo(i,4))
                if (ver == 0) break; end
                if (hor ~= 0) 
                    if (hor > s(2))  break; end 
                    begin = im(ver,hor);
                    eindver=ceil(ver-D*radsin);
                    eindhor=floor(hor+D*radcos);
                    if (eindver <= 0) break; end
                    if (eindhor <= 0) break; end
                    if (eindver > s(1)) break; end
                    if (eindhor > s(2)) break; end 
		                eind = im(eindver, eindhor);
                    if water(ver,hor) == i & water(eindver,eindhor) == i
    		            cooccr(begin,eind) = cooccr(begin,eind) + 1;
                    end
	            end
            end
        end        
    end     
    cooccreturn=cooccr;

%kwadrant3
elseif (theta >= 180 & theta < 270)

    if(oppStats(i)>= min_opp)
        for ver = floor(bobo(i,1)) : ceil(bobo(i,1) + bobo(i,3)+D*radsin)
            if (ver > s(1)) break; end
            for hor = floor(bobo(i,2)-D*radcos) : ceil(bobo(i,2) + bobo(i,4))
                if (ver == 0) break; end
                if (hor ~= 0) 
                    if (hor > s(2))  break; end 
                    begin = im(ver,hor);
                    [ver, hor];
                    eindver=floor(ver-D*radsin);
                    eindhor=floor(hor+D*radcos);
                    if (eindver <= 0) break; end
                    if (eindhor <= 0) break; end
                    if (eindver > s(1)) break; end
                    if (eindhor > s(2)) break; end 
		            eind = im(eindver, eindhor);
    		        if water(ver,hor) == i & water(eindver,eindhor) == i    
                        cooccr(begin,eind) = cooccr(begin,eind) + 1;
                    end        
                end
            end
        end
    end     
    cooccreturn=cooccr;
    

%kwadrant4       
elseif (theta >= 270 & theta <= 360)
    if(oppStats(i)>= min_opp)
        for ver = floor(bobo(i,1)) : ceil(bobo(i,1) + bobo(i,3)+D*radsin)
            if (ver > s(1)) break; end
            for hor = floor(bobo(i,2)) : ceil(bobo(i,2) + bobo(i,4)-D*radcos)
                if (ver == 0) break; end
                if (hor ~= 0) 
                    if (hor > s(2))  break; end 
                    begin = im(ver,hor);
		            eindver=floor(ver-D*radsin);
                    eindhor=ceil(hor+D*radcos);
                    if (eindver <= 0) break; end
                    if (eindhor <= 0) break; end
                    if (eindver > s(1)) break; end
                    if (eindhor > s(2)) break; end 
		            eind = im(eindver, eindhor);
                    if water(ver,hor) == i & water(eindver,eindhor) == i
        		        cooccr(begin,eind) = cooccr(begin,eind) + 1;
                    end    
                end
            end
        end
    end
    
end   

cooccreturn=cooccr;


