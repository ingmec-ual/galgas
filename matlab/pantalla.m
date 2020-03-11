function varargout = pantalla(varargin)

% Interfaz del programa, muestra en pantalla la posicion en la que se
% encuentra la persona, su peso, los valores de deformacion, axiles y
% tensiones y las barras que estan sometidas a traccion y a compresion
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura Gomez Alvarez 
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


% --- Se ejecuta antes de que pantalla sea visible
function pantalla_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for pantalla
handles.output = hObject;

% Creo un temporizador 
handles.timer = timer('Name','MyTimer',               ...
                      'Period',1,                     ...
                      'StartDelay',0,                 ...
                      'TasksToExecute',inf,           ... 
                      'ExecutionMode','fixedSpacing', ...
                      'TimerFcn',{@timerCallback,hObject}); 
       
% Valores por defecto de TC y x
% TC valor traccion/compresion para tipo de esfuerzos
% x valor para popupmenu
handles.TC = 'Traccion';
handles.x = 1;
handles.cg=[];
handles.tbl=[0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0];
handles.bt=0;
handles.bot_4=0;
handles.bot_11=0;
handles.bot_12=0;
handles.bot_16=0;
handles.bot_17=0;
handles.bot_18=0;
handles.bot_19=0;

% Update handles structure
guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = pantalla_OutputFcn(~, ~, handles)

% Muestra una grafica que representa la estructura del puente en el 
% grafico grafica
axes(handles.grafica);
grafica_puente; % Ejecuta script
axis equal;

% Muestra una imagen de la estructura del puente en el grafico foto
axes(handles.foto);
imshow('puente.jpg');
axis equal;

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Se ejecuta cuando un objeto del tipo_esfuerzos cambia 
function tipo_esfuerzos_SelectionChangedFcn(hObject, ~, handles)

% Muestro en la grafica de la estructura del puente barras sometidas a
% traccion o compresion marcandolas de color morado
% TC variable con valor "Traccion" o "Compresion" segun el boton que este
% presionado
handles.TC=get(hObject, 'String');
actualiza_grafica_barras(handles);
end


% --- Funcion que se ejecuta al cambiar valores en popupmenu
function popupmenu_Callback(hObject, ~, handles)

% Muestra en la tabla los valores de deformaciones, axiles y tensiones
% correspondientes a cada barra segun se selecciona en el popupmenu

handles.x=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

ejecuto_popupmenu(handles);
end


% --- Funcion que se ejecuta al presionar boton btnConnect.
function btnConnect_Callback(hObject, ~, handles)

% Se introduce el nombre del puerto serie al que van conectadas las 
% placas por pantalla y se conecta, activando los botones de medir

try
    handles.nomter=get(handles.edCOM,'String');
    handles.s=GalgasComms(handles.nomter);

    set(handles.btnConnect, 'Enable', 'off');
    set(handles.btnDisconnect, 'Enable', 'on');
    set(handles.medir, 'Enable', 'on');
    set(handles.resetear, 'Enable', 'off');
    
    guidata(hObject,handles);
    
catch ME
    msgbox(ME.message,'Error abriendo puerto serie');
end

end


% --- Funcion que se ejecuta al presionar boton btnDisconnect.
function btnDisconnect_Callback(hObject, eventData, handles)

% Se desconecta el puerto serie en el que van conectadas las placas

try
    clear handles.s;
    
    resetear_Callback(hObject, eventData, handles);
    
    set(handles.btnConnect, 'Enable', 'on');
    set(handles.btnDisconnect, 'Enable', 'off');
    
    guidata(hObject,handles);
 
catch ME
    msgbox(ME.message,'Error desconectando');
end

end


% --- Funcion que se ejecuta al presionar boton medir
function medir_Callback(~, ~, handles)

% Inicia el temporizador
start(handles.timer);

% Desactiva y activa los botones
set(handles.medir, 'Enable', 'off');
set(handles.resetear, 'Enable', 'on');
set(handles.todas, 'Enable', 'on');
set(handles.b4, 'Enable', 'on');
set(handles.b11, 'Enable', 'on');
set(handles.b12, 'Enable', 'on');
set(handles.b16, 'Enable', 'on');
set(handles.b17, 'Enable', 'on');
set(handles.b18, 'Enable', 'on');
set(handles.b19, 'Enable', 'on');
set(handles.traccion, 'Enable', 'on');
set(handles.compresion, 'Enable', 'on');
set(handles.popupmenu, 'Enable', 'on');
 
end


% --- Funcion que se ejecuta al presionar boton resetear.
function resetear_Callback(~, ~, handles)

% Resetea la pantalla de la interfaz
% Para el temporizador
stop(handles.timer);

% Pone a 0 el valor del peso
texto=[];
set(handles.peso,'String',texto);

% Muestra imagen de la estructura del puente original, eliminando flechas 
% que indican posicion 
axes(handles.foto);
imshow('puente.jpg');
axis equal;

% Tabla de datos deformaciones, tensiones, axiles se vacia 
datos=[];
set(handles.tabla,'data',datos);

% Grafica de la estructura del puente vuelve al original, sin indicar
% barras sometidas a traccion o a compresion
axes(handles.grafica);
cla;
grafica_puente;
axis equal;

% Activa y desactiva los botones
set(handles.todas, 'Value',0);
set(handles.b4, 'Value',0);
set(handles.b11, 'Value',0);
set(handles.b12, 'Value',0);
set(handles.b16, 'Value',0);
set(handles.b17, 'Value',0);
set(handles.b18, 'Value',0);
set(handles.b19, 'Value',0);

set(handles.medir, 'Enable', 'on');
set(handles.todas, 'Enable', 'inactive');
set(handles.b4, 'Enable', 'inactive');
set(handles.b11, 'Enable', 'inactive');
set(handles.b12, 'Enable', 'inactive');
set(handles.b16, 'Enable', 'inactive');
set(handles.b17, 'Enable', 'inactive');
set(handles.b18, 'Enable', 'inactive');
set(handles.b19, 'Enable', 'inactive');
set(handles.traccion, 'Enable', 'inactive');
set(handles.compresion, 'Enable', 'inactive');
set(handles.popupmenu, 'Enable', 'inactive');
set(handles.resetear, 'Enable', 'off');
end

%------------------------------------------------------------------------

% ---MODULOS---

% --- Funcion que se ejecuta al llamar al popupmenu
function ejecuto_popupmenu(handles)

% Muestra en la tabla los valores de deformaciones, axiles y tensiones
% correspondientes a cada barra segun se selecciona en el popupmenu
% cg vector deformaciones medidas por las galgas en uE
% t vector tensiones en MPa
% N vector axiles en N
% datos valores que se insertan en la tabla

% compruebo longitudo del vector cg, si no es correcto no continua
% ejecutando el programa
if (length(handles.cg)<2)
    return
end

deformaciones=handles.tbl(1,:);
disp('DEFS:');
disp(deformaciones);

vals={};
for i=1:length(deformaciones)
    defor = deformaciones(i);
    if (1)
        vals{1,i} = sprintf('%.03f uE', 1e6*defor);
        vals{2,i} = handles.tbl(2,i);
        vals{3,i} = handles.tbl(3,i);
    end            
end
set(handles.tabla,'data', vals); % Obtengo valores de deformacion 

end


% --- Funcion que cambia color barras segun si estan sometidas a T/C
function actualiza_grafica_barras(handles)

% Muestro en la grafica de la estructura del puente barras sometidas a
% traccion o compresion marcandolas de color morado
% cg vector deformaciones medidas por las galgas en uE
% TC variable con valor "Traccion" o "Compresion" segun el boton que este
% presionado

    axes(handles.grafica);
    cla;
    switch handles.TC
        case 'Traccion'
          traccion(handles.cg);   % Ejecuto script
        case 'Compresion'
          compresion(handles.cg); % Ejecuto script 
    end
    
        axis equal;

end

%--- Funcion que se repite mientras el temporizador esta en marcha
 function timerCallback(~, ~, hFigure)
 
% C matriz de casos 
% cg vector deformaciones medidas por las galgas en uE
% p indica el caso (posicion) en la que se encuentra la persona
% t vector tensiones en MPa
% N vector axiles en N
% K matriz de constantes
% F peso calculado
% datos valores que se insertan en la tabla
% TC variable con valor "Traccion" o "Compresion"
% texto variable contiene texto con valor peso que se impreme en pantalla
handles = guidata(hFigure);

% --- Calculo el peso que hay sobre el puente. --------------------------

C=casos;    % Ejecuto script

MEDIR_SISTEMA_REAL=1;

if (MEDIR_SISTEMA_REAL==1)
    handles.cg = zeros(1,7);
    
    %IDS: 4; 11; 12; 16; 17; 18; 19];
    
    % Laura: Repetir para cada barra!    
    if (get(handles.b19, 'Value'))
        handles.cg(7)=leer_galgas(handles.s, 19);
    end
    
else
    % Datos simulados de prueba:
    handles.cg=[-37.0810, 24.7207, 49.4414, -418.6444, -209.3222, 209.3222, -209.3222];
    % Sumar ruido aleatorio (mientras no se mida del real)
    handles.cg = handles.cg + randn(size(handles.cg,1),size(handles.cg,2))*0.1;
end

% Calculo la posicion sobre el puente 
p=posicion(handles.cg,C);
% Muestro en pantalla la posicion en la que se encuentra la persona
img=imread(sprintf('caso%d.jpg',p));
imshow(img,'Parent',handles.foto);
axis equal;

% Calculo el peso
handles.t=calculo_tension(handles.cg);
handles.N=calculo_axiles(handles.t);
K=constante();
F=calculo_peso(handles.N,K,p);

% --- Muestro valores actuales del peso---------------------------------
texto=sprintf('Peso: %5.1f Kg',F);
set(handles.peso,'String',texto);

% --- Actualizo seleccion de TC-----------------------------------------   
actualiza_grafica_barras(handles);

% LAURA: Actualizar la tabla aqui!
% Datos actualizados estan en "cg".

guidata(hFigure,handles);
 end


% --- Funcion que se ejecuta al presionar todas.
function todas_Callback(hObject, ~, handles)

handles.bt=get(hObject,'Value');

switch handles.bt
    case 1
        set(handles.b4, 'Value',1);
        set(handles.b11, 'Value',1);
        set(handles.b12, 'Value',1);
        set(handles.b16, 'Value',1);
        set(handles.b17, 'Value',1);
        set(handles.b18, 'Value',1);
        set(handles.b19, 'Value',1);
    
        handles.tbl=[handles.cg; handles.t; handles.N];
        ejecuto_popupmenu(handles);
    
    case 0 
        set(handles.b4, 'Value',0);
        set(handles.b11, 'Value',0);
        set(handles.b12, 'Value',0);
        set(handles.b16, 'Value',0);
        set(handles.b17, 'Value',0);
        set(handles.b18, 'Value',0);
        set(handles.b19, 'Value',0);

        handles.tbl=[0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0];
        ejecuto_popupmenu(handles);
    
end

guidata(hObject, handles);

end

% --- Funcion que se ejecuta al presionar b4.
function b4_Callback(hObject, ~, handles)

handles.bot_4=get(hObject,'Value');
switch handles.bot_4
    case 1
       b4g=handles.cg(1);
       handles.tbl(1,1)=b4g;
       b4t=handles.t(1);
       handles.tbl(2,1)=b4t;
       b4n=handles.N(1);
       handles.tbl(3,1)=b4n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,1)=0;
        handles.tbl(2,1)=0;
        handles.tbl(3,1)=0;
        ejecuto_popupmenu(handles);
end

guidata(hObject, handles);

end


% --- Funcion que se ejecuta al presionar b11.
function b11_Callback(hObject, ~, handles)

handles.bot_11=get(hObject,'Value');
switch handles.bot_11
    case 1
       b11g=handles.cg(2);
       handles.tbl(1,2)=b11g;
       b11t=handles.t(1);
       handles.tbl(2,2)=b11t;
       b11n=handles.N(2);
       handles.tbl(3,2)=b11n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,2)=0;
        handles.tbl(2,2)=0;
        handles.tbl(3,2)=0;
        ejecuto_popupmenu(handles);
end
guidata(hObject, handles);
end


% --- Funcion que se ejecuta al presionar b12.
function b12_Callback(hObject, ~, handles)

handles.bot_12=get(hObject,'Value');
switch handles.bot_12
    case 1
       b12g=handles.cg(3);
       handles.tbl(1,3)=b12g;
       b12t=handles.t(3);
       handles.tbl(2,3)=b12t;
       b12n=handles.N(3);
       handles.tbl(3,3)=b12n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,3)=0;
        handles.tbl(2,3)=0;
        handles.tbl(3,3)=0;
        ejecuto_popupmenu(handles);

end
guidata(hObject, handles);
end


% --- Funcion que se ejecuta al presionar b16.
function b16_Callback(hObject, ~, handles)

handles.bot_16=get(hObject,'Value');
switch handles.bot_16
    case 1
       b16g=handles.cg(4);
       handles.tbl(1,4)=b16g;
       b16t=handles.t(4);
       handles.tbl(2,4)=b16t;
       b16n=handles.N(4);
       handles.tbl(3,4)=b16n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,4)=0;
        handles.tbl(2,4)=0;
        handles.tbl(3,4)=0;
        ejecuto_popupmenu(handles);

end
guidata(hObject, handles);
end


% --- Funcion que se ejecuta al presionar b17.
function b17_Callback(hObject, ~, handles)

handles.bot_17=get(hObject,'Value');
switch handles.bot_17
    case 1
       b17g=handles.cg(5);
       handles.tbl(1,5)=b17g;
       b17t=handles.t(5);
       handles.tbl(2,5)=b17t;
       b17n=handles.N(5);
       handles.tbl(3,5)=b17n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,5)=0;
        handles.tbl(2,5)=0;
        handles.tbl(3,5)=0;
        ejecuto_popupmenu(handles);
end
guidata(hObject, handles);
end


% --- Funcion que se ejecuta al presionar b18.
function b18_Callback(hObject, ~, handles)

handles.bot_18=get(hObject,'Value');
switch handles.bot_18
    case 1
       b18g=handles.cg(6);
       handles.tbl(1,6)=b18g;
       b18t=handles.t(6);
       handles.tbl(2,6)=b18t;
       b18n=handles.N(6);
       handles.tbl(3,6)=b18n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,6)=0;
        handles.tbl(2,6)=0;
        handles.tbl(3,6)=0;
        ejecuto_popupmenu(handles);

end
guidata(hObject, handles);
end


% --- Funcion que se ejecuta al presionar b19.
function b19_Callback(hObject, ~, handles)

handles.bot_19=get(hObject,'Value');
switch handles.bot_19
    case 1
       b19g=handles.cg(7);
       handles.tbl(1,7)=b19g;
       b19t=handles.t(7);
       handles.tbl(2,7)=b19t;
       b19n=handles.N(7);
       handles.tbl(3,7)=b19n;
       ejecuto_popupmenu(handles);
       
    case 0
        handles.tbl(1,7)=0;
        handles.tbl(2,7)=0;
        handles.tbl(3,7)=0;
        ejecuto_popupmenu(handles);
end
guidata(hObject, handles);
end


%-----------------------------------------------------------------------  
 
 % --- Executes during object creation, after setting all properties.
 function peso_CreateFcn(hObject, ~, ~)

 if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
 end
 end

 
 % --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edCOM_Callback(~, ~, ~)

end

% --- Executes during object creation, after setting all properties.
function edCOM_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function resetear_CreateFcn(hObject, ~, ~)

 if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
 end
 end

