classdef OriginObject < handle
    %ORIGINOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        originObj
    end
    
    methods
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
    end
    
end
