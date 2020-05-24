function traccion(p)

%   Dibuja estructura del puente resaltando las barras que estan sometidas
%   a traccion para cada caso de cg
%   p es la posicion en la que se encuentra la carga
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura Gomez Alvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------


%   Cuadrado 1
x1=[0.5, 0.5, 1, 1, 0.5];
y1=[0.5, 1, 1, 0.5, 0.5];
plot(x1,y1,'k');
hold on;

%   Cuadrado 2
x2=[1, 1.5, 1.5];
y=[1, 1, 0.5];
plot(x2,y,'k');
hold on;
xt2=[1.5, 1];
yt=[0.5, 0.5];
plot(xt2,yt,'b','LineWidth',2);
hold on;

%   Cuadrado 3 
x3=[1.5, 2, 2];
plot(x3,y,'k');
hold on;
xt3=[2, 1.5];
plot(xt3,yt,'b','LineWidth',2);
hold on;

%   Cuadrado 4

x4=[2, 2.5, 2.5];
plot(x4,y,'k');
hold on;
xt4=[2.5, 2];
plot(xt4,yt,'b','LineWidth',2);
hold on;

%   Cuadrado 5
if(p==6)
    x56=[2.5, 3];
    y56=[1, 1];
    plot(x56,y56,'k');
    hold on;
    xt56=[3, 3, 2.5];
    yt56=[1, 0.5, 0.5];
    plot(xt56,yt56,'b','LineWidth',2);
    hold on;
else
    x5=[2.5, 3, 3];
    plot(x5,y,'k');
    hold on;
    xt3=[3, 2.5];
    plot(xt3,yt,'b','LineWidth',2);
    hold on;
end

%   Cuadrado 6

x6=[3, 3.5, 3.5, 3];
y6=[1, 1, 0.5, 0.5];
plot(x6,y6,'k');
hold on;

%   BARRAS DIAGONALES

%  Barra 2.14
x7=[0.5, 1];
y7=[1, 0.5];
plot(x7,y7,'b','LineWidth',2);
hold on;

%   Barra 4.14
x8=[1, 1.5];
y8=[0.5, 1];

if(p==2)
    plot(x8,y8,'b','LineWidth',2);
    hold on;
else
    plot(x8,y8,'k');
end
    
%   Barra 4.12
x9=[1.5, 2];
y9=[1, 0.5];

if(p==2)||(p==3)
    plot(x9,y9,'k');
    hold on;
else
    plot(x9,y9,'b','LineWidth',2);
    hold on;
end

%   Barra 12.6
x10=[2, 2.5];
y10=[0.5, 1];

if(p==5)||(p==6)
    plot(x10,y10,'k');
    hold on;
else
    plot(x10,y10,'b','LineWidth',2);
    hold on;
end

%   Barra 6.10
x11=[2.5, 3];
y11=[1, 0.5];

if(p==6)
    plot(x11,y11,'b','LineWidth',2); 
    hold on;
else
    plot(x11,y11,'k');
    hold on;
end

% Barra 10.8
x13=[3, 3.5];
y13=[0.5, 1];
plot(x13,y13,'b','LineWidth',2);
hold on;
axis equal off;
end


    
