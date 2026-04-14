function varargout = main_pgm(varargin)
% MAIN_PGM MATLAB code for main_pgm.fig
%      MAIN_PGM, by itself, creates a new MAIN_PGM or raises the existing
%      singleton*.
%
%      H = MAIN_PGM returns the handle to a new MAIN_PGM or the handle to
%      the existing singleton*.
%
%      MAIN_PGM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_PGM.M with the given input arguments.
%
%      MAIN_PGM('Property','Value',...) creates a new MAIN_PGM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_pgm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_pgm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_pgm

% Last Modified by GUIDE v2.5 25-Sep-2024 21:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_pgm_OpeningFcn, ...
                   'gui_OutputFcn',  @main_pgm_OutputFcn, ...
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


% --- Executes just before main_pgm is made visible.
function main_pgm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_pgm (see VARARGIN)

% Choose default command line output for main_pgm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_pgm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_pgm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
training_data

% --- Executes on button press in input_eeg.
function input_eeg_Callback(hObject, eventdata, handles)
% hObject    handle to input_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
% clear all;
% close all;
fs = 173.61;
cd TRAIN
[J P]=uigetfile('*.xls','Select an EEG data File');
N=xlsread(strcat(P,J));
cd ..
s=(0:length(N)-1)/fs;
axes(handles.axes1),
plot(s,N,'b')
title('EEG Signal')
ylabel('amplitude')
xlabel('seconds')
grid on
handles.N=N;
handles.s=s;
guidata(hObject, handles);


% --- Executes on button press in preprocessing_on_EEG.
function preprocessing_on_EEG_Callback(hObject, eventdata, handles)
% hObject    handle to preprocessing_on_EEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % %%% FIR bandpass filter, Removing 50Hz noise
N=handles.N;
s=handles.s;
n=9;
n1=n+1;
if (rem(n,2)~=0);
n1=n;
n=n-1;
end
y=hamming(n1);
[bn,an]=fir1(n,0.1,y);
filt=filter(bn,an,N);
% axes(handles.axes2),
% plot(s,filt,'g')
% title('EEG Signal Denoised')
% ylabel('amplitude')
% xlabel('seconds')
% grid on
% % % % % % % % % % % % % % % % % % % % % % % % 
%%%   removing EOG using butterworth LPF
n=10;
wn=0.1;
[b,a]=butter(n,wn);
y=filter(b,a,filt);
axes(handles.axes2),
plot(s,y,'r')
title('EEG Signal Denoised');
ylabel('amplitude')
xlabel('seconds')
grid on
handles.y=y;
guidata(hObject, handles);
% --- Executes on button press in CWT_TO_EEG.
function CWT_TO_EEG_Callback(hObject, eventdata, handles)
% hObject    handle to CWT_TO_EEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

% --- Executes on button press in PWELCH_PSD.
function PWELCH_PSD_Callback(hObject, eventdata, handles)
% hObject    handle to PWELCH_PSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);

% --- Executes on button press in empirical_mode_decomposition.
function empirical_mode_decomposition_Callback(hObject, eventdata, handles)
% hObject    handle to empirical_mode_decomposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % % mean
guidata(hObject, handles);
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('support')
y=handles.y;

m = (mean(y(:)))

% % % variance
v = var(y(:))

% % % % kurtosis
k = kurtosis(y(:))

% % % % skewness
s = skewness(y(:))

Final=[k v k s]


load Ftrain

rst1=LSTMtest(Final,2,Ftrain);

set(handles.edit1,'string',m)
set(handles.edit2,'string',v)
set(handles.edit3,'string',k)
set(handles.edit4,'string',s)


if rst1==1
    
    msgbox('Normal')
    
   else  
    
    msgbox('Epileptic')
end

guidata(hObject, handles);

% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1),imshow([255])
axes(handles.axes2),imshow([255])
axes(handles.axes6),imshow([255])

set(handles.edit1,'string','')
set(handles.edit2,'string','')
set(handles.edit3,'string','')
set(handles.edit4,'string','')

% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close 


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y=handles.y;
axes(handles.axes6),
pxx = pwelch(y(:));
plot(10*log10(pxx))
title('WELCH PSD');
ylabel('power/freq')
xlabel('frequency(Hz)')
grid on