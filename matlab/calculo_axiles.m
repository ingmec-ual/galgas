function [N]=calculo_axiles(t)

% Calculo de axiles a partir de las tensiones (t)
% Tensiones en MPa
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura Gomez Alvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------

o1=114.24;  % area barras principales en mm2
o2=9.54;    % area diagonales y barras verticales en mm2
N1=t(1)*o1;     % barra 4.5
N2=t(2)*o1;     % barra 13.12
N3=t(3)*o1;     % barra 12.11
N4=t(4)*o2;     % barra 4.14
N5=t(5)*o2;     % barra 4.12
N6=t(6)*o2;     % barra 12.6
N7=t(7)*o2;     % barra 6.10
N=[N1, N2, N3, N4, N5, N6, N7]; % vector axil en N
end

