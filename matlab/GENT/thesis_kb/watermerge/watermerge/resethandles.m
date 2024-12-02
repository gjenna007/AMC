% Deze functie reset de booleans in de handles structure van WaterMerge en
% wist de data, zodat die niet interfereert met nieuwe data

function handles_return = resethandles(handles);

handles.coordselected=0;
handles.ROIselected=0;
handles.watershedselected=0;
handles.differenceselected=0;
handles.mergeselected=0;

if ismember('ROI',fieldnames(handles)) %ismember(A,X) checks for existence of A in X /fieldnames(structure) gives fieldnames of the structrure
    handles=rmfield(handles,'ROI');
end

if ismember('image',fieldnames(handles))
    handles=rmfield(handles,'image');
end

if ismember('rect',fieldnames(handles))
    handles=rmfield(handles,'rect');
end

if ismember('water',fieldnames(handles))
    handles=rmfield(handles,'water');
end

if ismember('maximum',fieldnames(handles))
    handles=rmfield(handles,'maximum');
end

if ismember('bobo',fieldnames(handles))
    handles=rmfield(handles,'bobo');
end

if ismember('texture',fieldnames(handles))
    handles=rmfield(handles,'texture');
end

if ismember('verschil',fieldnames(handles))
    handles=rmfield(handles,'verschil');
end

if ismember('startlabel',fieldnames(handles))
    handles=rmfield(handles,'startlabel');
end

handles_return=handles;