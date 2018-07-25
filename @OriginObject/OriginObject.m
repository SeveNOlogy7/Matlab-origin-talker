classdef OriginObject < OriginBase
    %ORIGINOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function obj = OriginObject(varargin)
            if nargin == 0
                % OriginObject()
                obj.name = [];
                obj.originObj = [];
            else
                % OriginObject(originObj)
                % TODO: type check here
                originObj = varargin{1};
                obj.originObj = originObj;
                obj.name = obj.originObj.invoke('Name');
            end
        end
        
        function obj = activate(obj)
            obj.originObj.invoke('Activate');
        end
        
        function obj = close(obj)
            obj.originObj.invoke('Destroy');
        end
        
        function app = application(obj)
            app = OriginProject(obj.originObj.invoke('Application'));
        end
        
        function p = getParent(obj)
            p = OriginObject(obj.originObj.invoke('Parent'));
        end
        
        function out = getExecuted(obj,cmdString,returnType)
            % get return value from command like 'xb.fsize =;'
            % used as getExecuted(obj,'xb.fsize')
            if nargin == 2
                % getExecuted(obj,cmdString)
                % use default returnType
                returnType = 'Numeric';
            end
            % getExecuted(obj,cmdString,returnType)
            switch returnType
                case 'String'
                    obj.execute(['String temp_string$ = ',cmdString, +'$;']);
                    out = obj.application.LTStr('temp_string');
                case 'Numeric'
                    obj.execute(['double temp_numeric = ',cmdString, +';']);
                    out = obj.application.LTVar('temp_numeric');
                otherwise
            end
        end
    end
    
end
