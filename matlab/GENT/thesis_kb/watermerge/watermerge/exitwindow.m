function answer = exitwindow(varargin)
error(nargchk(0,4,nargin)) % function takes 0, 1, or 4 arguments
if nargin == 0 | isnumeric(varargin{1}) 
    fig = openfig(mfilename,'reuse');
    set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
    handles = guihandles(fig);
    guidata(fig, handles);
    if nargin == 1
        pos_size = get(fig,'Position');
        pos = varargin{1};
        if length(pos) ~= 2
            error('Input argument must be a 2-element vector')
        end
        new_pos = [pos(1) pos(2) pos_size(3) pos_size(4)];
        set(fig,'Position',new_pos,'Visible','on')
    end
    uiwait(fig);
    if ~ishandle(fig)
        answer = 'cancel';
    else
        handles = guidata(fig);
        answer = handles.answer;
        delete(fig);
    end
elseif ischar(varargin{1}) % Invoke named subfunction or callback
    try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);
    end 
end


% --------------------------------------------------------------------
function varargout = yesButton_Callback(h, eventdata, handles, varargin)

handles.answer = 'yes';
guidata(h, handles);
uiresume(handles.figure1);



% --------------------------------------------------------------------
function varargout = noButton_Callback(h, eventdata, handles, varargin)

handles.answer = 'no';
guidata(h, handles);
uiresume(handles.figure1);