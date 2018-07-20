classdef OriginGraphPage < OriginPage
    %ORIGINGRAPH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function obj = OriginGraphPage(originObj)
            obj = obj@OriginPage(originObj);
        end
            
        function graphLayer = graphLayers(obj,index)         
            if nargin == 1
                % graphLayers(obj)
                layers = obj.getLayers;
                if ~isempty(layers)
                    for ii = 1:length(layers)
                        graphLayer(ii) = OriginGraphLayer(layers(ii)); %#ok<AGROW>
                    end
                else
                    graphLayer = [];
                end
            elseif nargin == 2
                % graphLayers(obj,index)
                graphLayers = obj.graphLayers;
                graphLayer = graphLayers(index);         
            end
        end
        
    end
    
end
