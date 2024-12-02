% deze functie transfereert de data uit handles structure naar savedhandles
function savesession(handles)

savehandles.file_is_open=handles.file_is_open;
savehandles.coordselected=handles.coordselected;
savehandles.ROIselected=handles.ROIselected;
savehandles.watershedselected=handles.watershedselected;
savehandles.parameterselected=handles.parameterselected;
savehandles.differenceselected=handles.differenceselected;

if ismember('ROI',fieldnames(handles)) %ismember(A,X) checks for existence of A in X /fieldnames(structure) gives fieldnames of the structrure
    savehandles.ROI=handles.ROI;
end

if ismember('image',fieldnames(handles))
    savehandles.image=handles.image;
end

if ismember('saveimage',fieldnames(handles))
    savehandles.saveimage=handles.saveimage;
end

if ismember('rect',fieldnames(handles))
    savehandles.rect=handles.rect;
end

if ismember('water',fieldnames(handles))
    savehandles.water=handles.water;
end

if ismember('maximum',fieldnames(handles))
    savehandles.maximum=handles.maximum;
end

if ismember('bobo',fieldnames(handles))
    savehandles.bobo=handles.bobo;
end

if ismember('texture',fieldnames(handles))
    savehandles.texture=handles.texture;
end

if ismember('verschil',fieldnames(handles))
    savehandles.verschil=handles.verschil;
end

if ismember('startlabel',fieldnames(handles))
    savehandles.startlabel=handles.startlabel;
end





