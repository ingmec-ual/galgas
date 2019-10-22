function [K]=constante

%   Matriz constante de axiles
%   N=K*F ya que no entra en la zona plastica
%   solo se produce deformacion elastica
% -----------------------------------------------------------
%   Copyright (c) 2018-2019, Laura G?mez ?lvarez 
%   University of Almeria
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% -----------------------------------------------------------
k2=[-1/2, 2/3, 1/3, sqrt(2)/6, -sqrt(2)/6, sqrt(2)/6, -sqrt(2)/6];
k3=[-1, 4/3, 2/3, -2*sqrt(2)/3, -sqrt(2)/3, sqrt(2)/3, -sqrt(2)/3];
k4=[-3/2, 1, 1, -sqrt(2)/2, sqrt(2)/2, sqrt(2)/2, -sqrt(2)/2];
k5=[-1, 2/3, 4/3, -sqrt(2)/3, sqrt(2)/3, -sqrt(2)/3, -2*sqrt(2)/3];
k6=[-1/2, 1/3, 2/3, -sqrt(2)/6, sqrt(2)/6, -sqrt(2)/6, sqrt(2)/6];
K=[k2; k3; k4; k5; k6];
end