%Deze functie geeft aan of een pixel een randpixel van de gemergde segmenten is
%Dit gebeurt aan de hand van de labels van de buurpixels (hulp) en de labels van de
%te mergen areas (mergeareas)
%               isedge(buren,mergeareas)
%Er moet minstens één label behoren tot mergeareas en minstens één niet.
%wanneer veel randen samenkomen: testNul >= 6
%Dit laatste kan losse pixels veroorzaken, maar die worden verder in outeredge.m verwijderd
%output: boolean 1 (is een buitenrand) of 0 (is geen buitenrand)

function isedge_terug = isedge(buren,mergeareas)
    
test=0;
s=size(buren);

testEigen=sum(ismember(buren,mergeareas));
testNul=sum(ismember(buren,0));
testVreemd=s(1)-testEigen-testNul;

if (testEigen > 0 & testVreemd > 0) | testNul >= 6
    test=1;        
end

isedge_terug=test;