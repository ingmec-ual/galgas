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


% --- Funcion que se ejecuta al presionar boton medir
function medir_Callback(~, ~, handles)

% Inicia el temporizador
start(handles.timer);

% Desactiva el boton de medir 
set(handles.medir, 'Enable', 'off');

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

% Activa el boton de medir 
set(handles.medir, 'Enable', 'on');
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
global t;
global N;

% compruebo longitudo del vector cg, si no es correcto no continua
% ejecutando el programa
if (length(handles.cg)<2)
    return
end
%datos=[];
switch handles.x
    case 1
        set(handles.tabla,'data', handles.cg);  % Obtengo valores de deformacion 
       
    case 2
        set(handles.tabla,'data', t);   % Obtengo valores de tension 
        
    case 3
        set(handles.tabla,'data', N);   % Obtengo valores de axiles
end

end


% --- Funcion que cambia color barras segun si estan sometidas a T/C
function actualiza_grafica_barras(handles)
% Muestro en la grafica de la estructura del puente barras sometidas a
% traccion o compresion marcandolas de color morado
% cg vector deformaciones medidas por las galgas en uE
% TC variable con valor "Traccion" o "Compresion" segun el boton que este
% presionado

% compruebo longitudo del vector cg, si no es correcto no continua
% ejecutando el programa
if (length(handles.cg)<2)
    return
end
    
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
 function timerCallback(hObject, eventdata, hFigure)
 
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
global t;
global N;

% --- Calculo el peso que hay sobre el puente. --------------------------

C=casos;    % Ejecuto script
handles.cg=[-87.17293736, 116.2305831, 58.11529157,	-984.1815939, -492.0907969,	492.0907969, -492.0907969];
% Sumar ruido aleatorio (mientras no se mida del real)
handles.cg = handles.cg + randn(size(handles.cg,1),size(handles.cg,2))*0.1;

% Calculo la posicion sobre el puente 
p=posicion(handles.cg,C);
% Muestro en pantalla la posicion en la que se encuentra la persona
img=imread(sprintf('caso%d.jpg',p));
imshow(img,'Parent',handles.foto);
axis equal;

% Calculo el peso
t=calculo_tension(handles.cg);
N=calculo_axiles(t);
K=constante();
F=calculo_peso(N,K,p);

% --- Muestro valores actuales del peso---------------------------------
texto=sprintf('Peso: %5.1f Kg',F);
set(handles.peso,'String',texto);

% --- Muestro los valores actuales del popupmenu------------------------
ejecuto_popupmenu(handles);

% Actualizo seleccion de TC:
actualiza_grafica_barras(handles);

guidata(hFigure,handles);
 end

 
 % --- Executes during object creation, after setting all properties.
 function peso_CreateFcn(hObject, ~, ~)
 % hObject    handle to edit1 (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    empty - handles not created until after all CreateFcns called

 % Hint: edit controls usually have a white background on Windows.
 %       See ISPC and COMPUTER.
 if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
 end
 end

 
 % --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
