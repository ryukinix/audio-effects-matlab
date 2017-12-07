function varargout = Gui(varargin)
% GUI MATLAB code for Gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gui

% Last Modified by GUIDE v2.5 06-Dec-2017 20:45:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Gui_OutputFcn, ...
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

% --- Executes just before Gui is made visible.
function Gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gui (see VARARGIN)

% Choose default command line output for Gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes Gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangedFcn(hObject, eventdata, handles)


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reproduzirButton flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reproduzirButton the data.
% 
% handles.metricdata.density = 0;
% handles.metricdata.volume  = 0;
% 
% set(handles.density, 'String', handles.metricdata.density);
% set(handles.volume,  'String', handles.metricdata.volume);
% set(handles.mass, 'String', 0);
% 
% set(handles.unitgroup, 'SelectedObject', handles.english);
% 
% set(handles.text4, 'String', 'lb/cu.in');
% set(handles.text5, 'String', 'cu.in');
% set(handles.text6, 'String', 'lb');

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in carregarButton.
function carregarButton_Callback(hObject, eventdata, handles)
% hObject    handle to carregarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x Fs;
[filename, filepath]= uigetfile({'*.wav','WAV Files'}, 'Selecione um ï¿½udio wav');
if (filename ~= 0)
    [x, Fs] = LoadAudio([filepath filename]);
    updateAxes(handles);
    updateAxesFiltered(handles);
end

% --- Executes on button press in reproduzirButton.
function reproduzirButton_Callback(hObject, eventdata, handles)
% hObject    handle to reproduzirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x Fs;
y = applyFilters(handles);
clear sound;
sound(y, Fs);


% --- Executes on button press in pausarbutton.
function pausarButton_Callback(hObject, eventdata, handles)
% hObject    handle to pausarbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;

% --- Executes on button press in flangerButton.
function flangerButton_Callback(hObject, eventdata, handles)
% hObject    handle to flangerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flangerButton
updateAxesFiltered(handles);

% --- Executes on button press in distortionButton.
function distortionButton_Callback(hObject, eventdata, handles)
% hObject    handle to distortionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distortionButton
updateAxesFiltered(handles);

% --- Executes on button press in distortionButton.
function delayButton_Callback(hObject, eventdata, handles)
% hObject    handle to distortionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distortionButton
updateAxesFiltered(handles);

% --- Executes on slider movement.
function delayDepthSlider_Callback(hObject, eventdata, handles)
% hObject    handle to delayDepthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function delayDepthSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delayDepthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function delayDelaySlider_Callback(hObject, eventdata, handles)
% hObject    handle to delayDelaySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function delayDelaySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delayDelaySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function delayFeedbackSlider_Callback(hObject, eventdata, handles)
% hObject    handle to delayFeedbackSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function delayFeedbackSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delayFeedbackSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function flangerMixSlider_Callback(hObject, eventdata, handles)
% hObject    handle to flangerMixSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function flangerMixSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flangerMixSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function flangerDelaySlider_Callback(hObject, eventdata, handles)
% hObject    handle to flangerDelaySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function flangerDelaySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flangerDelaySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function flangerWidthSlider_Callback(hObject, eventdata, handles)
% hObject    handle to flangerWidthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function flangerWidthSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flangerWidthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function flangerRateSlider_Callback(hObject, eventdata, handles)
% hObject    handle to flangerRateSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function flangerRateSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flangerRateSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function distortionGainSlider_Callback(hObject, eventdata, handles)
% hObject    handle to distortionGainSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function distortionGainSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distortionGainSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function distortionToneSlider_Callback(hObject, eventdata, handles)
% hObject    handle to distortionToneSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateAxesFiltered(handles);

% --- Executes during object creation, after setting all properties.
function distortionToneSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distortionToneSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function updateAxes(handles)
global x;
axes(handles.axes1); %set the current axes to axes2
plot(x);
xlabel('Tempo (s)');
ylabel('Magnitude');
[w, H] = loadFFT(x);
axes(handles.axes2);
plot(w, H);
ylabel('log Db')
xlabel('Frequência normalizada em pi (rad/s)');


function [w, H] = loadFFT(x)
global Fs;
w = linspace(-Fs/2, Fs/2, length(x));
H = 20*log10(abs(fftshift(fft(x))));


function [y] = applyFilters(handles)
global x Fs;
y = x;
distortion = get(handles.distortionButton, 'Value');
flanger = get(handles.flangerButton, 'Value');
delay = get(handles.delayButton, 'Value');
if distortion == 1
    gain = get(handles.distortionGainSlider, 'Value');
    tone = get(handles.distortionToneSlider, 'Value');
    y = Distortion(y, gain, tone, Fs);
end

if flanger == 1
    mix = get(handles.flangerMixSlider, 'Value');
    delay = get(handles.flangerDelaySlider, 'Value');
    width = get(handles.flangerWidthSlider, 'Value');
    rate = get(handles.flangerRateSlider, 'Value');
    y = Flanger(y, mix, delay, width, rate, Fs);
end

if delay == 1
    depth = get(handles.delayDepthSlider, 'Value');
    delay = get(handles.delayDelaySlider, 'Value');
    feedback = get(handles.delayFeedbackSlider, 'Value');
    y = Delay(y, depth, delay, feedback, Fs);
end


function updateAxesFiltered(handles)
global x;
y = applyFilters(handles);

if length(x) ~= (length(y)) || ~isequal(x,y)
    axes(handles.axes1); %set the current axes to axes2
    plot(y, '--r');
    xlabel('Tempo (s)');
    ylabel('Magnitude');
    [w, H] = loadFFT(y);
    axes(handles.axes2);
    plot(w, H, '--r');
    ylabel('log Db')
    xlabel('Frequência normalizada em pi (rad/s)');
else
    updateAxes(handles);
end


% --- Executes on button press in salvarButton.
function salvarButton_Callback(hObject, eventdata, handles)
% hObject    handle to salvarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
