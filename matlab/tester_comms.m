close all; 
clear;
clear class;

s=GalgasComms('COM3');

cmd='T'; %O 1 ID\n';
%cmd='TO 255 SETID 1\n';
%cmd='TO 1 GET STRAIN\n';
%cmd='TO 1 GET OFFSET\n';
%cmd='TO 1 GET PWM_CONST\n';

s.internal_write(cmd);

for i=1:100
    rx=s.internal_read();
    if (strcmp(rx,''))
        break;
    else
        fprintf('RX: %s\n',rx);    
    end
end

clear;
