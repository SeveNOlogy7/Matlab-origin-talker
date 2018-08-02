classdef OriginWorkSheet < OriginLayer
    %ORIGINWORKSHEET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        colNum
    end
    
    methods (Access = public)
        
        function obj = OriginWorkSheet(originObj)
            obj = obj@OriginLayer(originObj);
            obj.colNum = originObj.invoke('Cols');
        end
        
        function data = getData(obj, dataFormat, nRowStart, nColStart, nRowEnd, nColEnd)
            if nargin == 2
                % getData(obj,dataFormat) get all data
                data = obj.originObj.invoke('GetData', 0, 0, -1, -1,...
                    uint32(dataFormat));
            elseif nargin == 4
                % getData(obj, dataFormat, nRowStart, nColStart) get data
                % with offset
                data = obj.originObj.invoke('GetData', nRowStart, ...
                    nRowStart, -1, -1, uint32(dataFormat));
            elseif nargin == 6
                % getData(obj, dataFormat, nRowStart, nColStart, nRowEnd, nColEnd)
                data = obj.originObj.invoke('GetData', nRowStart, ...
                    nColStart, nRowEnd, nColEnd, uint32(dataFormat));
            end
        end
        
        function obj = setData(obj,data,nRowOffset,nColOffset)
            dataColNum = size(data,2);
            if nargin == 2
                % setData(obj,data)
                if dataColNum > obj.getColNum
                    obj.setColNum(dataColNum);
                end
                obj.originObj.invoke('SetData', data, 0, 0);
            elseif nargin == 4
                % setData(obj,data,offsetX,offsetY)
                if dataColNum + nColOffset > obj.getColNum
                    obj.setColNum(dataColNum + nColOffset);
                end
                obj.originObj.invoke('SetData', data, nRowOffset, nColOffset);
            end
        end
        
        function obj = setColNum(obj,colNum)
            obj.colNum = colNum;
            obj.originObj.invoke('Cols',colNum);
        end
        
        function colNum = getColNum(obj)
            obj.colNum = obj.originObj.invoke('Cols');
            colNum = obj.colNum;
        end
        
        function cols = getColumns(obj)
            cols_temp = invoke(obj.originObj, 'Columns');
            if obj.getColNum>0
                for ii = 1:obj.getColNum
                    cols(ii) = cols_temp.invoke('Item',uint8(ii-1)); %#ok<AGROW>
                end
            else
                cols = [];
            end
        end
        
        function colTypes = getColTypes(obj)
            colTypes = COLTYPES(cell2mat(obj.getColAttributes('Type')));
        end
        
        function obj = setColTypes(obj, colTypes)
            obj.setColAttributes('Type',num2cell(uint32(colTypes)));
        end
        
        function longNames = getColLongNames(obj)
            longNames = obj.getColAttributes('LongName');
        end
        
        function obj = setColLongNames(obj, longNames)
            obj.setColAttributes('LongName',longNames);
        end
        
        function Comments = getColComments(obj)
            Comments = obj.getColAttributes('Comments');
        end
        
        function obj = setColComments(obj, Comments)
            obj.setColAttributes('Comments',Comments);
        end
        
        function Units = getColUnits(obj)
            Units = obj.getColAttributes('Units');
        end
        
        function obj = setColUnits(obj, Units)
            obj.setColAttributes('Units',Units);
        end
        
        function p = getParent(obj)
            p = OriginWorkSheetPage(obj.originObj.invoke('Parent'));
        end
        
    end
    
    methods (Access = private)
        
        function colAttributes = getColAttributes(obj,attributeName)
            cols = obj.getColumns;
            if ~isempty(cols)
                for ii = 1:length(cols)
                    colAttributes{ii} = cols(ii).invoke(attributeName); %#ok<AGROW>
                end
            else
                colAttributes = {};
            end
        end
        
        function obj = setColAttributes(obj, attributeName, values)
            cols = obj.getColumns;
            for ii = 1:length(cols)
                if ii <= length(values)
                    cols(ii).invoke(attributeName,values{ii});
                end
            end
        end
        
    end
end
