classdef OriginObject < handle
    %ORIGINOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function val = get(obj,name) %#ok<INUSL>
            val = eval(['obj.',name]);
        end
        
        function set(obj,name,val) %#ok<INUSL>
            eval(['obj.',name,' = ',char(string(val))]);
        end
    end
    
end

