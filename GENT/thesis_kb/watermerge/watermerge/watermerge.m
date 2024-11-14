
function varargout = watermerge(varargin)
% WATERMERGE Application M-file for watermerge.fig
%    FIG = WATERMERGE launch watermerge GUI.
%    WATERMERGE('callback_name', ...) invoke the named callback.

% Last Modified 23-May-2002 22:42:38

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    %initialisatie van data bij opstarten WaterMerge GUI
    imagefilelist=[];
    handles.imagefilelist=imagefilelist;
    handles.file_is_open=0;
    handles.coordselected=0;
    handles.ROIselected=0;
    handles.watershedselected=0;
    handles.differenceselected=0;
    set(handles.parameter_popupmenu,'Value',8);
    handles.mergeselected=0;
    guidata(fig, handles);
    
    %directoy waarin watermerge zich bevindt, toevoegen aan path (is eigenlijk enkel maar nodig het pad nog niet is ingesteld met het menu 'Extra' van de waterMerge GUI
    addpath(pwd);
    
% deze code onder geen enkel beding wijzigen, is essentieel voor goede werking van de GUI

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function varargout = inverse_checkbox_Callback(h, eventdata, handles, varargin)

        


% --------------------------------------------------------------------
function varargout = File_menu_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = Open_submenu_Callback(h, eventdata, handles, varargin)
           
    %openen file
    if size(handles.imagefilelist,1) < 8
        
        [filename, pathname] = uigetfile({'*.tiff;*.tif;*.bmp;*.jpg','Images (*.tiff;*.tif;*.bmp;*.jpg)';'*.*','All files (*.*)'},'Open file');
        
        %terugkeren indien geen file geselecteerd werd
        if (filename == 0)
           return
        end
        
        %resetten handles data en boolean file_is_open op true (1) zetten
        handles.file_is_open=1;
        handles=resethandles(handles);
        
        
        imagefile=[pathname filename];
        imagefilelist=handles.imagefilelist;
        
        %controleren of imagefile al in imagefilelist zit, zoniet: voeg toe aan imagefilelist
        filenotdouble=1;        
        for i=1:size(handles.imagefilelist,1)
            file=handles.imagefilelist(i,:);
            if strncmp(imagefile, file, size(imagefile,2))
                filenotdouble=0;
            end
        end
        if filenotdouble 
            imagefilelist=strvcat(imagefilelist, imagefile);
        end
       
        im=imread(imagefile);
        handles.image=im;
        handles.imagefilelist=imagefilelist;
        guidata(h, handles);
        imshow(im);
        handles.saveimage=im;
        guidata(h, handles);
        set(handles.currentfile_textbox,'String',imagefile);
        
        %slider op nul zetten en tekstboxen leeg maken
        set(handles.max_textbox, 'String', 'max'); 
        set(handles.difference_textbox, 'String', '0');
        set(handles.difference_slider,'Value',0);
        set(handles.coordinate_textbox,'String','0');
        set(handles.surfaceresult_textbox,'String','');
        set(handles.grayvalueresult_textbox, 'String', '');
        %messages
        set(handles.message_textbox,'String', 'Select the region of interest (ROI)');
    
        %'Window' submenus aanpassen
        items = get(handles.Window_menu,'children');
        delete(items);
        for i=1:size(handles.imagefilelist,1)
            callbackfcn = ['watermerge(''select_image_Callback'',gcbo,[],guidata(gcbo),' num2str(i) ')'];
            uimenu(handles.Window_menu, 'label',handles.imagefilelist(i,:),'Callback',callbackfcn);
        end
    
    else % indien size imagefilelist > 8
        msgbox(sprintf('      You can open only 8 images!\n Close one or more files if you want\n         to open a new file.'), 'Warning', 'error'); %
    end
    
    % re-activeren zoom indien zoom togglebutton ingedrukt is
    if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData',zoompointer); end

% -------------------------------------------------------------------
%Deze callbackfunctie hoort bij 'Window' submenu (wordt telkens vernieuwd bij bij openen file/close file of load session) 
%elke submenu krijgt zo'n callbackfunctie waarbij via varargin het nummer in de imagefilelist wordt meegegeven
function varargout = select_image_Callback(h, eventdata, handles, varargin)
       
       %resetten handles data
       handles.file_is_open=1;
       handles=resethandles(handles);
       
       i=varargin{1};
       im=imread(handles.imagefilelist(i,:));
       handles.image=im;
       guidata(h, handles);
       imshow(im);
       handles.saveimage=im;
       guidata(h, handles);
       set(handles.currentfile_textbox,'String',handles.imagefilelist(i,:));
       
       set(handles.max_textbox, 'String', 'max'); 
       set(handles.difference_textbox, 'String', '0');
       set(handles.difference_slider,'Value',0);
       set(handles.coordinate_textbox,'String','0');
       set(handles.surfaceresult_textbox,'String','');
       set(handles.grayvalueresult_textbox, 'String', '');
       
       
       %messages
       set(handles.message_textbox,'String', 'Select the region of interest (ROI)');
       
       % re-activeren zoom indien zoom togglebutton ingedrukt is
       if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData',zoompointer); end    


% --------------------------------------------------------------------
function varargout = save_submenu_Callback(h, eventdata, handles, varargin)
        


% --------------------------------------------------------------------
function varargout = saveimage_submenu_Callback(h, eventdata, handles, varargin)
    
    if ismember('saveimage',fieldnames(handles))
        [filename, pathname] = uiputfile('*.tiff','Save image as');
        if (filename ~= 0)
            imwrite(handles.saveimage, [pathname filename '.tiff'],'tiff'); %extensie moet expliciet in string [pathname filename] gegeven worden (Matlab bug??) <=> uigetfile 
        end
    end
        

% --------------------------------------------------------------------
function varargout = savesession_submenu_Callback(h, eventdata, handles, varargin)
    
    [filename, pathname] = uiputfile('*.mat','Save session as');
    
    if (filename ~= 0) %controleren of bij uiputfile niet op annuleren gedrukt werd
        
        %data aan handles structure koppelen die er nog niet aan gekoppeld werd en toch belangrijk is voor een sessie
        handles.savedthreshold=get(handles.thresholdtextbox,'String');
        handles.savedtheta=get(handles.Angle_textbox,'String');
        handles.savedD=get(handles.Radius_textbox,'String');
        handles.savedparameter=get(handles.parameter_popupmenu,'Value');
        handles.saveddifference=get(handles.difference_slider,'Value');
        handles.savedcoordtextbox = get(handles.coordinate_textbox,'String');
        handles.savedcurrentfile = get(handles.currentfile_textbox,'String');
        handles.savedsurfaceresulttextbox=get(handles.surfaceresult_textbox,'String');
        handles.savedgrayvalueresulttextbox=get(handles.grayvalueresult_textbox, 'String');
                      
        savedhandles=handles;
        save([pathname filename], 'savedhandles'); %extensie niet expliciet opgeven bij pathname filename<=> uiputfile (Matlab bug?)
        clear savedhandles;
        
    end
    
    
% --------------------------------------------------------------------
function varargout = loadsession_submenu_Callback(h, eventdata, handles, varargin)
    
    [filename, pathname] = uigetfile('*.mat','Load Session');
    if filename ~= 0
        %laad sessie
        handles=loadsession(handles, [pathname filename]);
        guidata(h,handles);
        
        %toon geladen image
        if ismember('saveimage',fieldnames(handles))
            imshow(handles.saveimage);
            if handles.mergeselected==0
                rectangle('Position',handles.rect,'EdgeColor',[1 1 0],'Clipping', 'on');
            end
        end
        
        %stel tekstboxen en popupmenu in
        set(handles.thresholdtextbox,'String',handles.savedthreshold);
        set(handles.Angle_textbox,'String',handles.savedtheta);
        set(handles.Radius_textbox,'String',handles.savedD);
        set(handles.parameter_popupmenu,'Value',handles.savedparameter);
        set(handles.coordinate_textbox,'String',handles.savedcoordtextbox);
        set(handles.currentfile_textbox,'String',handles.savedcurrentfile);
        set(handles.difference_slider,'Value', handles.saveddifference);
        set(handles.difference_textbox,'String',num2str(handles.saveddifference));
        set(handles.surfaceresult_textbox,'String', handles.savedsurfaceresulttextbox);
        set(handles.grayvalueresult_textbox, 'String', handles.savedgrayvalueresulttextbox);
        
        %zet max difference_slider
        if ismember('texture',fieldnames(handles))
            verschil=ceil(max(handles.texture)-min(handles.texture));
            set(handles.max_textbox,'String',verschil);
            slider_step(1)=0.01;
            slider_step(2)=0.1;
            set(handles.difference_slider, 'sliderstep', slider_step, 'max',verschil, 'min',0); 
        end
        
        %messagebox
        if handles.ROIselected==0
            set(handles.message_textbox,'String', sprintf('Session loaded! \n\nSelect ROI.')); 
        elseif handles.watershedselected==0
            set(handles.message_textbox,'String', sprintf('Session loaded! \n\nPush Watershed button.')); 
        elseif handles.differenceselected==0  
            set(handles.message_textbox,'String', sprintf('Session loaded! \n\nSelect deviation.'));
        elseif handles.coordselected==0
            set(handles.message_textbox,'String', sprintf('Session loaded! \n\nSelect a coordinate in the ROI.'));
        elseif handles.mergeselected==0
            set(handles.message_textbox,'String', sprintf('Session loaded! \n\nPush the Merge button.'));    
        else
            set(handles.message_textbox,'String', sprintf('Session loaded!'));
        end
        
        %Imagefilelist en Window submenu aanpassen
        if exist(get(handles.currentfile_textbox,'String')) == 2 ; %exist geeft 2 terug als argument file aanwezig is 
            imagefile=get(handles.currentfile_textbox,'String');
             
            %controleren of imagefile al in imagefilelist zit, zoniet: voeg toe aan imagefilelist
            filenotdouble=1;        
            for i=1:size(handles.imagefilelist,1)
                file=handles.imagefilelist(i,:);
                if strncmp(imagefile, file, size(imagefile,2))
                    filenotdouble=0;
                end
            end
            if filenotdouble 
                handles.imagefilelist=strvcat(handles.imagefilelist, imagefile);
            end
            items = get(handles.Window_menu,'children');
            delete(items);
            for i=1:size(handles.imagefilelist,1)
                callbackfcn = ['watermerge(''select_image_Callback'',gcbo,[],guidata(gcbo),' num2str(i) ')'];
                uimenu(handles.Window_menu, 'label',handles.imagefilelist(i,:),'Callback',callbackfcn);
            end
            guidata(h,handles);
        else
            msgbox(sprintf('The original image file is not found or is in a different folder.\nTherefore, the image isn''t added to the ''Window'' menu '),'Warning', 'warn');
        end
          
    end

    
% --------------------------------------------------------------------
function varargout = savereport_submenu_Callback(h, eventdata, handles, varargin)

    if handles.mergeselected==1

    [filename, pathname] = uiputfile('*.xls','save report as');

    a=strrep([get(handles.currentfile_textbox,'String')],'\','\\'); %enkele slash vervangen door dubbele, anders verwarring bij opmaak via sprintf
    a=['filename:\t ' a '\n'];
    a=[a 'date:\t ' date '\n'];
    a=[a 'ROI:\thor:\t' num2str(handles.rect(1)) '\n'];
    a=[a '\tver:\t ' num2str(handles.rect(2)) '\n'];
    a=[a '\twidth:\t ' num2str(handles.rect(3)) '\n'];
    a=[a '\theight:\t ' num2str(handles.rect(4)) '\n'];
    a=[a 'threshold:\t' get(handles.thresholdtextbox,'String') '\n' ];
    a=[a 'deviation:\t' num2str(get(handles.difference_slider,'Value')) '\n'];
    a=[a 'startsegment:\t' get(handles.coordinate_textbox,'String') '\n'];
    a=[a 'surface:\t' num2str(sum(sum(ismember(handles.water,handles.mergedareas)))) '\n'];
    a=[a 'mean gray value:\t' num2str(handles.grayvalueresult) '\n'];

    dlmwrite([pathname filename '.xls'], sprintf(a),''); %het sprintf commando zorgt voor een goede interpretatie van escape karakters
    imwrite(handles.saveimage, [pathname filename '.tiff'],'tiff');

    else
        set(handles.message_textbox,'String', 'Complete the watermerge procedure first!');
    end    
    

% --------------------------------------------------------------------
function varargout = Close_submenu_Callback(h, eventdata, handles, varargin)
    
pos_size = get(handles.figure1,'Position');
user_response = closewindow([pos_size(1)+pos_size(3)/2 pos_size(2)+pos_size(4)/2]);

switch user_response
    
case {'no','cancel'}
	return %  no action
    
case 'yes'        
    % te sluiten file verwijderen uit imagefilelist
    file_close=get(handles.currentfile_textbox,'String');
    imagefilelist_tussen=[];
    for i=1:size(handles.imagefilelist,1)
        imagefile=handles.imagefilelist(i,:);
        if strncmp(file_close, imagefile, size(file_close,2)) == 0
            imagefilelist_tussen=strvcat(imagefilelist_tussen, imagefile);
        end
    end
    handles.imagefilelist=imagefilelist_tussen;
    guidata(h, handles);

    %resetten handles data
    handles.file_is_open=1;
    handles=resethandles(handles);
    
    %'Window' submenus aanpassen
    items = get(handles.Window_menu,'children');
    delete(items);
    for i=1:size(handles.imagefilelist,1)
       callbackfcn = ['watermerge(''select_image_Callback'',gcbo,[],guidata(gcbo),' num2str(i) ')'];
       uimenu(handles.Window_menu, 'label',handles.imagefilelist(i,:),'Callback',callbackfcn);
    end
    
    %textboxen en sliders resetten
    set(handles.max_textbox, 'String', 'max'); 
    set(handles.difference_textbox, 'String', '0');
    set(handles.difference_slider,'Value',0);
    set(handles.coordinate_textbox,'String','0');
    set(handles.surfaceresult_textbox,'String','');
    set(handles.grayvalueresult_textbox, 'String', '');
               
    %laatste image van imagefilelist tonen
    if size(handles.imagefilelist,1) >= 1
        im=imread(handles.imagefilelist(size(handles.imagefilelist,1),:));
        handles.image=im;
        guidata(h, handles);
        imshow(im);
        handles.saveimage=im;
        guidata(h, handles);
        set(handles.currentfile_textbox,'String',handles.imagefilelist(size(handles.imagefilelist,1),:));
       
        set(handles.message_textbox,'String', 'Select the region of interest (ROI)');     
    else %indien imagefilelist leeg is
        im=[];
        imshow(uint8(im));
        handles.saveimage=im;
        guidata(h, handles);
        set(handles.currentfile_textbox,'String','');
        set(handles.message_textbox,'String', 'Open an image file'); 
    end
    
    % re-activeren zoom indien zoom togglebutton ingedrukt is
    if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData',zoompointer); end    
    
end


% --------------------------------------------------------------------
function varargout = Exit_submenu_Callback(h, eventdata, handles, varargin)

    pos_size = get(handles.figure1,'Position');
    user_response = exitwindow([pos_size(1)+pos_size(3)/3 pos_size(2)+pos_size(4)/2]);
    switch user_response
    case {'no','cancel'}
	    return % no action
    case 'yes'
		delete(handles.figure1) %WaterMerge sluiten
    end


% --------------------------------------------------------------------
function varargout = Window_menu_Callback(h, eventdata, handles, varargin)
        
                
       
% --------------------------------------------------------------------
function varargout = extra_menu_Callback(h, eventdata, handles, varargin)
        

% --------------------------------------------------------------------
function varargout = setpath_submenu_Callback(h, eventdata, handles, varargin)
        pathtool;
            

% --------------------------------------------------------------------
function varargout = About_menu_Callback(h, eventdata, handles, varargin)
        pos_size = get(handles.figure1,'Position');
        about([pos_size(1)+pos_size(3)/3 pos_size(2)+pos_size(4)/4]);
              

% --------------------------------------------------------------------
function varargout = Angle_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = Radius_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = selectROI_pushbutton_Callback(h, eventdata, handles, varargin)

        if handles.file_is_open
            handles.ROIselected=1;
            handles.coordselected=0;           
            handles.watershedselected=0;
            handles.differenceselected=0;
            set(handles.coordinate_textbox,'String','0'); 
            set(handles.difference_slider,'Value',0);
            set(handles.difference_textbox,'String','0');
            set(handles.surfaceresult_textbox,'String','');
            set(handles.grayvalueresult_textbox, 'String', '');
            set(handles.max_textbox, 'String', 'max'); 
            imshow(handles.image); %hernieuwen image zodat selectie opnieuw kan gemaakt worden
            handles.saveimage=handles.image;
            [A,rect] = imcrop; %A=ROI, rect=coordinaten van ROI (x,y,width, height)
            rectangle('Position', rect, 'EdgeColor', [1 1 0], 'Clipping', 'on'); %teken rechthoek
            handles.ROI=A;
            rect(1)=round(rect(1))-1;%niet vervangen door floor!!!
            rect(2)=round(rect(2))-1;%niet vervangen door floor!!!
            rect(3)=round(rect(3));%niet vervangen door ceil!!!
            rect(4)=round(rect(4));%niet vervangen door ceil!!!
            handles.rect=rect;
            set(handles.message_textbox,'String', sprintf('Uncheck ''Inverse image'' if you want segmentation of regions darker than the background \nAn estimation of the threshold is calculated automatically. \nPush the Watershed button to apply the Watershed algoritm on the ROI.\nIf necessary change the threshold manually and perform Watershed again.'));
            thresholdGrayValue=round(mean2(A)-1/3*std2(A)); %berekenen van schatting threshold
            set(handles.thresholdtextbox,'String',num2str(thresholdGrayValue));
            handles.mergeselected=0;
            guidata(h,handles);
        else
            set(handles.message_textbox,'String', 'Open file first!'); 
        end
        
        % re-activeren zoom indien zoom togglebutton ingedrukt is
         if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData', zoompointer); end

% --------------------------------------------------------------------
function varargout = thresholdtextbox_Callback(h, eventdata, handles, varargin)
         
         

% --------------------------------------------------------------------
function varargout = watershed_pushbutton_Callback(h, eventdata, handles, varargin)
        if handles.ROIselected 
            set(gcf,'pointer','watch');
            handles.watershedselected=1;
                     
            set(gcf,'pointer','watch'); %klok
        
            image_selection=handles.ROI;
            image=handles.image;
        
            %preprocessing beeld (enkel de selectie(ROI))
            if (get(handles.inverse_checkbox,'Value') == get(h,'Max')) %indien beeld geinverteerd moet worden
                image_threshold=thresholdinverse(image_selection, str2double(get(handles.thresholdtextbox,'string')),'reverse');
                image_processed = imcomplement(image_threshold);
            else  %indien beeld niet geinverteerd moet worden       
                image_processed=thresholdinverse(image_selection, str2double(get(handles.thresholdtextbox,'string')),'noreverse');
            end
            
            %uitvoeren watershedsegmentatie
            water=watershed(image_processed);
            
            maximum = max(water(:)); %aantal watershedsegmenten
            handles.water=water;
            handles.maximum=maximum;
            guidata(h,handles);
        
            %bepaal boundingboxen van de watershedsegmenten
            boundingboxStats=regionprops(water,'BoundingBox');
            bobo2=[boundingboxStats.BoundingBox]';
            s=size(bobo2);
            bobo3=reshape(bobo2,4,s(1)/4)';
            bobo=bobo3(:,[2 1 4 3]);
            handles.bobo=bobo;
            guidata(h,handles);
        
            segments=showsegments([1:maximum]', image_selection, water);
        
            rect=handles.rect;
              
            %vervang ROIselectie in volledig beeld door watershed segmentatie
            s=size(image);
            image_watershed=zeros(s(1),s(2),3);
            image_watershed(:,:,1)=image;
            image_watershed(:,:,2)=image;
            image_watershed(:,:,3)=image;
            image_watershed(rect(2)+1:rect(2)+rect(4),rect(1)+1:rect(1)+rect(3),:)=segments(1:rect(4),1:rect(3),:);
              
            imshow(uint8(image_watershed));
            handles.saveimage=uint8(image_watershed);
            rectangle('Position',rect,'EdgeColor',[1 1 0],'Clipping', 'on'); %teken rechthoek
                        
            handles.mergeselected=0;
            guidata(h, handles);
            
            %grijswaarden worden automatisch berekend na watershed want mergen zal toch altijd hierop gebeuren; deze waarden zijn ook nodig indien een rapport wordt opgeslaan
            %theta en D zijn niet nodig, maar moeten wel in argumentenlijst (vandaar 2 laatste argumenten=0)
            handles.grayvalues=texture(maximum,8, bobo,water, image_selection, 0, 0);
            handles.texture=handles.grayvalues;
            guidata(h,handles);
            verschil=ceil(max(handles.grayvalues)-min(handles.grayvalues));
            set(handles.max_textbox,'String',verschil);
            set(handles.parameter_popupmenu,'Value',8);
            slider_step(1)=0.01;
            slider_step(2)=0.1;
            set(handles.difference_slider, 'sliderstep', slider_step, 'max', verschil, 'min', 0); 
            
            handles.verschil=0; %deviation wordt op nul gezet na nieuwe watershed
             
            handles.differenceselected=0;
            guidata(h,handles);
            set(gcf,'pointer','arrow');
            set(handles.message_textbox,'String',sprintf('The average grayvalues of the segments are automatically calculated.\nSelect another parameter if you don''t want to merge based on grayvalues.\n\t(if necessary change angle (0°-90°) and radius to calculate the co-occurrence matrix (only for texture parameters!))\nOtherwise, you can immediately adjust the allowed deviation.'));
        else 
            if handles.file_is_open==0
                set(handles.message_textbox,'String', 'Open file first!'); 
            elseif handles.ROIselected==0
                set(handles.message_textbox,'String', 'Select ROI first!'); 
            end    
        end
        
        % re-activeren zoom indien zoom togglebutton ingedrukt is
        if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf, 'Pointer','custom','PointerShapeCData', zoompointer);end    
        
        
% --------------------------------------------------------------------
function varargout = parameter_popupmenu_Callback(h, eventdata, handles, varargin)

    if handles.ROIselected & handles.watershedselected
            
        im=handles.ROI;
        water=handles.water;
        maximum=handles.maximum;
        bobo=handles.bobo;

        val=get(h,'Value');
        string_list=get(h,'String');
        selected_string=string_list{val};
        set(gcf,'pointer','watch'); %klok
        set(handles.message_textbox,'String', 'Please, wait while the parameter is calculated for each segment.');

        theta=get(handles.Angle_textbox,'String');
        D=get(handles.Radius_textbox,'String');

        text=texture(maximum,val,bobo,water, im, theta, D);
        verschil=ceil(max(text)-min(text));
        set(handles.max_textbox,'String',verschil);
        slider_step(1)=0.01;
        slider_step(2)=0.1;
        set(handles.difference_slider, 'sliderstep', slider_step, 'max', verschil, 'min', 0, 'Value', 0); 
        
        set(handles.difference_textbox, 'String', num2str(0));
        
        handles.texture=text;
        
        set(gcf,'pointer','arrow');
        handles.mergeselected=0;
        guidata(h,handles);
        
        set(handles.message_textbox,'String', 'Give the allowed difference.');
        
    else
        if handles.file_is_open == 0
        set(handles.message_textbox,'String', 'Open file first!'); 
        elseif handles.ROIselected==0
        set(handles.message_textbox,'String','Select ROI first!'); 
        elseif handles.watershedselected==0
        set(handles.message_textbox,'String','Push Watershed button first!'); 
        end 
    end
    
    % re-activeren zoom indien zoom togglebutton ingedrukt is
    if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData', zoompointer);end
    

% --------------------------------------------------------------------
function varargout = difference_slider_Callback(h, eventdata, handles, varargin)

    if handles.ROIselected & handles.watershedselected 
        handles.differenceselected=1;    
        if handles.coordselected==0
            set(handles.message_textbox,'String', 'Click in the ROI to select the start segment'  );
        end
        set(handles.difference_textbox,'String',num2str(get(handles.difference_slider,'Value')));
        handles.verschil=get(handles.difference_slider,'Value');
        handles.mergeselected=0;
        guidata(h,handles);
    else 
        if handles.file_is_open==0
            set(handles.message_textbox,'String', 'Open file first!'); 
        elseif handles.ROIselected==0
            set(handles.message_textbox,'String','Select ROI first!'); 
        elseif handles.watershedselected==0
            set(handles.message_textbox,'String','Push Watershed button first!'); 
        end
    end
    
    % re-activeren zoom indien zoom togglebutton ingedrukt is
    if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData',zoompointer);end

% --------------------------------------------------------------------
function varargout = difference_textbox_Callback(h, eventdata, handles, varargin)

    if handles.ROIselected & handles.watershedselected 
        handles.differenceselected=1;    
        if handles.coordselected==0
            set(handles.message_textbox,'String', 'Click in the ROI to select the start segment'  );
        end
        val=str2double(get(handles.difference_textbox,'String'));
        if isnumeric(val) & length(val)==1 & val>= get(handles.difference_slider,'Min') & val<= get(handles.difference_slider,'Max')
            set(handles.difference_slider,'Value',val);
            handles.verschil=val;
            
        end
        handles.mergeselected=0;
        guidata(h,handles);
    else 
        if handles.file_is_open==0
            set(handles.message_textbox,'String', 'Open file first!'); 
        elseif handles.ROIselected==0
            set(handles.message_textbox,'String','Select ROI first!'); 
        elseif handles.watershedselected==0
            set(handles.message_textbox,'String','Push Watershed button first!'); 
        end
    end
    
    % re-activeren zoom indien zoom togglebutton ingedrukt is
    if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData', zoompointer);end

% --------------------------------------------------------------------
function varargout = figure1_WindowButtonDownFcn(h, eventdata, handles, varargin)

        % enkel coordinaat lezen als zoombutton niet geselecteerd is
        if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); 
            zoom on; 
        elseif  ismember('water',fieldnames(handles)) & ismember('rect',fieldnames(handles)) 
            pos=get(gca,'CurrentPoint');
            ver=round(pos(1,2)); %niet vervangen door floor!!!
            hor=round(pos(1,1)); %niet vervangen door floor!!!
            water=handles.water;
            rect=handles.rect; 
            ver_water=ver-rect(2);
            hor_water=hor-rect(1);
            if  rect(2) < ver & ver < rect(2) + rect(4) & rect(1) < hor & hor < rect(1) + rect(3) % indien in ROI geklikt wordt, geef label ook mee
                handles.startlabel=water(ver_water,hor_water);
                pos=[num2str(ver), ' * ', num2str(hor), ' (label ' num2str(water(ver_water,hor_water)) ')'];
                set(handles.coordinate_textbox,'String',pos);
                if handles.startlabel ~= 0 % enkel als watershed rand niet geselecteerd is
                    handles.coordselected=1;
                else
                    handles.coordselected=0;
                end
            else %indien niet in ROI geklikt wordt, geef enkel coordinaten mee
                pos=[num2str(ver), ' * ', num2str(hor)];
                set(handles.coordinate_textbox,'String',pos); 
                handles.coordselected=0;
            end
            set(handles.message_textbox,'String', 'Push the Merge button ');
            handles.mergeselected=0;                       
        else 
            pos=get(gca,'CurrentPoint');
            ver=round(pos(1,2)); %niet vervangen door floor!!!
            hor=round(pos(1,1)); %niet vervangen door floor!!!
            pos=[num2str(ver), ' * ', num2str(hor)];
            set(handles.coordinate_textbox,'String',pos); 
            handles.coordselected=0;
            handles.mergeselected=0;
        end
        guidata(h,handles);
               

% --------------------------------------------------------------------
function varargout = coordinate_textbox_Callback(h, eventdata, handles, varargin)
   

% --------------------------------------------------------------------
function varargout = merge_pushbutton_Callback(h, eventdata, handles, varargin)

     if handles.ROIselected & handles.watershedselected & handles.differenceselected & handles.coordselected
        
        set(gcf,'pointer','watch');
        set(handles.message_textbox,'String','Please, wait until the segments are merged');
        im=handles.ROI;
        startlabel=handles.startlabel; 
        verschil=handles.verschil;
        startpar=handles.texture(startlabel);
        bobo=handles.bobo;
        water=handles.water;
        texture=handles.texture;
        global mergeareas_tussen;  %initialisatie mergeareas_tussen
        mergeareas_tussen=[];      %initialisatie mergeareas_tussen
        
        mergedareas = mergen(im, startlabel, verschil, startpar, bobo, water, texture);
        %dubbele verwijderen
        tussen=[];
        for i=1:size(mergedareas,1)
            if ~ismember(mergedareas(i),tussen)
                tussen=[tussen; mergedareas(i)];
            end
        end
        mergedareas=tussen;
        
        handles.mergedareas=mergedareas;
        guidata(h, handles);
        
        [edge bob]=outeredge(im, mergedareas, bobo, water);  
              
        %vervang ROIselectie in volledig beeld door watershed segmentatie
        image=handles.image;
        s=size(image);
        image_watershed=zeros(s(1),s(2),3);
        image_watershed(:,:,1)=image;
        image_watershed(:,:,2)=image;
        image_watershed(:,:,3)=image;
        rect=handles.rect;
        
        mergedsegments=show_outeredge(im, edge);
         
        image_watershed(rect(2)+1:rect(2)+size(mergedsegments,1),rect(1)+1:rect(1)+size(mergedsegments,2),:)=mergedsegments;
       
        imshow(uint8(image_watershed));
        handles.saveimage=uint8(image_watershed);
        set(gcf,'pointer','arrow');
        set(handles.message_textbox,'String','Merging finished!');
        handles.mergeselected=1;
        guidata(h, handles);
        
        %weergeven resultaten in tekstboxen
        set(handles.surfaceresult_textbox,'String',num2str(sum(sum(ismember(handles.water,handles.mergedareas)))));
        sum=0;       
        for i=1:size(mergedareas,1)
            sum=sum+handles.grayvalues(mergedareas(i));
        end
        handles.grayvalueresult=round(sum/size(mergedareas,1));
        guidata(h,handles);        
        set(handles.grayvalueresult_textbox, 'String', num2str(handles.grayvalueresult));
        
        
    else 
        if handles.file_is_open==0
            set(handles.message_textbox,'String', 'Open file first!'); 
        elseif handles.ROIselected==0
            set(handles.message_textbox,'String','Select ROI first!'); 
        elseif handles.watershedselected==0
            set(handles.message_textbox,'String','Push Watershed button first!'); 
        elseif handles.differenceselected==0  
            set(handles.message_textbox,'String','Select deviation first!');
        elseif handles.coordselected==0
            set(handles.message_textbox,'String','Select a coordinate in the ROI first!');    
        end
        
    end
       
    % re-activeren zoom indien zoom togglebutton ingedrukt is
    if get(handles.zoom_button,'Value') == get(handles.zoom_button,'Max'); zoom on; set(gcf,'Pointer','custom','PointerShapeCData', zoompointer); end


% --------------------------------------------------------------------
function varargout = zoom_button_Callback(h, eventdata, handles, varargin)
        button_state = get(h,'Value');
        if button_state == get(h,'Max')
            zoom on;
            set(gcf,'Pointer','custom','PointerShapeCData', zoompointer);         
        elseif button_state == get(h,'Min')
            zoom off;
            set(gcf,'Pointer','arrow');
        end


% --------------------------------------------------------------------
function varargout = max_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = min_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = message_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = currentfile_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = surfaceresult_textbox_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = grayvalueresult_textbox_Callback(h, eventdata, handles, varargin)

