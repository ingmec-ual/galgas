function [cg] = leer_galgas(sComms, IDs)
%LEER_GALGAS Lee los valores de deformacion (uE) de todas las galgas conectadas.
% sComms debe ser un objeto de tipo GalgasComm, ya correctamente conectado
% al puerto serie. 
% IDs: lista de IDs de placas a leer. 
% ID de la placa que se esta llamando
% cg vector deformaciones medidas por las galgas en uE
% strain valor de la deformaci?n real de la barra
% new_strain_Vadc voltaje procedente de la placa y referido a la
% deformacion de la barra
% Gadc ganancia del ADS
% Gampl ganacia del amplificador
% vs voltaje puente de Wheatstone
% ve voltaje de entrada (5V)
% kg factor de galga 
Gadc = 1;
Gampl = 100;
kg=2;
ve=5;
cg=[];
try
    for ID = IDs
        fprintf('Leyendo placa %i...', ID);
        new_strain_Vadc = sComms.getStrain(ID);
        vs = new_strain_Vadc/(Gadc * Gampl);
        strain=(1/kg)*(1/((vs/ve)+(1/2))-2);
        
        cg=[cg, strain];

        fprintf(' Strain=%f\n', new_strain);
    end
    
catch ME
    msgbox(ME.message,'Error abriendo puerto serie');
end

end

