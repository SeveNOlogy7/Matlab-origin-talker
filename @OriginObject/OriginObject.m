classdef OriginObject < handle
    %ORIGINOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        originObj
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
        
        function val = get(obj,name) %#ok<INUSL>
            val = eval(['obj.',name]);
        end
        
        function obj = set(obj,name,val)
            eval(['obj.',name,' = ',char(string(val))]);
        end
        
        function val = getOriginAttribute(obj, attributeName)
            val = obj.originObj.invoke(attributeName);
        end
        
        function obj = setOriginAttribute(obj, attributeName, val)
            obj.originObj.invoke(attributeName, val);
        end
        
        function obj = setName(obj,name)
            obj.name = name;
            obj.originObj.invoke('Name', name);
        end
        
        function name = getName(obj)
            obj.name = obj.originObj.invoke('Name');
            name = obj.name;
        end
    end
    
end
