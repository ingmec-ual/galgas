function grafica_puente

%   Dibujo estructura del puente
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura G?mez ?lvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------

%   BARRAS HORIZONTALES Y VERTICALES 
%   Cuadrado 1
x1=[0.5, 0.5, 1, 1, 0.5];
y1=[0.5, 1, 1, 0.5, 0.5];
plot(x1,y1,'k');
hold on;

%   Cuadrado 2
x2=[1, 1.5, 1.5, 1];
y=[1, 1, 0.5, 0.5];
plot(x2,y,'k');
hold on;

%   Cuadrado 3
x3=[1.5, 2, 2, 1.5];
plot(x3,y,'k');
hold on;

%   Cuadrado 4
x4=[2, 2.5, 2.5, 2];
plot(x4,y,'k');
hold on;

%   Cuadrado 5
x5=[2.5, 3, 3, 2.5];
plot(x5,y,'k');
hold on;

%   Cuadrado 6
x6=[3, 3.5, 3.5, 3];
plot(x6,y,'k');
hold on;

%   Barras diagonales

x7=[0.5, 1];
y7=[1, 0.5];
plot(x7,y7,'k');
hold on;

x8=[1, 1.5];
y8=[0.5, 1];
plot(x8,y8,'k');
hold on;

x9=[1.5, 2];
y9=[1, 0.5];
plot(x9,y9,'k');
hold on;

x10=[2, 2.5];
y10=[0.5, 1];
plot(x10,y10,'k');
hold on;

x11=[2.5, 3];
y11=[1, 0.5];
plot(x11,y11,'k');
hold on;

x12=[3, 3.5];
y12=[0.5, 1];
plot(x12,y12,'k');
hold on;
axis equal off;
end




