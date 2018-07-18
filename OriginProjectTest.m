clear
clc
opj = OriginProject.open('C:\Dropbox (The University of Manchester)\Matlab-origin-talker\OriginProjectTest.opj')

% opj.get('isNew')
% opj.get('filepath')
% opj.set('isNew',true)

%% Folder functions
% get root folder
rf = opj.get('rootFolder');

% create new folders
% af = rf.mkdir('new folder').mkdir('new folder 2').mkdir('new folder3');
af = rf.mkdir('new folder\new folder 2\new folder3');
folderpath = af.toPath;
% test relative cd of Folder object
cdf = rf.cd(folderpath);
% list subfolder
[sf,ps]=rf.ls();

% print working directory
opj.pwd.toPath

% change working directory
opj.cd(folderpath);

% print working directory
opj.pwd.toPath

opj.cd(rf);
opj.pwd.toPath
% createpage in active directory (pwd)
worksheet1 = opj.createWorksheet('test');

opj.cd(folderpath);
opj.pwd.toPath

% createpage in active directory (pwd)
worksheet2 = opj.createWorksheet('test');

% Test cd error
try
    cdf = rf.cd('test');
catch e
    if strcmp(e.identifier,'OriginFolder:pathNotFound')
        warning('path not found error')
    end
end

%% Worksheet functions
colNum = worksheet1.getColNum
columns = worksheet1.getColumns;
size(columns)

colNum = colNum+2
worksheet1.setColNum(colNum);
columns = worksheet1.getColumns;
size(columns)

colTypes = worksheet1.getColTypes
colTypes = worksheet1.setColTypes([3,0,3,0]).getColTypes

% generate data
X = (1:1:100)'/180*pi;
worksheet1.setData([X,sin(X)]);
worksheet1.setData([X,cos(X)],0,2);

% get data
data = worksheet1.getData(ARRAYDATAFORMAT.ARRAY2D_NUMERIC);

% set and get LongName
LongName = worksheet1.setColLongNames({'a','b','c','d'}).getColLongNames
% 
% opj.close;
% clear