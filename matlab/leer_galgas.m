function [cg] = leer_galgas(sComms, IDs)
%LEER_GALGAS Lee los valores de deformacion (uE) de todas las galgas conectadas.
% sComms debe ser un objeto de tipo GalgasComm, ya correctamente conectado
% al puerto serie. 
% IDs: lista de IDs de placas a leer. 

cg=[];
try
    for ID = IDs
        fprintf('Leyendo placa %i...', ID);
        new_strain_Vadc = sComms.getStrain(ID);
        
        % Convert from ADC volts -> uE:
        % TODO: strain = ???? 
        strain = new_strain_Vadc * 1;
        
        cg=[cg strain];

        fprintf(' Strain=%f\n', new_strain);
    end
    
catch ME
    msgbox(ME.message,'Error abriendo puerto serie');
end

end

