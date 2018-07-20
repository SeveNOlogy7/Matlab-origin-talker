classdef OriginProject < OriginObject
    %ORIGINFILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filepath
        isNew
        rootFolder
        workingDirectory
    end
    
    methods (Access = public, Static = true)
        
        function opj = open(filepath)
            [path,name,ext] = fileparts(filepath); %#ok<ASGLU>
            if isempty(path) || isempty(name)
                error('Invalid absolute filepath.')
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
            
            if exist(filepath, 'file') == 2 % if file exist
                invoke(opj.originObj, 'Load', opj.filepath); % load opj file
                opj.isNew = false;
            else
                opj.save;   % this create a new empty opj file
            end
            
            % Read data from opj file after loading opj file.
            opj.rootFolder = opj.root();
            opj.pwd(opj.rootFolder);   % set root folder as current working directory
            
        end
        
    end
    
    methods (Access = public)
        
        function delete(obj)
            obj.close();
            delete@OriginObject(obj);
        end
        
        function save(obj)
            invoke(obj.originObj, 'Execute', ['save ',obj.filepath]);
        end
        
        function close(obj)
            if ~isempty(obj.rootFolder)
                obj.rootFolder.delete
            end
            if ~isempty(obj.workingDirectory)
                obj.workingDirectory.delete
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
                    obj.workingDirectory = f;
                    obj.originObj.invoke('ActiveFolder',f.get('originObj'));
                else
                    error('Not a Origin Folder');
                end
            end
            if nargin == 1
                % pwd(obj)
                % always get origin Folder Object in case other references of
                % current_working_directory destroy originFolderObj outside
                % this fuction
                obj.workingDirectory.originObj = obj.originObj.invoke('ActiveFolder');
                out = obj.workingDirectory;
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

