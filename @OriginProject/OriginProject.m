classdef OriginProject < OriginBase
    %ORIGINFILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filepath
        isNew
        rootFolder
        activeFolder
        activePage
    end
    
    methods (Access = public, Static = true)
        
        function opj = open(filepath)
            if nargin == 1
                %open(filepath)
                [path,name,ext] = fileparts(filepath); %#ok<ASGLU>
                if isempty(path) || isempty(name)
                    error('Invalid absolute filepath.')
                end
            elseif nargin == 0
                % Open(current origin instance or create a new project
                % in default location)
                filepath = [];
            end
            % filepath is valid
            opj = OriginProject();
            opj.filepath = filepath;
            opj.originObj = actxserver('Origin.ApplicationSI');
            opj.isNew = true;
            
            % Waiting for X-FUnction startup to be ready
            invoke(opj.originObj, 'Execute','sec -poc 3.5');
            
            % Make the Origin session visible
            invoke(opj.originObj, 'Execute', 'doc -mc 1;');
            
            % Clear "dirty" flag in Origin to suppress prompt
            % for saving current project
            invoke(opj.originObj, 'IsModified', 'false');
            
            if nargin == 1
                if exist(filepath, 'file') == 2 % if file exist
                    invoke(opj.originObj, 'Load', opj.filepath); % load opj file
                    opj.isNew = false;
                else
                    opj.save;   % this create a new empty opj file
                end
            end
            
            % Read data from opj file after loading opj file.
            opj.rootFolder = opj.root();
            opj.pwd(opj.rootFolder);   % set root folder as current working directory
            
            opj.name = opj.originObj.invoke('Name');
        end
        
    end
    
    methods (Access = public)
        
        function obj = OriginProject(originObj)
            if nargin == 0
            elseif nargin == 1
                % OriginProject(originObj)
                obj.originObj = originObj;
                obj.name = obj.originObj.invoke('Name');
                obj.isNew = false;
                obj.rootFolder = obj.root;
                obj.activeFolder = obj.pwd;
                obj.activePage = obj.gcp;
            end
        end
        
        function delete(obj)
            obj.close();
            delete@OriginBase(obj);
        end
        
        function save(obj,filepath)
            if nargin == 1
                % save(obj)
                % read filepath from object
                filepath = obj.filepath;
            end
            % save(obj,filepath)
            % check file path, TODO: more reg check
            if ~isempty(filepath)
                invoke(obj.originObj, 'Execute', ['save ',filepath]);
            else
                warning('Invalid filepath. Nothing saved.');
            end
        end
        
        function close(obj)
            if ~isempty(obj.rootFolder)
                obj.rootFolder.delete
            end
            if ~isempty(obj.activeFolder)
                obj.activeFolder.delete
            end
            if isa(obj.originObj,'COM.Origin_ApplicationSI')
                obj.originObj.release;
            end
        end
        
        function close_save(obj)
            obj.save;
            obj.close;
        end
        
        function out = pwd(obj,f)
            % set active folder
            % If passed with a OriginFolder object, set it as the active
            % folder in Origin
            % If no parameter passed, return the Origin active folder.  
            if nargin == 2
                % pwd(obj,f)
                if class(f) == 'OriginFolder'
                    f.activate
                    %                     obj.originObj.invoke('ActiveFolder',f.get('originObj'));
                    obj.activeFolder = f;
                    out = obj.activeFolder;
                else
                    error('Not a Origin Folder');
                end
            end
            if nargin == 1
                % pwd(obj)
                % always get origin Folder Object in case other references of
                % current_working_directory destroy originFolderObj outside
                % this fuction
                obj.activeFolder = OriginFolder(obj.originObj.invoke('ActiveFolder'));
                out = obj.activeFolder;
            end
        end
        
        function out = gcp(obj,p)
            % Get current page
            % If an OriginPage object is specified, set the page as active
            % page. If use with no parameters, return the current active
            % page.
            if nargin == 2
                % gcp(obj,p)
                if isa(p,'OriginPage')
                    p.activate;
                    out = obj.gcp;
                else
                    error('Not a Origin Page');
                end
            end
            if nargin == 1
                % gcp(obj)
                activePageObj = obj.originObj.invoke('ActivePage');
                if ~isempty(activePageObj)
                    page_temp = OriginPage(activePageObj);
                    switch(page_temp.getPageType)
                        case PAGETYPES.OPT_GRAPH
                            obj.activePage = OriginGraphPage(page_temp.get('originObj'));
                        case PAGETYPES.OPT_WORKSHEET
                            obj.activePage = OriginWorkSheetPage(page_temp.get('originObj'));
                        otherwise
                            obj.activePage = page_temp;
                    end
                    out = obj.activePage;
                else
                    out = [];
                end
                
            end
        end
        
        function f = root(obj)
            % Get root folder
            % return root folder as an OriginFolder object
            f = OriginFolder(obj.originObj.get('RootFolder'),0,true);
        end
        
        function f = cd(obj,varargin)
            % Change directory (active page)
            % the directory path string using path relative to rootfolder
            % but has no support like ..\ yet
            if nargin == 2
                if isa(varargin{1},'char')
                    % OriginFolder(obj,path)
                    % path is absolute (relative to root folder)
                    path = varargin{1};
                    f = obj.rootFolder;
                    f = f.cd(path);
                    obj.cd(f);
                elseif isa(varargin{1},'OriginFolder')
                    % OriginFolder(obj,f)
                    f = varargin{1};
                    obj.pwd(f);
                end
                if nargin == 3
                    
                end
            end
        end
        
        function strPage = createPage(obj,pageType,pageName,templateName)
            % Create a Page in Origin
            if nargin == 3
                % createPage(obj,pagetype,pagename)
                strPage = invoke(obj.originObj, 'CreatePage', uint32(pageType), pageName, 'Origin');
            elseif nargin == 4
                % createPage(obj,pagetype,pagename,templatename)
                strPage = invoke(obj.originObj, 'CreatePage', uint32(pageType), pageName, templateName);
            end
        end
        
        function worksheetPage = createWorksheetPage(obj,bookName,templateName)
            % Create a Worksheet Page in Origin
            if nargin == 2
                % createPage(obj,bookName)
                strBook = obj.createPage(PAGETYPES.OPT_WORKSHEET, bookName, 'Origin');
            elseif nargin == 3
                % createPage(obj,bookName,templateName)
                strBook = obj.createPage(PAGETYPES.OPT_WORKSHEET, bookName, templateName);
            end
            % find worksheetPage by name
            worksheetPages = obj.originObj.invoke('WorksheetPages');
            for ii = 1:worksheetPages.invoke('count')
                worksheetPageObj = worksheetPages.invoke('Item',uint8(ii-1));
                if strcmp(worksheetPageObj.invoke('Name'),strBook)
                    worksheetPage = OriginWorkSheetPage(worksheetPageObj);
                    return
                end
            end
        end
        
        function graphPage = createGraphPage(obj,graphName, templateName)
            % Create a Graph Page in Origin
            if nargin == 2
                % createPage(obj,bookName)
                strGraph = obj.createPage(PAGETYPES.OPT_GRAPH, graphName, 'Origin');
            elseif nargin == 3
                % createPage(obj,bookName,templateName)
                strGraph = obj.createPage(PAGETYPES.OPT_GRAPH, graphName, templateName);
            end
            % find graphPage by name
            graphPages = obj.originObj.invoke('GraphPages');
            for ii = 1:graphPages.invoke('count')
                graphPageObj = graphPages.invoke('Item',uint8(ii-1));
                if strcmp(graphPageObj.invoke('Name'),strGraph)
                    graphPage = OriginGraphPage(graphPageObj);
                    return
                end
            end
        end
        
        function stringValue = LTStr(obj,name,value)
            % LabTalk Str variable interaction
            % If pass a LTStr variable name, return the value of the variable
            % If pass name value pair, set the LTStr variable accordingly
            % with the value
            if nargin == 2
                % LTStr(obj,name)
                stringValue = obj.originObj.invoke('LTStr',[name,'$']);
            elseif nargin == 3
                % LTStr(obj,name,value)
                stringValue = obj.originObj.invoke('LTStr',[name,'$'],value);
            end
        end
        
        function numericValue = LTVar(obj,name,value)
            % LabTalk numeric variable interaction
            % If pass a LT variable name, return the value of the variable
            % If pass name value pair, set the LT variable accordingly
            % with the value
            if nargin == 2
                % LTVar(obj,name)
                numericValue = obj.originObj.invoke('LTVar',name);
            elseif nargin == 3
                % LTVar(obj,name,value)
                numericValue = obj.originObj.invoke('LTVar',name,value);
            end
        end
        
        function flag = newLTStr(obj,name,value)
            % Create a LabTalk String variable and set the value
            obj.execute(['String ',name,'$ = ',value]);
            flag = strcmp(value,obj.LTStr(name));
        end
        
        function flag = newLTVar(obj,name,value)
            % Create a LabTalk numeric variable and set the value
            obj.execute(['double ',name,' = ',num2str(value)]);
            flag = abs(value - obj.LTVar(name))<1e-5;
        end
        
        function out = getExecuted(obj,cmdString,returnType)
            % get return value from command like 'xb.fsize =;'
            % used as getExecuted(obj,'xb.fsize')
            % Noticed that this fuction are currently the same as the one
            % in OriginObject, however, the OriginObject.getExecuted is to
            % execute command in the context of that specific Origin Object
            % (Page, layer, etc...)
            if nargin == 2
                % getExecuted(obj,cmdString)
                % use default returnType
                returnType = 'Numeric';
            end
            % getExecuted(obj,cmdString,returnType)
            switch returnType
                case 'String'
                    obj.execute(['String temp_string$ = ',cmdString, +'$;']);
                    out = obj.LTStr('temp_string');
                case 'Numeric'
                    obj.execute(['double temp_numeric = ',cmdString, +';']);
                    out = obj.LTVar('temp_numeric');
                otherwise
            end
        end
        
    end
end

