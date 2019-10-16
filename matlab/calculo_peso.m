function [F]=calculo_peso(N,K,p)
%   Calculo del peso cuando la persona
%   Solo se produce deformaci?n el?stica

f=median(N./K(p-1,:));

F=f/9.81;
end