close all; 
clear;
clear class;

%<<<<<<< HEAD
% Nombre del puerto serie: terminal
s=GalgasComms('/dev/tty.usbserial-FT9PCFYR');
%=======
s=GalgasComms('COM3');
%>>>>>>> 58395c001b9a7617f0259f91f4de37680fd3c08b

%cmd='TO 1 ID\n';
%cmd='TO 255 SETID 1\n';
cmd='TO 1 GET STRAIN\n';
%cmd='TO 1 GET OFFSET\n';
%cmd='TO 1 GET PWM_CONST\n';

s.internal_write(cmd);

rx=s.internal_read();
fprintf('RX: %s\n',rx);    

clear;
