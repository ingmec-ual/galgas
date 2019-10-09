function [C]=casos
%   Matriz con los valores de deformaciones normalizados para 
%   una persona de 80Kg
%   Deformaciones medidas en uE

%   Caso 2
c2=[-53.05, 66.31, 39.79, 317.64, -317.64, 317.64, -317.64];
%barras [4.5, 13.12, 12.11, 4.14, 4.12, 12.6, 6.10]
c2n=(c2/max(abs(c2)));    %vector normalizado%

%   Caso 3
c3=[-106.10, 132.63, 66.31, -1111.75, -635.28, 635.28, -635.28];
c3n=(c3/max(c3));

%   Caso 4
c4=[-159.15, 106.10, 106.10, -952.93, 794.10, 794.10, -952.93];
c4n=(c4/max(abs(c4)));

%   Caso 5
c5=[-106.10, 66.31, 132.63, -635.28, 635.28, -635.28, -1111.79];
c5n=(c5/max(abs(c5))); 

%   Caso 6
c6=[-53.05, 39.79, 66.31, -317.64, 317.64, -317.64, 317.64];
c6n=(c6/max(abs(c6)));

%   Matriz casos compuesta por los vectores normalizados
C=[c2n; c3n; c4n; c5n; c6n];
end
