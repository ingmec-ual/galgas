classdef GalgasComms
    %GALGASCOMMS Clase para comunicarse con las placas del puente.
    % JLBC 2019 @ UAL
    %
    % Se usa RS485 (semiduplex), por lo que hay que forzar a:
    %  - RTS=off para transmitir.
    %  - RTS=on para recibir.
    %
    %
    
    properties (Access = private)
    end

    properties (Access = public)
        sPort;  % Serial port object
    end
    
    methods (Access = public)
        % Constructor:
        function obj = GalgasComms(serialPortName)
            obj.sPort = serial(serialPortName,'BaudRate',115200);
            fopen(obj.sPort);
        end
        
        
        % Destructor
        function delete(obj)
            fclose(obj.sPort);
       end

    end
    
    methods (Access = public)
        function internal_write(obj, text)
            obj.sPort.RequestToSend='off';
            fprintf(obj.sPort,text);
            obj.sPort.RequestToSend='on';
            pause(0.05)            
        end        
    end
    
end

