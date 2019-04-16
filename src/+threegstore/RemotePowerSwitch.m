classdef RemotePowerSwitch < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % {char 1xm} tcp/ip host
        cHost = '192.168.10.30'
        
               
        % {char 1xm} username for authentication with web request
        cUser = 'admin';
        
        % {char 1xm} password for authentication with web request
        cPass = 'admin';
        
        
    end
    
    properties (Access = private)
        
        % {weboptions 1x1}
        options
        
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
        
        
        % @param {uint8 1x1} outlet (1 or 2)
        function turnOn(this, u8Outlet)
                      
            data = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', u8Outlet, ...
                'control', 1 ...
            );
                    
        end
        
        % @param {uint8 1x1} outlet (1 or 2)
        function turnOff(this, u8Outlet)
            
            data = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', u8Outlet, ...
                'control', 0 ...
            );
        end
        
        % @param {uint8 1x1} outlet (1 or 2)
        function reset(this, u8Outlet)
            
           data = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', u8Outlet, ...
                'control', 3 ...
            );
            
        end
        
        % @param {uint8 1x1} outlet (1 or 2)
        function l = isOn(this, u8Outlet)
            
            %{
            The manufacturer's team got back to me about this. They say the
            command you referred to is for “Control Outlet”. Therefore it
            is slower, as it will ‘control the outlet, and then return
            status”.

            If you only need to check status, look under “Get Status”. The
            command should be:

            http://admin:admin@IP/xml/outlet_status.xml?

            This response time is only around 0.005s.

            %}
            
            %{
            cXml = webread(...
                this.getUrl(), ...
                'user', this.cUser, ...
                'passwd', this.cPass, ...
                'target', '/xml/outlet_status.xml' ...
            );
            %}
        
            % Special URL that encodes HTTP basic auth username and
            % password in the URL
            
           
            
             %{
            cUrl = sprintf('http://%s:%s@%s/xml/outlet_status.xml?', ...
                this.cUser, ...
                this.cPass, ...
                this.cHost ...
            );             
            cXml = webread(cUrl);
             %}
            
            
             cUrl = sprintf('http://%s/xml/outlet_status.xml?', this.cHost);
             cXml = webread(cUrl, this.getWebOptions());
        
            [cMatch, ceTok] = regexp(cXml, ...
                '<outlet_status>([0-9,]+)<\/outlet_status>', ...
                'match', ...
                'tokens' ...
             );
         
            % ceTok{1}{1} formatted as num,num e.g., 0,1 or 0,0, or 1,1 
            % indicating the status of outlets one and two, respectively.
            
            ceStatus = strsplit(ceTok{1}{1}, ',');
            if u8Outlet == 1
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
        
        % Returns a weboptions object with HTTP Basic Auth credentials, 
        % which is required by the rquest to
        % http://IP/xml/outlet_status.xml
        % @return {weboptions 1x1}
        function options = getWebOptions(this)
            
            if ~isempty(this.options)
                options = this.options;
                return
            end
            
            options = weboptions;
            options.Username = this.cUser;
            options.Password = this.cPass;
            % options.ContentType = 'xml';
            options.RequestMethod = 'Get';
            
            
            
        end
        
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

