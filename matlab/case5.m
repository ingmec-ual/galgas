function [c5n]=case5
% vector normalizado deformaciones caso 5 para persona 80kg%
% deformaciones medidas en uE%
c5=[-106.10, 66.31, 132.63, -635.28, 635.28, -635.28, -1111.79];
%barras [4.5, 13.12, 12.11, 4.14, 4.12, 12.6, 6.10]
c5n=(c5/max(abs(c5)));   %vector normalizado%
end
