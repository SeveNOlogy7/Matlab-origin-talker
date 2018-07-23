classdef OriginGraphLayer < OriginLayer
    %ORIGINGRAPHLAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function obj = OriginGraphLayer(originObj)
            obj = obj@OriginLayer(originObj);
        end
        
        function obj = rescale(obj)
            obj.execute('rescale;');
        end
        
        function obj = xlabel(obj,text,pos)
            switch nargin
                case 1
                    % obj = xlabel(obj)
                    % clear all xlabel
                    obj.execute('xb.text$ = "";');
                    obj.execute('xt.text$ = "";');
                case 2
                    % obj = xlabel(obj,text)
                    % set xlabel text in default position
                    obj.execute(['xb.text$ = "',text,'";']);
                case 3
                    % obj = xlabel(obj,text,pos)
                    % TODO: if label is not shown, then text is not set even
                    % execute these commands
                    switch pos
                        case 'bottom'
                            obj.execute(['xb.text$ = "',text,'";']);
                        case 'top'
                            obj.execute(['xt.text$ = "',text,'";']);
                        otherwise
                            warning('Invalid position, should be bottom or top.')
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
                    obj.execute('yl.text$ = "";');
                    obj.execute('yr.text$ = "";');
                case 2
                    % obj = ylabel(obj,text)
                    % set ylabel text in default position
                    % TODO: if label is not shown, then text is not set even
                    % execute these commands
                    obj.execute(['yl.text$ = "',text,'";']);
                case 3
                    % obj = ylabel(obj,text,pos)
                    switch pos
                        case 'left'
                            obj.execute(['yl.text$ = "',text,'";']);
                        case 'right'
                            obj.execute(['yr.text$ = "',text,'";']);
                        otherwise
                            warning('Invalid position, should be left or right.')
                    end
                otherwise
                    warning('Invalid parameters.')
            end
        end
    end
    
end

