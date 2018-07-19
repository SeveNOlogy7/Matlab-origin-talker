classdef OriginGraphPage < OriginPage
    %ORIGINGRAPH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        layerNum
    end
    
    methods (Access = public)
        
        function obj = OriginGraphPage(originObj)
            obj.originObj = originObj;
            obj.name = originObj.invoke('Name');
            obj.layerNum = originObj.invoke('Layers').invoke('Count');
        end
        
        function graphLayers = getLayers(obj)
            layers_temp = invoke(obj.originObj, 'Layers');
            if layers_temp.invoke('Count')>0
                for ii = 1:layers_temp.invoke('Count')
                    graphLayers(ii) = layers_temp.invoke('Item',uint8(ii-1)); %#ok<AGROW>
                end
            else
                graphLayers = [];
            end
        end
        
        function layerNum = getlayerNum(obj)
            obj.layerNum = obj.ooriginObj.invoke('Layers').invoke('Count');
            layerNum = obj.layerNum;
        end
        
    end
    
end
