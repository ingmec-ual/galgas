function [F]=calculo_peso(N,K,p)
%   Calculo del peso cuando la persona
%   Solo se produce deformaci?n el?stica
if(p==2)
    f=N(1)/K(1,1);
end
if(p==3)
    f=N(1)/K(2,1);
end
if(p==4)
    f=N(1)/K(3,1);
end
if(p==5)
    f=N(1)/K(4,1);
end
if(p==6)
    f=N(1)/K(5,1);
end
F=f/9.81;
end