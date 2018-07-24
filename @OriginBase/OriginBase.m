classdef OriginBase < handle
    %ORIGINBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        originObj
    end
    
    methods(Access = public)
        
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
        
        function out = execute(obj,cmdString)
            out = obj.originObj.invoke('Execute', cmdString);
        end
    end
    
end

