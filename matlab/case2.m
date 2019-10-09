function [c2n]=case2
% vector normalizado deformaciones caso 2 para persona 80kg%
% deformaciones medidas en uE%
c2=[-53.05, 66.31, 39.79, 317.64, -317.64, 317.64, -317.64];
%barras [4.5, 13.12, 12.11, 4.14, 4.12, 12.6, 6.10]
c2n=(c2/max(abs(c2)));    %vector normalizado%
end
