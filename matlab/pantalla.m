function varargout = pantalla(varargin)

% Interfaz del programa, muestra en pantalla la posicion en la que se
% encuentra la persona, su peso, los valores de deformacion, axiles y
% tensiones y las barras que estan sometidas a traccion y a compresion
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura G?mez ?lvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------

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
end
% End initialization code - DO NOT EDIT


% --- Executes just before pantalla is made visible.
function pantalla_OpeningFcn(hObject, ~, handles, varargin)

% Muestra una grafica que representa la estructura del puente en el 
% grafico axes3
axes(handles.axes3);
grafica_puente; % Ejecuta script
axis equal;
% Muestra una imagen de la estructura del puente en el grafico axes1
axes(handles.axes1);
imshow('puente.jpg');
axis equal;
% Tabla de deformaciones, tensiones y axiles aparece vacia 
datos=[];
set(handles.tabla,'data',datos);
% Choose default command line output for pantalla
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = pantalla_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, ~, handles)
% Muestra en la tabla los valores de deformaciones, axiles y tensiones
% correspondientes a cada barra segun se selecciona en el popupmenu
% cg vector deformaciones medidas por las galgas en uE
% t vector tensiones en MPa
% N vector axiles en N
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
end

% --- Executes on button press in pesar.
function pesar_Callback(~, ~, handles)
% Calcula el peso de la persona que se encuentra sobre el puente
% C matriz de casos 
% cg vector deformaciones medidas por las galgas en uE
% p indica el caso (posicion) en la que se encuentra la persona
% t vector tensiones en MPa
% N vector axiles en N
% K matriz de constantes
% F peso calculado
global C;
global cg;
global p;
global t;
global N;
global K;
global F;

C=casos;    % Ejecuto script
cg=[-87.17293736, 116.2305831, 58.11529157,	-984.1815939, -492.0907969,	492.0907969, -492.0907969];
% Calculo la posicion sobre el puente 
p=posicion(cg,C);
% Muestro en pantalla la posicion en la que se encuentra la persona
if(p==2)
    axes(handles.axes1);
    imshow('caso2.jpg');
    axis equal;
end
if(p==3)
    axes(handles.axes1);
    imshow('caso3.jpg');
    axis equal;
end
if(p==4)
    axes(handles.axes1);
    imshow('caso4.jpg');
    axis equal;
end
if(p==5)
    axes(handles.axes1);
    imshow('caso5.jpg');
    axis equal;
end
if(p==6)
    axes(handles.axes1);
    imshow('caso6.jpg');
    axis equal;
end
% Calculo el peso
t=calculo_tension(cg);
N=calculo_axiles(t);
K=constante;
F=calculo_peso(N,K,p);

set(handles.peso,'String',F);
end

% --- Executes on button press in reset.
function reset_Callback(~, ~, handles)
% Resetea la pantalla de la interfaz
% Pone a 0 el valor del peso
set(handles.peso,'String', 0);
% Muestra imagen de la estructura del puente original, eliminando flechas 
% que indican posicion 
axes(handles.axes1);
imshow('puente.jpg');
axis equal;
% Tabla de datos deformaciones, tensiones, axiles se vacia 
datos=[];
set(handles.tabla,'data',datos);
% Grafica de la estructura del puente vuelve al original, sin indicar
% barras sometidas a traccion o a compresion
axes(handles.axes3);
hold off;
grafica_puente;
axis equal;
end

% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, ~, handles)
% Muestro en la grafica de la estructura del puente barras sometidas a
% traccion o compresion marcandolas de color morado
% cg vector deformaciones medidas por las galgas en uE
% TC variable con valor "Traccion" o "Compresion" segun el boton que este
% presionado
global cg;

TC=get(hObject,'String');
switch TC
    case 'Traccion'
        hold off
        axes(handles.axes3);
        traccion(cg);   % Ejecuto script
        axis equal;
       
    case 'Compresion'
        hold off
        axes(handles.axes3);
        compresion(cg); % Ejecuto script 
        axis equal;
end
end

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles);
popupmenu_Callback(hObject, eventdata, handles);
end