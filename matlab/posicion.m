function [p]=posicion(cg,C)
%   Calcula la posicion en la que se encuentra la persona sobre 
%   el puente
%   cg vector deformaciones medidas por las galgas en uE
%   C matriz casos compuesta por los vectores normalizados

cgn=(cg/max(abs(cg)));  %   vector deformaciones normalizado%
%   Calculo la distancia de cada vector caso con el vector deformaciones
%   medidas por las galgas
d=zeros(1,5);   %   vector distancia vacio
for idx_caso=1:5;
    ci=C(idx_caso,:);
    d(idx_caso)= norm(ci-cgn);
end
%   Calculo la distancia minima que me indicara en que posicion 
%   se encuentra la persona sobre el puente
%   idx_mejor posicion en el vector distancia donde se encuentra 
%   la distancia minima
[~,idx_mejor]=min(d);
p=idx_mejor+1;
end

