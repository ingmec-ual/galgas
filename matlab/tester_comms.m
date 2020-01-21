close all; 
clear;
clear class;

s=GalgasComms('COM3');

%cmd='TO 1 ID\n';
%cmd='TO 255 SETID 1\n';
cmd='TO 1 GET STRAIN\n';
%cmd='TO 1 GET OFFSET\n';
%cmd='TO 1 GET PWM_CONST\n';

s.internal_write(cmd);

rx=s.internal_read();
fprintf('RX: %s\n',rx);    

clear;
