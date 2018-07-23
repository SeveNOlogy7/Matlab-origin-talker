classdef OriginLayer < OriginObject
    %ORIGINLAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function obj = OriginLayer(originObj)
            obj = obj@OriginObject(originObj);
        end
        
        function obj = execute(obj,cmdString)
            obj.originObj.invoke('Execute', cmdString);
        end
        
    end
    
end

