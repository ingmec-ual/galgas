function [F]=calculo_peso(N,K,p)
%   Calculo del peso en Kg
%   N vector axiles en N
%   K matriz de constantes
%   p posicion en la que se encuentra la persona sobre el puente
%   Mediante la formula F=N/K calculo el peso para todos los valores de
%   N en cada caso y calculo la mediana de todas las F 
%   Caso en el que me encuentro viene determinado por p-1
f=median(N./K(p-1,:));
F=f/9.81;
end