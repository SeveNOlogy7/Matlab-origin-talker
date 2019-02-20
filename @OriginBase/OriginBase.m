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
        
        function out = execute(obj,cmdString,vargin)
            % Execute commands in Origin context
            if nargin == 2
                % obj.execute(cmdString)
                if isa(cmdString,'char')
                    % Execute a single command string
                    out = obj.originObj.invoke('Execute', cmdString);
                elseif isa(cmdString,'cell')
                    % Execute command strings in a cell array (vectors, not matrice)
                    if size(cmdString,1)==1 || size(cmdString,2)==1
                        for ii = 1:length(cmdString)
                            out = obj.originObj.invoke('Execute', cmdString{ii});
                            if out == 0
                                warning(['Execution terminated at line ',num2str(ii)]);
                                return
                            end
                        end
                    else
                        warning('Expecting 1-by-x or x-by-1 array.');
                        out = 0;
                        return
                    end
                end
            elseif nargin > 2
                % obj.execute(cmdString1,cmdString2,cmdString3...)
                % Execute multiple command strings
                vargin = {cmdString,vargin};
                obj.execute(vargin);
            end
        end
        
        function out = executeOgs(obj,scriptPath,sectionName)
            % Execute the Origin Script .ogs file
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

