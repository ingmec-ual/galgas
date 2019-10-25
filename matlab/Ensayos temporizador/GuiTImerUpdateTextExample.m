function varargout = GuiTImerUpdateTextExample(varargin)
% GUITIMERUPDATETEXTEXAMPLE MATLAB code for GuiTImerUpdateTextExample.fig
%      GUITIMERUPDATETEXTEXAMPLE, by itself, creates a new GUITIMERUPDATETEXTEXAMPLE or raises the existing
%      singleton*.
%
%      H = GUITIMERUPDATETEXTEXAMPLE returns the handle to a new GUITIMERUPDATETEXTEXAMPLE or the handle to
%      the existing singleton*.
%
%      GUITIMERUPDATETEXTEXAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITIMERUPDATETEXTEXAMPLE.M with the given input arguments.
%
%      GUITIMERUPDATETEXTEXAMPLE('Property','Value',...) creates a new GUITIMERUPDATETEXTEXAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiTImerUpdateTextExample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiTImerUpdateTextExample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiTImerUpdateTextExample

% Last Modified by GUIDE v2.5 24-Mar-2016 22:56:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiTImerUpdateTextExample_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiTImerUpdateTextExample_OutputFcn, ...
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


% --- Executes just before GuiTImerUpdateTextExample is made visible.
function GuiTImerUpdateTextExample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiTImerUpdateTextExample (see VARARGIN)

% Choose default command line output for GuiTImerUpdateTextExample
handles.output = hObject;

handles.myCellData =  {'bent',
                       'went',
                       'rent',
                       'sent',
                       'tent',
                       'tint',
                       'tine'};
                   
handles.strIdx = 1;

handles.timer = timer('Name','MyTimer',               ...
                      'Period',1,                     ...
                      'StartDelay',0,                 ...
                      'TasksToExecute',inf,           ... 
                      'ExecutionMode','fixedSpacing', ...
                      'TimerFcn',{@timerCallback,hObject}); 

% Update handles structure
guidata(hObject, handles);

start(handles.timer);

% UIWAIT makes GuiTImerUpdateTextExample wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiTImerUpdateTextExample_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.timer);

function timerCallback(hTimer, eventdata, hFigure)

handles = guidata(hFigure);
str = handles.myCellData{handles.strIdx};
set(handles.pushbutton1,'String',str);
handles.strIdx = handles.strIdx + 1;
if handles.strIdx > length(handles.myCellData)
    handles.strIdx = 1;
end
guidata(hFigure,handles);


