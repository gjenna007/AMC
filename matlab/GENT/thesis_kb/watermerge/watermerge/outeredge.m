% function outeredge geeft de coordinaten van de randgebieden van de te mergen gebieden
% Eveneens wordt de bounding box van de gemergde gebieden gegeven
%       outeredge(im,mergeareas,bobo,water)
% input:
%   im: beeld
%   mergeareas: de labels van de gemergde segmenten bepaald met mergen.m
%   bobo: de boundingboxen van de segmenten
%   water: de watershedmatrix 
% output: [edge_coord, bobo_mergedsegment] 
%   edge_coord: de coordinaten van de buitenste rand van de gemergde segmenten als matrix met twee kolommen (ver, hor) en per rij een coordinaat 
%   bobo_mergedsegment: de boundingbox van het gemergde segment  



function [edge_coord, bobo_mergedsegment] = outeredge(im,mergeareas,bobo,water)

s=size(im);

%---Bepaling van de omhullende rechthoek van de samen te voegen segmenten

ver_klein = s(1);
ver_groot = 0;
hor_klein = s(2);
hor_groot = 0;

for i=1:size(mergeareas)
    ver_klein_tussen = bobo(mergeareas(i),1);
    ver_groot_tussen = bobo(mergeareas(i),1)+bobo(mergeareas(i),3);
    hor_klein_tussen = bobo(mergeareas(i),2);
    hor_groot_tussen = bobo(mergeareas(i),2)+bobo(mergeareas(i),4);
        
    if ver_klein_tussen < ver_klein
        ver_klein = ver_klein_tussen;
    end
    if ver_groot_tussen > ver_groot
        ver_groot = ver_groot_tussen;
    end
    if hor_klein_tussen < hor_klein
        hor_klein = hor_klein_tussen;
    end
    if hor_groot_tussen > hor_groot
        hor_groot = hor_groot_tussen;
    end
end


hoogte_groot=ver_groot-ver_klein;
breedte_groot=hor_groot-hor_klein;
bobo_groot=[ver_klein; hor_klein; hoogte_groot; breedte_groot];


%---Bepalen welke pixels van de watershed randen behoren tot de buitenste rand

edge_coord_tussen=[];
hulp=[];
s=size(im);

for ver = floor(bobo_groot(1)) : ceil(bobo_groot(1) + bobo_groot(3))
    if (ver > s(1)) break; end
    for hor = floor(bobo_groot(2)) : ceil(bobo_groot(2) + bobo_groot(4))
       if (ver == 0) break; end
       if (hor ~= 0) 
            if (hor > s(2)) break; end 
            if water(ver,hor) == 0  %pixel binnen boundingbox moet een rand zijn
                k=1;
                %aflopen buren (hulp)
                for hor2 = hor-1:hor+1
                    for ver2 = ver-1:ver+1
                        if ~(ver2 == ver & hor2 == hor) % enkel buren testen
                            if ver2 ~= 0 & hor2 ~= 0 & ver2 <= s(1) & hor2 <= s(2) %voorwaarde wanneer grens v/h beeld bereikt is
                            hulp(k,1)=water(ver2,hor2);
                            k=k+1;
                            end 
                        end                    
                    end
                end           
                %adhv de buren kijken indien de pixel bij de edge hoort of niet  
                if isedge(hulp,mergeareas)  %dan is grens gevonden
                    edge_coord_tussen=[edge_coord_tussen; ver hor];   
                end                     
            end        
        end
    end %einde boundingbox
end %einde boundingbox

%---Bepalen van segmentrandcoördinaten die tevens aan de rand van de selectie lopen
 
%horboven

for hor=1:s(2)
   if ismember(water(1,hor),mergeareas) %als de pixel behoort tot een segment van de te mergen areas=> randcoordinaat!
       edge_coord_tussen=[edge_coord_tussen; 1 hor]; 
   end
   if water(1,hor)==0 %als de randpixel een watershed rand is => controleren indien een van de buren behoort tot een segment van de te mergen areas
       horlinks=hor-1;
       horrechts=hor+1;
       if (horlinks < 1) horlinks=hor; end
       if (horrechts > s(2)) horrechts=hor; end
       hulp=water(2,horlinks:horrechts);%buren
       i=1;
       while sum(hulp)==0 %als alle buren zelf een rand zijn, kijk een buur verder
           hulp=water(2+i,horlinks:horrechts);
       end
       if sum(ismember(hulp,mergeareas)) > 0
            edge_coord_tussen=[edge_coord_tussen; 1 hor];
       end
   end
end  

%horonder
for hor=1:s(2)
   if ismember(water(s(1),hor),mergeareas) %als de pixel behoort tot een segment van de te mergen areas=> randcoordinaat!
       edge_coord_tussen=[edge_coord_tussen; s(1) hor]; 
   end
   if water(s(1),hor)==0 %als de randpixel een watershed rand is => controleren indien een van de buren behoort tot een segment van de te mergen areas
       horlinks=hor-1;
       horrechts=hor+1;
       if (horlinks < 1) horlinks=hor; end
       if (horrechts > s(2)) horrechts=hor; end
       hulp=water(s(1)-1,horlinks:horrechts); %buren
       i=2;
       while sum(hulp)==0 %als alle buren zelf een rand zijn, kijk een buur verder
           hulp=water(s(1)-i,horlinks:horrechts);
           i=i+1;
       end
       if sum(ismember(hulp,mergeareas)) > 0
            edge_coord_tussen=[edge_coord_tussen; s(1) hor];
       end
   end
end  

%verlinks
for ver=1:s(1)
   if ismember(water(ver,1),mergeareas)
       edge_coord_tussen=[edge_coord_tussen; ver 1]; %als de pixel behoort tot een segment van de te mergen areas=> randcoordinaat!
   end
   if water(ver,1)==0 %als de randpixel een watershed rand is => controleren indien een van de buren behoort tot een segment van de te mergen areas
       verboven=ver-1;
       veronder=ver+1;
       if (verboven < 1) verboven=hor; end
       if (veronder > s(1)) veronder=hor; end
       hulp=water(verboven:veronder,2); %buren
       i=1;
       while sum(hulp)==0 %als alle buren zelf een rand zijn, kijk een buur verder
           hulp=water(verboven:veronder,2+i);
           i=i+1;
       end
       if sum(ismember(hulp,mergeareas)) > 0
            edge_coord_tussen=[edge_coord_tussen; ver 1];
       end
   end
end  

%verrechts
for ver=1:s(1)
   if ismember(water(ver,s(2)),mergeareas) %als de pixel behoort tot een segment van de te mergen areas=> randcoordinaat!
       edge_coord_tussen=[edge_coord_tussen; ver s(2)]; 
   end
   if water(ver,s(2))==0 %als de randpixel een watershed rand is => controleren indien een van de buren behoort tot een segment van de te mergen areas
       verboven=ver-1;
       veronder=ver+1;
       if (verboven < 1) verboven=hor; end
       if (veronder > s(1)) veronder=hor; end
       hulp=water(verboven:veronder,s(2)-1); %buren
       i=2;
       while sum(hulp)==0 %als alle buren zelf een rand zijn, kijk een buur verder
           hulp=water(verboven:veronder,s(2)-i);
           i=i+1;
       end
       if sum(ismember(hulp,mergeareas)) > 0
            edge_coord_tussen=[edge_coord_tussen; ver s(2)];
       end
   end
end  

%---hoeken volledig maken

for i=1:size(edge_coord_tussen,1)
    
    blb=[edge_coord_tussen(i,1)-1,edge_coord_tussen(i,2)-1];%buurlinksboven
    brb=[edge_coord_tussen(i,1)-1,edge_coord_tussen(i,2)+1];%buurrechtsboven
    blo=[edge_coord_tussen(i,1)+1,edge_coord_tussen(i,2)-1];%buurlinksonder
    bro=[edge_coord_tussen(i,1)+1,edge_coord_tussen(i,2)+1];%buurrechtsonder
    
    if max(ismember(edge_coord_tussen(:,1), blb(1)) + ismember(edge_coord_tussen(:,2), blb(2)) ) == 2
        if max(ismember(edge_coord_tussen(:,1), blb(1)) + ismember(edge_coord_tussen(:,2), edge_coord_tussen(i,2)))~=2 & max(ismember(edge_coord_tussen(:,1), edge_coord_tussen(i,1)) + ismember(edge_coord_tussen(:,2), blb(2)))~=2
            edge_coord_tussen = [edge_coord_tussen; blb(1), edge_coord_tussen(i,2)]; 
        end            
    end
    if max(ismember(edge_coord_tussen(:,1), brb(1)) + ismember(edge_coord_tussen(:,2), brb(2)) ) == 2
        if max(ismember(edge_coord_tussen(:,1), brb(1)) + ismember(edge_coord_tussen(:,2), edge_coord_tussen(i,2)))~=2 & max(ismember(edge_coord_tussen(:,1), edge_coord_tussen(i,1)) + ismember(edge_coord_tussen(:,2), brb(2)))~=2
            edge_coord_tussen = [edge_coord_tussen; brb(1), edge_coord_tussen(i,2)]; 
        end            
    end
    if max(ismember(edge_coord_tussen(:,1), blo(1)) + ismember(edge_coord_tussen(:,2), blo(2)) ) == 2
        if max(ismember(edge_coord_tussen(:,1), blo(1)) + ismember(edge_coord_tussen(:,2), edge_coord_tussen(i,2)))~=2 & max(ismember(edge_coord_tussen(:,1), edge_coord_tussen(i,1)) + ismember(edge_coord_tussen(:,2), blo(2)))~=2
            edge_coord_tussen = [edge_coord_tussen; blo(1), edge_coord_tussen(i,2)]; 
        end            
    end
    if max(ismember(edge_coord_tussen(:,1), bro(1)) + ismember(edge_coord_tussen(:,2), bro(2)) ) == 2
        if max(ismember(edge_coord_tussen(:,1), bro(1)) + ismember(edge_coord_tussen(:,2), edge_coord_tussen(i,2)))~=2 & max(ismember(edge_coord_tussen(:,1), edge_coord_tussen(i,1)) + ismember(edge_coord_tussen(:,2), bro(2)))~=2
            edge_coord_tussen = [edge_coord_tussen; bro(1), edge_coord_tussen(i,2)]; 
        end            
    end  
    
end

%---------verwijderen losse pixels
teller=0;

while teller < 3 %driemaal doorlopen van procedure om samenliggende losse pixels (tot 6) te voorkomen, éénmaal volstaat voor enkele losse pixel
    
edge_coord_tussen2=[];

for i=1:size(edge_coord_tussen,1)
    
    %4 horizontale buren
    buren=[edge_coord_tussen(i,1)-1,edge_coord_tussen(i,2);edge_coord_tussen(i,1),edge_coord_tussen(i,2)-1];
    buren=[buren;edge_coord_tussen(i,1),edge_coord_tussen(i,2)+1;edge_coord_tussen(i,1)+1,edge_coord_tussen(i,2)];
    
    %tellen hoeveel buren voorkomen in edge_coord_tussen 
    coordpresent=0;
    for j=1:size(buren,1)
        if max( ismember(edge_coord_tussen(:,1), buren(j,1)) + ismember(edge_coord_tussen(:,2), buren(j,2)) ) == 2
           coordpresent=coordpresent+1;
        end           
    end
    
    % als er één of geen geburen voorkomen in edge_coord_tussen => losse pixel en dus niet toevoegen bij randcoordinaten
    if coordpresent > 1
        edge_coord_tussen2 = [edge_coord_tussen2; edge_coord_tussen(i,:)];
    end
end

edge_coord_tussen=edge_coord_tussen2;
teller=teller+1;

end %while

edge_coord=edge_coord_tussen;
bobo_mergedsegment=bobo_groot;    

