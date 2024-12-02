function scenedetector(START,EIND)
cd blobdata
load (['cars' num2str(START)]);
first=cars2;
index=1;
scenes=zeros(4000,2);
for beeld=START:EIND
    [beeld START EIND]
    cd ../blobdata
    load(['cars' num2str(beeld+1)]);
    second=cars2;
    verschil=xor(first,second);
    scenes(index,1)=beeld;
    scenes(index,2)=sum(verschil(:));
    index=index+1;
    first=second;
    cd ../verschildata
    save(['versch-' num2str(START) '-' num2str(EIND)],'scenes')
end

