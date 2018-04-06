classdef RemotePowerSwitch
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % {char 1xm} tcp/ip host
        cHost = '192.168.10.30'
        
        % {uint8 1x1} channel
        u8Outlet = 1 
        
        % {char 1xm} username for authentication with web request
        cUser = 'admin';
        
        % {char 1xm} password for authentication with web request
        cPass = 'MET5@lbl';
        
        
    end
    
    methods
        
        function this = RemotePowerSwitch(varargin) 
            
            for k = 1 : 2: length(varargin)
                % this.msg(sprintf('passed in %s', varargin{k}));
                if this.hasProp( varargin{k})
                    % this.msg(sprintf('settting %s', varargin{k}));
                    this.(varargin{k}) = varargin{k + 1};
                end
            end
                        
        end
        
        
        function turnOn(this)
            cUrl = [...
                this.getAuthenticatedUrl(), ...
                sprintf('&target=%d', this.u8Outlet), ...
                '&control=1' ...
            ];
            
            data = webread(cUrl, 'ContentType', 'xmldom'); 
            
        end
        
        function turnOff(this)
            
            cUrl = [...
                this.getAuthenticatedUrl(), ...
                sprintf('&target=%d', this.u8Outlet), ...
                '&control=1' ...
            ];
            data = webread(cUrl, 'ContentType', 'xmldom');
            
        end
        
        
        function reset(this)
            
            cUrl = [...
                this.getAuthenticatedUrl(), ...
                sprintf('&target=%d', this.u8Outlet), ...
                '&control=3' ...
            ];
            data = webread(cUrl, 'ContentType', 'xmldom');
            
        end
        
        function isOn(this)
            
        end
        
        
        
    end
    
    methods (Access = private)
        
      
       
        function c = getAuthenticatedUrl(this)
            
            c = [...
                sprintf('http://%s/cgi-bin/control2.cgi', this.cHost), ...
                sprintf('?user=%s', this.cUser), ...
                sprintf('&passwd=%s', this.cPass) ...
            ];
        end
        
    end
    
end

