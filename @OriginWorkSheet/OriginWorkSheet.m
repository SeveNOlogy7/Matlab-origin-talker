classdef OriginWorkSheet < OriginObject
    %ORIGINWORKSHEET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        originObj
    end
    
    methods (Access = public)
        
        function obj = OriginWorkSheet(originObj)
            obj.originObj = originObj;
            obj.name = originObj.invoke('Name');
        end
        
        
    end
    
end

