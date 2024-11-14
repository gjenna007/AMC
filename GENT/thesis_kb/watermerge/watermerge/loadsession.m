%Deze functie zorgt dat gesavede handles data geladen wordt en de huidige vervangt
%savedhandles wordt geladen vanuit .mat file via load en de data gekoppeld aan handles 
%wordt gelijkgesteld aan die in savedhandles (enkel data en niet objecthandles!)

function handles_return = loadsession(handles, file)


load(file);
handles = resethandles(handles); %structure velden die niet in savedhandles aanwezig zijn moeten verwijderd zijn uit handles

%data in handles gelijk stellen aan die in savedhandles

handles.file_is_open=savedhandles.file_is_open;
handles.coordselected=savedhandles.coordselected;
handles.ROIselected=savedhandles.ROIselected;
handles.watershedselected=savedhandles.watershedselected;
handles.differenceselected=savedhandles.differenceselected;
handles.mergeselected=savedhandles.mergeselected;

handles.savedthreshold=savedhandles.savedthreshold;
handles.savedtheta=savedhandles.savedtheta;
handles.savedD=savedhandles.savedD;
handles.savedparameter=savedhandles.savedparameter;
handles.saveddifference=savedhandles.saveddifference;
handles.savedcoordtextbox=savedhandles.savedcoordtextbox;
handles.savedcurrentfile=savedhandles.savedcurrentfile;
handles.savedsurfaceresulttextbox=savedhandles.savedsurfaceresulttextbox;
handles.savedgrayvalueresulttextbox=savedhandles.savedgrayvalueresulttextbox;



if ismember('ROI',fieldnames(savedhandles)) %ismember(A,X) checks for existence of A in X /fieldnames(structure) gives fieldnames of the structrure
    handles.ROI=savedhandles.ROI;
end

if ismember('image',fieldnames(savedhandles))
    handles.image=savedhandles.image;
end

if ismember('saveimage',fieldnames(savedhandles))
    handles.saveimage=savedhandles.saveimage;
end

if ismember('rect',fieldnames(savedhandles))
    handles.rect=savedhandles.rect;
end

if ismember('water',fieldnames(savedhandles))
    handles.water=savedhandles.water;
end

if ismember('maximum',fieldnames(savedhandles))
    handles.maximum=savedhandles.maximum;
end

if ismember('bobo',fieldnames(savedhandles))
    handles.bobo=savedhandles.bobo;
end

if ismember('texture',fieldnames(savedhandles))
    handles.texture=savedhandles.texture;
end

if ismember('verschil',fieldnames(savedhandles))
    handles.verschil=savedhandles.verschil;
end

if ismember('startlabel',fieldnames(savedhandles))
    handles.startlabel=savedhandles.startlabel;
end

if ismember('mergedareas',fieldnames(savedhandles))
    handles.mergedareas=savedhandles.mergedareas;
end

if ismember('grayvalues',fieldnames(savedhandles))
    handles.grayvalues=savedhandles.grayvalues;
end

if ismember('grayvalueresult',fieldnames(savedhandles))
    handles.grayvalueresult=savedhandles.grayvalueresult;
end
clear savedhandles;
handles_return=handles;
