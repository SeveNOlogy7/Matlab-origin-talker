classdef OriginPage < OriginObject
    %ORIGINPAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        layerNum
        pageType
    end
    
    methods (Access = public)
        
        function obj = OriginPage(originObj)
            obj = obj@OriginObject(originObj);
            obj.layerNum = originObj.invoke('Layers').invoke('Count');
            obj.pageType = PAGETYPES(obj.originObj.invoke('Type'));
        end
        
        function Layers = getLayers(obj)
            layers_temp = invoke(obj.originObj, 'Layers');
            if layers_temp.invoke('Count')>0
                for ii = 1:layers_temp.invoke('Count')
                    Layers(ii) = layers_temp.invoke('Item',uint8(ii-1)); %#ok<AGROW>
                end
            else
                Layers = [];
            end
        end
        
        function layerNum = getLayerNum(obj)
            obj.layerNum = obj.originObj.invoke('Layers').invoke('Count');
            layerNum = obj.layerNum;
        end
        
        function pageType = getPageType(obj)
            obj.pageType = PAGETYPES(obj.originObj.invoke('Type'));
            pageType = obj.pageType;
        end
        
        function obj = execute(obj,cmdString)
            obj.originObj.invoke('Execute', cmdString);
        end
    end
    
end

