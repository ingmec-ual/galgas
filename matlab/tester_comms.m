close all; 
clear;
clear class;

%serialPortName='/dev/tty.usbserial-FT9PCFYR';
serialPortName='COM3';

% Nombre del puerto serie: terminal
s=GalgasComms(serialPortName);

eps = s.getStrain(1)

%IDs=[1];
%cg = leer_galgas(s, IDs)

clear
return;

%cmd='TO 1 ID\n';
%cmd='TO 255 SETID 1\n';
cmd='TO 1 GET STRAIN\n';
%cmd='TO 1 GET OFFSET\n';
%cmd='TO 1 GET PWM_CONST\n';

s.internal_write(cmd);

rx=s.internal_read();
fprintf('RX: %s\n',rx);    

clear;
