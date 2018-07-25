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
    end
    
end
