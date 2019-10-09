function [F]=calculo_caso2(N)
% calculo del peso cuando la persona se encuentra en el caso 2
% vector de axiles en N
v=N(1);
f=-(v/0.5); % valor de la fuerza en N
F=f/9.807;  % peso de la persona en Kg
end
