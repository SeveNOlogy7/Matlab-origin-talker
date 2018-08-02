classdef OriginGraphLayer < OriginLayer
    %ORIGINGRAPHLAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function obj = OriginGraphLayer(originObj)
            obj = obj@OriginLayer(originObj);
        end
        
        function p = getParent(obj)
            p = OriginGraphPage(obj.originObj.invoke('Parent'));
        end
        
        function obj = rescale(obj)
            obj.execute('rescale;');
        end
        
        function obj = xlabel(obj,text,pos)
            switch nargin
                case 1
                    % obj = xlabel(obj)
                    % clear all xlabel
                    obj.execute('label -xb;');
                    obj.execute('label -xt;');
                case 2
                    % obj = xlabel(obj,text)
                    % set xlabel text in default position
                    obj.execute(['label -xb "',text,'";']);
                case 3
                    % obj = xlabel(obj,text,pos)
                    switch pos
                        case 'Bottom'
                            obj.execute(['label -xb "',text,'";']);
                        case 'Top'
                            obj.execute(['label -xt "',text,'";']);
                        otherwise
                            warning('Invalid position, should be ''Bottom'' or ''Top''.')
                    end
                otherwise
                    warning('Invalid parameters.')
            end
        end
        
        function obj = ylabel(obj,text,pos)
            switch nargin
                case 1
                    % obj = ylabel(obj)
                    % clear all ylabel
                    obj.execute('label -yl;');
                    obj.execute('label -yr;');
                case 2
                    % obj = ylabel(obj,text)
                    % set ylabel text in default position
                    obj.execute(['label -yl "',text,'";']);
                case 3
                    % obj = ylabel(obj,text,pos)
                    switch pos
                        case 'Left'
                            obj.execute(['label -yl "',text,'";']);
                        case 'Right'
                            obj.execute(['label -yr "',text,'";']);
                        otherwise
                            warning('Invalid position, should be ''Left'' or ''Right''.')
                    end
                otherwise
                    warning('Invalid parameters.')
            end
        end
        
        function obj = zlabel(obj,text,pos)
            switch nargin
                case 1
                    % obj = zlabel(obj)
                    % clear all ylabel
                    obj.execute('label -zb;');
                    obj.execute('label -zf;');
                case 2
                    % obj = zlabel(obj,text)
                    % set zlabel text in default position
                    obj.execute(['label -zb "',text,'";']);
                case 3
                    % obj = zlabel(obj,text,pos)
                    switch pos
                        case 'Back'
                            obj.execute(['label -zb "',text,'";']);
                        case 'Front'
                            obj.execute(['label -zf "',text,'";']);
                        otherwise
                            warning('Invalid position, should be ''Back'' or ''Front''.')
                    end
                otherwise
                    warning('Invalid parameters.')
            end
        end
    end
    
end

