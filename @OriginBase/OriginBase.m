classdef OriginBase < handle
    %ORIGINBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        originObj
    end
    
    methods(Access = public)
        
        function val = get(obj,name) %#ok<INUSL>
            val = eval(['obj.',name]);
        end
        
        function obj = set(obj,name,val)
            eval(['obj.',name,' = ',char(string(val))]);
        end
        
        function val = getOriginAttribute(obj, attributeName)
            val = obj.originObj.invoke(attributeName);
        end
        
        function obj = setOriginAttribute(obj, attributeName, val)
            obj.originObj.invoke(attributeName, val);
        end
        
        function obj = setName(obj,name)
            obj.name = name;
            obj.originObj.invoke('Name', name);
        end
        
        function name = getName(obj)
            obj.name = obj.originObj.invoke('Name');
            name = obj.name;
        end
        
        function out = execute(obj,cmdString)
            % execute commands
            % TODO: add multiple cmdString support
            out = obj.originObj.invoke('Execute', cmdString);
        end
        
        function out = executeOgs(obj,scriptPath,sectionName)
            if nargin >= 2
                % simple reg expression check
                if regexpi(scriptPath,'.*\.ogs')>0
                    if nargin == 2
                        % if ogs file contains setion then a dialog will
                        % appear in origin and pause the excutation of this
                        % function
                        % TODO: scan ogs files to check if it is in section
                        % format or not and run sections one by one
                        out = obj.execute(['run ',scriptPath,';']);
                    elseif nargin ==3
                        out = obj.execute(['run.section(',scriptPath,', ',sectionName,');']);
                    end
                else
                    warning('Invalid ogs file path');
                end
            end
        end
        
    end
    
    methods (Abstract, Access = public)
        out = getExecuted(obj,cmdString,returnType);
    end
    
end

