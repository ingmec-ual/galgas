classdef GalgasComms < handle
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
            set(obj.sPort, 'Timeout', 1.0);
            fopen(obj.sPort);
            obj.internal_enable_rx();
        end
        
        
        % Destructor
        function delete(obj)
            fclose(obj.sPort);
        end

        % Get the self-description text from a node with ID=id
        function s = getID(self, id)
            cmd=sprintf('TO %i ID\n',id);
            internal_write(self, cmd);
            s = internal_read(self);
        end
        
        % Get the last strain value from a node with ID=id (in volts)
        function s = getStrain(self, id)
            cmd=sprintf('TO %i GET STRAIN\n',id);
            internal_write(self, cmd);
            rx = internal_read(self);
            if (strfind(rx,'TX:OK|')~=1)
                error('Unexpected received string from uC: "%s"',rx);
            end
            K_adc = 1.0/(2^15);
            s = str2double(rx(7:end))*K_adc;
        end
        
    end
    
    methods (Access = public)
        function internal_write(obj, text)
            obj.internal_enable_tx();
            pause(0.02);
            fprintf(obj.sPort,text);
            pause(0.02);
            obj.internal_enable_rx();
        end        
        
        function [text] = internal_read(obj)
            obj.internal_enable_rx();
            text = fgetl(obj.sPort);
            if (text==-1)
                text='';
            end                
        end        

        function internal_enable_tx(obj)
            obj.sPort.RequestToSend='off';
        end        
        function internal_enable_rx(obj)
            obj.sPort.RequestToSend='on';
        end        
        
        
    end
    
end

