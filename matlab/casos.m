function [C]=casos

%   Matriz con los valores de deformaciones normalizados para 
%   una persona de 80Kg
%   Deformaciones medidas en uE
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura Gomez Alvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------

%   Caso 2
c2=[-26.0218, 17.3478, 34.6957, 146.8928, -146.8928, 146.8928, -146.8928];
%barras [4, 11, 12, 16, 17, 18, 19]
c2n=(c2/max(abs(c2)));    %vector normalizado%

%   Caso 3
c3=[-52.0435, 34.6957, 69.3914, -587.5711, -293.7856, 293.7856, -293.7856];
c3n=(c3/max(abs(c3)));

%   Caso 4
c4=[-78.0653, 52.0435, 52.0435, -440.6783, 440.6783, 440.6783, -440.6783];
c4n=(c4/max(abs(c4)));

%   Caso 5
c5=[-52.0435, 69.3914, 34.6957, -293.7856, 293.7856, -293.7856, -587.5711];
c5n=(c5/max(abs(c5))); 

%   Caso 6
c6=[-26.0218, 34.6957, 17.3478, -146.8928, 146.8928, -146.8928, 146.8928];
c6n=(c6/max(abs(c6)));

%   Matriz casos compuesta por los vectores normalizados
C=[c2n; c3n; c4n; c5n; c6n];
end
