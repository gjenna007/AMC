%rood kleuren van opgegeven pixelcoordinaten (edge) in beeld (im)

function mergedarea_return = show_outeredge(im, edge)

%---zet beeld om naar RGB
s=size(im);
mergedarea=zeros(s(1),s(2),3);
mergedarea(:,:,1)=im;
mergedarea(:,:,2)=im;
mergedarea(:,:,3)=im;

lengteEdge=size(edge);

%---kleur buitenste rand van merged area rood

for i=1:size(edge,1)    
   mergedarea(edge(i,1),edge(i,2),1)=255;
   mergedarea(edge(i,1),edge(i,2),2)=0;
   mergedarea(edge(i,1),edge(i,2),3)=0;
end  

mergedarea_return=mergedarea;

