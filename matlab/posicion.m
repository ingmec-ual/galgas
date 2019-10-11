function [p]=posicion(cg,C)
%   Calcula la posicion en la que se encuentra la persona sobre 
%   el puente
%   cg vector deformaciones medidas por las galgas en uE%
cgn=(cg/max(abs(cg)));  %   vector normalizado%
%   Calculo la distancia de cada vector caso con el vector deformaciones
%   medidas por las galgas
d=zeros(1,5);   %   vector distancia vac?o
for i=1:5;
    ci=C(i,:);
    d(i)= norm(ci-cgn)^2;
end
%   Calculo la distancia minima que me indicar? en que posicion 
%   se encuentra la persona sobre el puente
%   m valor de la distancia minima
%   i posicion en el vector distancia donde se encuentra la distancia
%   minima
[m,i]=min(d);
p=i+1;
end

