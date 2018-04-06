classdef RemotePowerSwitch < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % {char 1xm} tcp/ip host
        cHost = '192.168.10.30'
        
        % {uint8 1x1} outlet (1 or 2)
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
                      
            data = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', this.u8Outlet, ...
                'control', 1 ...
            );
                    
        end
        
        function turnOff(this)
            
            data = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', this.u8Outlet, ...
                'control', 0 ...
            );
        end
        
        
        function reset(this)
            
           data = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', this.u8Outlet, ...
                'control', 3 ...
            );
            
        end
        
        function l = isOn(this)
            
            cXml = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', '/xml/outlet_status.xml' ...
            );
        
            [cMatch, ceTok] = regexp(cXml, ...
                '<outlet_status>([0-9,]+)<\/outlet_status>', ...
                'match', ...
                'tokens' ...
             );
         
            % ceTok{1}{1} formatted as num,num e.g., 0,1 or 0,0, or 1,1 
            % indicating the status of outlets one and two, respectively.
            
            ceStatus = strsplit(ceTok{1}{1}, ',');
            if this.u8Outlet == 1
                cStatus = ceStatus{1};
            else % outlet 2
                cStatus = ceStatus{2};
            end
            
            switch cStatus
                case '0'
                    l = false;
                case '1'
                    l = true;
            end
          
            
        end
        
        
        
    end
    
    methods (Access = private)
        
        function l = hasProp(this, c)
            
            l = false;
            if ~isempty(findprop(this, c))
                l = true;
            end
            
        end
        
        function c = getUrl(this)
             c = sprintf('http://%s/cgi-bin/control2.cgi', this.cHost);
        end
       
        
    end
    
end

