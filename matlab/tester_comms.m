close all; 
clear;
clear class;

% Nombre del puerto serie: terminal
s=GalgasComms('/dev/tty.usbserial-FT9PCFYR');

%cmd='TO 1 ID\n';
%cmd='TO 1 GET STRAIN\n';
%cmd='TO 1 GET OFFSET\n';
cmd='TO 1 GET PWM_CONST\n';

s.internal_write(cmd);

for i=1:3
    rx=s.internal_read();
    fprintf('RX: %s\n',rx);
end

clear;
