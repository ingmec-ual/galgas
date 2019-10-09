function [t]=calculo_tension(cg)
% calulo de tensiones a partir de las deformaciones obtenidas por las
% galgas extensiom?tricas 
% deformaciones medidas en uE
E=66000; % modulo elastico del acero en N/mm2
t1=cg(1)*1.0e-6*E;     % barra 4.5
t2=cg(2)*1.0e-6*E;     % barra 13.12
t3=cg(3)*1.0e-6*E;     % barra 12.11
t4=cg(4)*1.0e-6*E;     % barra 4.14
t5=cg(5)*1.0e-6*E;     % barra 4.12
t6=cg(6)*1.0e-6*E;     % barra 12.6
t7=cg(7)*1.0e-6*E;     % barra 6.10
t=[t1, t2, t3, t4, t5, t6, t7]; % vector tension en MPa 
end