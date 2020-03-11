function [t]=calculo_tension(cg)

% Calulo de tensiones a partir de las deformaciones obtenidas por las
% galgas extensiometricas 
% cg vector deformaciones (E) medidas por las galgas
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura Gomez Alvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------

E=66000; % modulo elastico del acero en N/mm2
t1=cg(1)*E;     % barra 4
t2=cg(2)*E;     % barra 11
t3=cg(3)*E;     % barra 12
t4=cg(4)*E;     % barra 16
t5=cg(5)*E;     % barra 17
t6=cg(6)*E;     % barra 18
t7=cg(7)*E;     % barra 19
t=[t1, t2, t3, t4, t5, t6, t7]; % vector tension en MPa 
end