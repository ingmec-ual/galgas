function [c3n]=case3
% vector normalizado deformaciones caso 3 para persona 80kg%
% deformaciones medidas en uE%
c3=[-106.10, 132.63, 66.31, -1111.75, -635.28, 635.28, -635.28];
%barras [4.5, 13.12, 12.11, 4.14, 4.12, 12.6, 6.10]
c3n=(c3/max(c3));
end