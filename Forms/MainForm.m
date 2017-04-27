function varargout = MainForm(varargin)
% MAINFORM MATLAB code for MainForm.fig
%      MAINFORM, by itself, creates a new MAINFORM or raises the existing
%      singleton*.
%
%      H = MAINFORM returns the handle to a new MAINFORM or the handle to
%      the existing singleton*.
%
%      MAINFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFORM.M with the given input arguments.
%
%      MAINFORM('Property','Value',...) creates a new MAINFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainForm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainForm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainForm

% Last Modified by GUIDE v2.5 27-Apr-2017 09:43:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function GUI_InitSlider(slider_n, max,steps)
set(slider_n,'Max',max,'SliderStep',steps);

function GUI_SetText(edite_n,strings)
set(edite_n,'String',strings);

function Set_StateInfo(strings)
temobj = findobj('Tag','text_State');
set(temobj,'String',strings);

function popup_add_item()
% --- Executes just before MainForm is made visible.
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainForm (see VARARGIN)

% Choose default command line output for MainForm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes MainForm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Load_TIRF_Callback(hObject, eventdata, handles)
% hObject    handle to Load_TIRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TIRF_filename = Load_Tiff_Files();
info = imfinfo(TIRF_filename);
%     info=tifftagsread (File);
TotalImages = length(info);
A = tiffread(TIRF_filename,[1,TotalImages]);
handles.TIRF_imgs = A;
handles.Axes1_imgs = A; %decide which images will be display
GUI_imshow(handles.axes1,A(:,:,1));
GUI_SetText(findobj('Tag','text_TIRF_Title'),TIRF_filename);
tem_slider = findobj('Tag','slider_TRIF');
step = 1.0/TotalImages;
GUI_InitSlider(tem_slider,TotalImages,[step,10*step]);
guidata(hObject,handles);

nmb = 1;
% --------------------------------------------------------------------
function Load_SIM_Callback(hObject, eventdata, handles)
% hObject    handle to Load_SIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SIM_filename = Load_Tiff_Files();
info = imfinfo(SIM_filename);
%     info=tifftagsread (File);
TotalImages = length(info);
A = tiffread(SIM_filename,[1,TotalImages]);
handles.SIM_imgs = A;
handles.Axes2_imgs = A; %decide which images will be display
GUI_imshow(handles.axes2,A(:,:,1));
GUI_SetText(findobj('Tag','text_SIM_Title'),SIM_filename);
tem_slider = findobj('Tag','slider_SIM');
step = 1.0/TotalImages;
GUI_InitSlider(tem_slider,TotalImages,[step,10*step]);
guidata(hObject,handles);



% --- Executes on slider movement.
function slider_TRIF_Callback(hObject, eventdata, handles)
% hObject    handle to slider_TRIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jj=get(hObject,'Value');
jj=uint16(jj);
if 0 == isfield(handles,'Axes1_imgs')
    return
end
img_num = size(handles.Axes1_imgs,3);
if jj < img_num
    jj = jj +1;
end
GUI_imshow(handles.axes1,handles.Axes1_imgs(:,:,jj));
str = ['images #', int2str(jj) ,'/', int2str(img_num)];
set(findobj('Tag','text_TIRF_Title'),'String',str);
nmb = 1;

% --- Executes during object creation, after setting all properties.
function slider_TRIF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_TRIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_SIM_Callback(hObject, eventdata, handles)
% hObject    handle to slider_SIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
jj=get(hObject,'Value');
jj=uint16(jj);
if 0 == isfield(handles,'Axes2_imgs')
    return
end
img_num = size(handles.Axes2_imgs,3);
if jj < img_num
    jj = jj +1;
end
GUI_imshow(handles.axes2,handles.Axes2_imgs(:,:,jj));
str = ['images #', int2str(jj) ,'/', int2str(img_num)];
set(findobj('Tag','text_SIM_Title'),'String',str);
nmb = 1;


% --- Executes during object creation, after setting all properties.
function slider_SIM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_SIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function GetROI_inSIM_Callback(hObject, eventdata, handles)
% hObject    handle to GetROI_inSIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 0 == isfield(handles,'TIRF_imgs')
    return;
end
if 0 == isfield(handles,'SIM_imgs')
    return;
end
% obtained the ROI in the SIM's image
Set_StateInfo('Get ROI Processing...');
% set(findobj('Tag',')
ROI_SIM = GetROI_SIM(handles.TIRF_imgs,handles.SIM_imgs);
handles.ROI_SIM = ROI_SIM;
handles.Axes2_imgs = ROI_SIM;
GUI_imshow(handles.axes2,ROI_SIM(:,:,1));
GUI_SetText(findobj('Tag','text_SIM_Title'),'ROI_SIM:#1');
tem_slider = findobj('Tag','slider_SIM');
set(tem_slider,'Value',0);
Set_StateInfo('Get ROI Processed...');
guidata(hObject,handles);


% --------------------------------------------------------------------
function FindParticle_Callback(hObject, eventdata, handles)
% hObject    handle to FindParticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 0 == isfield(handles,'ROI_SIM')
    return;
end
Set_StateInfo('Find Particles Processing...');
% obj = findobj('Tag','text_State');
% 
% set(obj,'String','Processing...');
ROI_SIM = handles.ROI_SIM;
Particles = FindParticles(ROI_SIM,3,3);
handles.Particles = Particles;
Set_StateInfo('Find Particles Processed...');
guidata(hObject,handles);

% --------------------------------------------------------------------
function Linking_Callback(hObject, eventdata, handles)
% hObject    handle to Linking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 0 == isfield(handles,'Particles')
    return;
end
Set_StateInfo('Linking Processing...');
least_fram = 4;
V = handles.Particles;
Linked_Points = Point_Linking(V, 1.5,least_fram);
handles.Linked_Points = Linked_Points;
Set_StateInfo('Linking Processed...');
guidata(hObject,handles);

% --------------------------------------------------------------------
function Fitting_Callback(hObject, eventdata, handles)
% hObject    handle to Fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 0 == isfield(handles,'Linked_Points')
    return;
end
Set_StateInfo('Fitting Processing...');
DV = handles.Linked_Points;
img_SIM = handles.SIM_imgs;

FitResult = Point_Fitting(img_SIM,DV,2);
pixe_size = 32.5; %nanometer
Precise =  Localization_Precise(FitResult,pixe_size);
handles.FitResult = FitResult;
handles.FitPrecise = Precise;
Set_StateInfo('Fitting Processed...');
guidata(hObject,handles);

% --------------------------------------------------------------------
function Reconstrution_Callback(hObject, eventdata, handles)
% hObject    handle to Reconstrution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 0 == isfield(handles,'FitResult')
    return;
end
Set_StateInfo('Reconstrution Processing...');
FitResult = handles.FitResult;
ReconstructionPoints = FittingResult_Reconstru(FitResult);
handles.ReconstructionPoints = ReconstructionPoints;
Set_StateInfo('Reconstrution Processed...');
guidata(hObject,handles);


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
a = 'how';b = 'are'; c = 'you';
s = {a,b,c};
now_s = get(hObject,'String');
if isempty(now_s)
    set(hObject,'String',s);
end
now_s = get(hObject,'String');
if isempty(now_s)
    set(hObject,'String',s);
else
    len = size(now_s,1);
    now_s{len + 1} = 'nmb';
    set(hObject,'String',now_s);
end
nmb = 1;
