classdef OriginWorkSheetPage < OriginPage
    %ORIGINWORKSHEETPAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function obj = OriginWorkSheetPage(originObj)
            obj = obj@OriginPage(originObj);
        end
    
        function worksheet = worksheets(obj,index)
            if nargin == 1
                % worksheets(obj)
                layers = obj.getLayers;
                if ~isempty(layers)
                    for ii = 1:length(layers)
                        worksheet(ii) = OriginWorkSheet(layers(ii)); %#ok<AGROW>
                    end
                else
                    worksheet = [];
                end
            elseif nargin == 2
                % worksheets(obj,index)
                worksheets = obj.worksheets;
                worksheet = worksheets(index);
            end
        end
        
    end
    
end

