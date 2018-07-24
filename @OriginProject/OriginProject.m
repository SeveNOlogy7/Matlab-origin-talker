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
                obj.activeFolder.originObj = obj.originObj.invoke('ActiveFolder');
                out = obj.activeFolder;
            end
        end
        
        function out = gcp(obj,p)
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
            f = OriginFolder(obj.originObj.get('RootFolder'),0,true);
        end
        
        function f = cd(obj,varargin)
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
            if nargin == 3
                % createPage(obj,pagetype,pagename)
                strPage = invoke(obj.originObj, 'CreatePage', uint32(pageType), pageName, 'Origin');
            elseif nargin == 4
                % createPage(obj,pagetype,pagename,templatename)
                strPage = invoke(obj.originObj, 'CreatePage', uint32(pageType), pageName, templateName);
            end
        end
        
        function worksheetPage = createWorksheetPage(obj,bookName,templateName)
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
        
    end
end

