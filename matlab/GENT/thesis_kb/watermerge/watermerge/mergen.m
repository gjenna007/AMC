% functie die, gegeven het label van een gebied, de omringende te mergen segmenten bepaalt
% het mergen gebeurt op basis van een bepaalde parameter en een maximaal toegestane afwijking
%       mergen(im, startlabel, verschil, startpar, bobo, water, text) 
% input: 
%   im: beeld
%   startlabel: label van het startsegment
%   verschil: toegestane maximale afwijking
%   startpar: waarde van de parameter van het eerste segment
%   water: watershedmatrix
%   bobo: boundingboxen van de watershedsegmenten
%   text: parameterwaarde voor elk segment
% output: labels van de samengevoegde segmenten

function  mergeareas_def = mergen(im, startlabel, verschil, startpar, bobo, water, text)

global mergeareas_tussen;
i=startlabel;
hulp=[];
mergeareas_tussen=[mergeareas_tussen; startlabel];
s=size(im);

for ver = floor(bobo(i,1)) : ceil(bobo(i,1) + bobo(i,3))
    if (ver > s(1)) break; end
    for hor = floor(bobo(i,2)) : ceil(bobo(i,2) + bobo(i,4))
        if (ver == 0) break; end
        if (hor ~= 0) 
                if (hor > s(2)) break; end 
                grensgevonden=0;     
                if water(ver,hor) == 0
                    
                    k=1;
                    
                    for hor2 = hor-1:hor+1
                        for ver2 = ver-1:ver+1
                            if ~(ver2 == ver & hor2 == hor) %eigen pixel niet, enkel buren
                                if ~(ver2 == 0 | hor2 == 0 | ver2 > s(1) | hor2 >s(2)) % mag niet buiten grenzen beeld gaan
                                    label=water(ver2,hor2);
                                    if label==i grensgevonden=1; end
                                    if label ~= 0;
                                        hulp(k)=label;
                                        k=k+1;
                                    end
                                end
                            end
                        end
                    end
          
                    if grensgevonden
                        for m=1:size(hulp,2)                
                            if ismember(hulp(m),mergeareas_tussen) == 0 %dubbele voorkomen
                                if text(hulp(m)) == NaN %voeg gebiedjes kleiner dan 20 toe aan de te mergen gebiedjes
                                      mergeareas_tussen=[mergeareas_tussen; hulp(m)];
                                elseif abs(text(hulp(m)) - startpar) <= verschil %indien verschil tussen parameter startsegment en parameter buur kleiner is dan vooropgesteld verschil 
                                      mergeareas_tussen = [mergeareas_tussen; hulp(m)];
                                      mergen(im, hulp(m), verschil, startpar, bobo, water, text);  %recursief kijken naar aangrenzende segmenten van nieuw toegevoegd segment
                                end
                            end
                        end
                    end
                    
                end %end van if water(ver,hor) == 0
        end %end van if (hor ~= 0)
    end
end


mergeareas_def=mergeareas_tussen;



                