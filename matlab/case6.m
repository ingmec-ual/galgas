function [c6n]=case6
% vector normalizado deformaciones caso 6 para persona 80kg%
% deformaciones medidas en uE%
c6=[-53.05, 39.79, 66.31, -317.64, 317.64, -317.64, 317.64];
%barras [4.5, 13.12, 12.11, 4.14, 4.12, 12.6, 6.10]
c6n=(c6/max(abs(c6)));   %vector normalizado%
end