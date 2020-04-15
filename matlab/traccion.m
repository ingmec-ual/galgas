function traccion(cg)

%   Dibuja estructura del puente resaltando las barras que estan sometidas
%   a traccion para cada caso de cg
%   cg vector deformacion (uE) medido por las galgas
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura Gomez Alvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------

v1=cg(1)*1e6;
v2=cg(2)*1e6;
v3=cg(3)*1e6;
v4=cg(4)*1e6;
v5=cg(5)*1e6;
v6=cg(6)*1e6;
v7=cg(7)*1e6;

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
%   Cambia de color si esta sometido a traccion
if((v1>0)&&(v2>0))
    xt31=[1.5, 2];
    yt31=[1, 1];
    plot(xt31,yt31,'m','LineWidth',3);
    hold on;
    x3=[2, 2];
    y3=[1, 0.5];
    plot(x3,y3,'k');
    hold on;
    xt32=[2, 1.5];
    yt32=[0.5, 0.5];
    plot(xt32,yt32,'m','LineWidth',3);
    hold on;
else
    if(v1>0)
        xt31=[1.5, 2];
        yt31=[1, 1];
        plot(xt31,yt31,'m','LineWidth',3);
        hold on;
        x3=[2, 2, 1.5];
        y3=[1, 0.5, 0.5];
        plot(x3,y3,'k');
        hold on;
    end
    
    if(v2>0)
        x3=[1.5, 2, 2];
        y3=[1, 1, 0.5];
        plot(x3, y3, 'k');
        hold on;
        xt32=[2, 1.5];
        yt32=[0.5, 0.5];
        plot(xt32,yt32,'m','LineWidth',3);
    end
    
    if((v1<=0)&&(v2<=0))
        x3=[1.5, 2, 2, 1.5];
        plot(x3,y,'k');
        hold on;
    end
end

%   Cuadrado 4
%   Cambia de color si esta sometido a traccion
if(v3>0)
    x4=[2, 2.5, 2.5];
    y4=[1, 1, 0.5];
    plot(x4, y4, 'k');
    hold on;
    xt4=[2.5, 2];
    yt4=[0.5, 0.5];
    plot(xt4,yt4, 'm','LineWidth',3);
    hold on;
else
    x4=[2, 2.5, 2.5, 2];
    plot(x4,y,'k');
    hold on;
end

%   Cuadrado 5
x5=[2.5, 3, 3, 2.5];
plot(x5,y,'k');
hold on;

%   Cuadrado 6
x6=[3, 3.5, 3.5, 3];
plot(x6,y,'k');
hold on;

%   BARRAS DIAGONALES

%   No cambia de color
x7=[0.5, 1];
y7=[1, 0.5];
plot(x7,y7,'k');
hold on;

%   Barra 4.14
x8=[1, 1.5];
y8=[0.5, 1];
if(v4>0)
    plot(x8,y8,'m','LineWidth',3);
    hold on;
else
    plot(x8,y8,'k');
    hold on;
end

%   Barra 4.12
x9=[1.5, 2];
y9=[1, 0.5];
if(v5>0)
    plot(x9,y9,'m','LineWidth',3);
    hold on;
else
    plot(x9,y9,'k');
    hold on;
end

%   Barra 12.6
x10=[2, 2.5];
y10=[0.5, 1];
if(v6>0)
    plot(x10,y10,'m','LineWidth',3);
    hold on;
else
    plot(x10,y10,'k');
    hold on;
end

%   Barra 6.10
x11=[2.5, 3];
y11=[1, 0.5];
if(v7>0)
    plot(x11,y11,'m','LineWidth',3);
    hold on;
else
    plot(x11,y11,'k');
    hold on;
end

% No cambia de color
x12=[3, 3.5];
y12=[0.5, 1];
plot(x12,y12,'k');
hold on;
axis equal off;
end


    
