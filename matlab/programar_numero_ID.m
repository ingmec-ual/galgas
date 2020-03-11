close all; 
clear;
clear class;

%serialPortName='/dev/tty.usbserial-FT9PCFYR';
serialPortName='COM3';

% Nombre del puerto serie: terminal
s=GalgasComms(serialPortName);

cmd='TO 1 SETID 19\n';

s.internal_write(cmd);

rx=s.internal_read();
fprintf('RX: %s\n',rx);    

clear;
