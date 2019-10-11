function [K]=constante
%   Matriz constante de axiles
%   N=K*F ya que no entra en la zona pl?stica
%   solo se produce deformaci?n el?stica
k2=[-1/2, 2/3, 1/3, sqrt(2)/6, -sqrt(2)/6, sqrt(2)/6, -sqrt(2)/6];
k3=[-1, 4/3, 2/3, -2*sqrt(2)/3, -sqrt(2)/3, sqrt(2)/3, -sqrt(2)/3];
k4=[-3/2, 1, 1, -sqrt(2)/2, sqrt(2)/2, sqrt(2)/2, -sqrt(2)/2];
k5=[-1, 2/3, 4/3, -sqrt(2)/3, sqrt(2)/3, -sqrt(2)/3, -2*sqrt(2)/3];
k6=[-1/2, 1/3, 2/3, -sqrt(2)/6, sqrt(2)/6, -sqrt(2)/6, sqrt(2)/6];
K=[k2; k3; k4; k5; k6];
end