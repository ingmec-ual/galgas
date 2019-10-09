function [c4n]=case4
% vector normalizado deformaciones caso 4 para persona 80kg%
% deformaciones medidas en uE%
c4=[-159.15, 106.10, 106.10, -952.93, 794.10, 794.10, -952.93];
%barras [4.5, 13.12, 12.11, 4.14, 4.12, 12.6, 6.10]
c4n=(c4/max(abs(c4)));   %vector normalizado%
end
