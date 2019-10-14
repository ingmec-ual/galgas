function varargout = pantalla(varargin)
%PANTALLA M-file for pantalla.fig
%      PANTALLA, by itself, creates a new PANTALLA or raises the existing
%      singleton*.
%
%      H = PANTALLA returns the handle to a new PANTALLA or the handle to
%      the existing singleton*.
%
%      PANTALLA('Property','Value',...) creates a new PANTALLA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to pantalla_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      PANTALLA('CALLBACK') and PANTALLA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in PANTALLA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pantalla

% Last Modified by GUIDE v2.5 14-Oct-2019 20:50:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pantalla_OpeningFcn, ...
                   'gui_OutputFcn',  @pantalla_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before pantalla is made visible.
function pantalla_OpeningFcn(hObject, eventdata, handles, varargin)

imshow('puente.jpg');
axis equal;
datos=[];
set(handles.tabla,'data',datos);
% Choose default command line output for pantalla
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pantalla wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pantalla_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
global cg;
global t;
global N;

m=get(hObject,'Value');
if(m==1)
    datos=cg;   % Obtengo valores de deformacion 
end
if(m==2)
    datos=t;    % Obtengo valores de tension
end
if(m==3)
    datos=N;    % Obtengo valores de axiles
end
set(handles.tabla,'data', datos);


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
global C;
global cg;
global p;
global t;
global N;
global K;
global F;

C=casos;    
cg=[-87.17293736, 116.2305831, 58.11529157,	-984.1815939, -492.0907969,	492.0907969, -492.0907969];
% Calculo la posicion sobre el puente
p=posicion(cg,C);
% Muestro en pantalla la posicion en la que se encuentra el run
if(p==2)
    imshow('caso2.jpg');
    axis equal;
end
if(p==3)
    imshow('caso3.jpg');
    axis equal;
end
if(p==4)
    imshow('caso4.jpg');
    axis equal;
end
if(p==5)
    imshow('caso5.jpg');
    axis equal;
end
if(p==6)
    imshow('caso6.jpg');
    axis equal;
end
% Calculo el peso
t=calculo_tension(cg);
N=calculo_axiles(t);
K=constante;
F=calculo_peso(N,K,p);

set(handles.peso,'String',F);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
set(handles.peso,'String', 0);
imshow('puente.jpg');
axis equal;
datos=[];
set(handles.tabla,'data',datos);
