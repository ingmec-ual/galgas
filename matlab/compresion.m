function compresion(p)

%   Dibuja estructura del puente resaltando las barras que estan sometidas
%   a compresion para cada caso de cg
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
if(p==2)
    xc12=[0.5, 0.5, 1, 1];
    yc12=[0.5, 1, 1, 0.5];
    plot(xc12,yc12,'r','LineWidth',2);
    hold on;
    x12=[1, 0.5];
    y12=[0.5, 0.5];
    plot(x12,y12,'k');
    hold on;
else
    xc12=[0.5, 0.5, 1];
    yc12=[0.5, 1, 1];
    plot(xc12,yc12,'r','LineWidth',2);
    hold on;
    x12=[1, 1, 0.5];
    y12=[1, 0.5, 0.5];
    plot(x12,y12,'k');
    hold on;
end

%   Cuadrado 2
xc2=[1, 1.5];
yc=[1, 1];
plot(xc2,yc,'r','LineWidth',2);
hold on;
x2=[1.5, 1.5, 1];
y=[1, 0.5, 0.5];
plot(x2,y,'k');
hold on;

%   Cuadrado 3
if(p==4)
    xc34=[1.5, 2, 2];
    yc34=[1, 1, 0.5];
    plot(xc34,yc34,'r','LineWidth',2);
    hold on;
    x34=[2, 1.5];
    y34=[0.5, 0.5];
    plot(x34, y34,'k');
    hold on;
else
    xc3=[1.5, 2];
    plot(xc3,yc,'r','LineWidth',2);
    hold on;
    x3=[2, 2, 1.5];
    plot(x3,y,'k');
    hold on;
    
end

%   Cuadrado 4
xc4=[2, 2.5];
plot(xc4,yc,'r','LineWidth',2);
hold on;
x4=[2.5, 2.5, 2];
plot(x4,y,'k');
hold on;

%   Cuadrado 5
xc5=[2.5, 3];
plot(xc5,yc,'r','LineWidth',2);
hold on;
x5=[3, 3, 2.5];
plot(x5,y,'k');
hold on;

%   Cuadrado 6
xc6=[3, 3.5, 3.5];
yc6=[1, 1, 0.5];
plot(xc6,yc6,'r','LineWidth',2);
hold on;
x6=[3.5, 3];
y6=[0.5, 0.5];
plot(x6,y6,'k');
hold on;

%   BARRAS DIAGONALES

% Barra 2.14
x7=[0.5, 1];
y7=[1, 0.5];
plot(x7,y7,'k');
hold on;

%   Barra 4.14
x8=[1, 1.5];
y8=[0.5, 1];

if(p==2)
    plot(x8,y8,'k');
    hold on;
else
    plot(x8,y8,'r','LineWidth',2);
    hold on;
end

%   Barra 4.12
x9=[1.5, 2];
y9=[1, 0.5];

if(p==2)||(p==3)
    plot(x9,y9,'r','LineWidth',2);
    hold on;
else
    plot(x9,y9,'k');
    hold on;
end

%   Barra 12.6
x10=[2, 2.5];
y10=[0.5, 1];

if(p==5)||(p==6)
    plot(x10,y10,'r','LineWidth',2);
    hold on;
else
    plot(x10,y10,'k');
    hold on;
end

%   Barra 6.10
x11=[2.5, 3];
y11=[1, 0.5];

if(p==6)
    plot(x11,y11,'k'); 
    hold on;
else
    plot(x11,y11,'r','LineWidth',2);
    hold on;
end

% Barra 10.8
x13=[3, 3.5];
y13=[0.5, 1];
plot(x13,y13,'k');
hold on;
axis equal off;

end


    
