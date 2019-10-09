function [F]=calculo_peso(N,x)
% calculo del peso cuando la persona se encuentra en 
% los casos 3, 4, 5 y 6 (todos menos caso 2)
% vector de axiles en N
v=N(2);
p=(v*3)/(6-2*x);  % valor de la fuerza en N
F=p/9.807;  % peso de la persona en Kg
end