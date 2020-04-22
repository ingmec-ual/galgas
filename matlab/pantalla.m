function varargout = pantalla(varargin)

% Interfaz del programa, muestra en pantalla la posicion en la que se
% encuentra la persona, su peso, los valores de deformacion, axiles y
% tensiones y las barras que estan sometidas a off y a compresion
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
% TC valor off/compresion para tipo de esfuerzos
% x valor para popupmenu
handles.cg=[];

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
% off o compresion marcandolas de color morado
% TC variable con valor "off" o "Compresion" segun el boton que este
% presionado
if (length(handles.cg)<2)
   return
else
    handles.TC=get(hObject, 'String');
    actualiza_grafica_barras(handles);
end

end

% --- Selecciono el modo de medicion: NO/REAL
function tipo_medicion_SelectionChangedFcn(hObject, eventdata, handles)

handles.medicion=get(hObject,'String');

switch handles.medicion
    case 'Simulacion'
        set(handles.medir, 'Enable', 'on');
        set(handles.real, 'Enable', 'off');
        handles.sim=1;
        
    case 'Real'
        set(handles.text5, 'Enable', 'on');
        set(handles.edCOM, 'Enable', 'on');
        set(handles.btnConnect, 'Enable', 'on');
        set(handles.simulacion, 'Enable', 'off');
        handles.sim=0;
end

   guidata(hObject,handles);

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
function btnDisconnect_Callback(hObject, ~, handles)

% Se desconecta el puerto serie en el que van conectadas las placas

try
    clear handles.s;
    
    resetear_Callback(handles);
    
    set(handles.btnConnect, 'Enable', 'on');
    set(handles.btnDisconnect, 'Enable', 'off');
    
    guidata(hObject,handles);
 
catch ME
    msgbox(ME.message,'Error abriendo puerto serie');
end

end


% --- Funcion que se ejecuta al presionar boton medir
function medir_Callback(~, ~, handles)

% Inicia el temporizador
start(handles.timer);

% Desactiva y activa los botones
set(handles.medir, 'Enable', 'off');
set(handles.resetear, 'Enable', 'on');
set(handles.traccion, 'Enable', 'on');
set(handles.compresion, 'Enable', 'on');
 
end


% --- Funcion que se ejecuta al presionar boton resetear.
function resetear_Callback(handles)

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
% barras sometidas a off o a compresion
axes(handles.grafica);
cla;
grafica_puente;
axis equal;

% Activa y desactiva los botones
set(handles.medir, 'Enable', 'on');
set(handles.compresion, 'Enable', 'inactive');
set(handles.traccion, 'Enable', 'inactive');
set(handles.resetear, 'Enable', 'off');
end

% --- Executes on button press in salir.
function salir_Callback(hObject, eventdata, handles)

resetear_Callback(handles);
set(handles.text5, 'Enable', 'off');
set(handles.edCOM, 'Enable', 'off');
set(handles.btnConnect, 'Enable', 'off');
set(handles.medir, 'Enable', 'off');
set(handles.simulacion, 'Enable', 'on');
set(handles.real, 'Enable', 'on');
set(handles.btnDisconnect, 'Enable', 'off');

end

%------------------------------------------------------------------------

% ---MODULOS---


% --- Funcion que cambia color barras segun si estan sometidas a T/C
function actualiza_grafica_barras(handles)

% Muestro en la grafica de la estructura del puente barras sometidas a
% off o compresion marcandolas de color morado
% cg vector deformaciones medidas por las galgas en uE
% TC variable con valor "off" o "Compresion" segun el boton que este
% presionado

if (length(handles.cg)<2)
   return
else
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
% TC variable con valor "off" o "Compresion"
% texto variable contiene texto con valor peso que se impreme en pantalla
handles = guidata(hFigure);

% --- Calculo el peso que hay sobre el puente. --------------------------

C=casos;    % Ejecuto script


if (handles.sim==1)
    
    % Datos simulados de prueba en uE:
    handles.cg=[-37.0810, 24.7207, 49.4414, -418.6444, -209.3222, 209.3222, -209.3222];
    % Sumar ruido aleatorio (mientras no se mida del real)
    handles.cg = handles.cg + randn(size(handles.cg,1),size(handles.cg,2))*0.1;
    
else
    % Mido el sistema real
    % IDS: [4; 11; 12; 16; 17; 18; 19];
    handles.cgE(1)=leer_galgas(handles.s, 4);
    handles.cgE(2)=leer_galgas(handles.s, 11);
    handles.cgE(3)=leer_galgas(handles.s, 12);
    handles.cgE(4)=leer_galgas(handles.s, 16);
    handles.cgE(5)=leer_galgas(handles.s, 17);
    handles.cgE(6)=leer_galgas(handles.s, 18);
    handles.cgE(7)=leer_galgas(handles.s, 19);
    handles.cg=1e6*handles.cgE;
    
end

if (length(handles.cg)<2)
    
    msgbox('Error leyendo placas');
    
else  
    
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

    % --- Muestro valores actuales del peso-----------------------------
    texto=sprintf('Peso: %5.1f Kg',F);
    set(handles.peso,'String',texto);

    % --- Actualizo tabla-----------------------------------------------  
    defor=handles.cg;
    tension=handles.t;
    axil=handles.N;

    datos=[defor; tension; axil];
    set(handles.tabla, 'data', datos);
end

guidata(hFigure,handles);
 end


%-----------------------------------------------------------------------  
 
 % --- Executes during object creation, after setting all properties.
 function peso_CreateFcn(hObject, ~, ~)

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
