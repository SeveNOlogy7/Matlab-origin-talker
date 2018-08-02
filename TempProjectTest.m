clear
clc

%% Open currently running origin session
% opj = OriginProject.open() % test passed
opj = OriginProject.open([pwd,'\TempProjectTest.opj'])

% test save function
% opj.save()    % test passed
% opj.save([pwd,'\TempProjectTest.opj'])    % test passed

% get active page
graph1 = opj.gcp

% test workbook creation and closure
workbook1 = opj.createWorksheetPage('workbook1');
% set active page
opj.gcp(workbook1)
% close workbook
workbook1.close();

% get layer1 from graph1
gl = graph1.graphLayers(1);

% set label
gl.xlabel('test1','Bottom');
gl.xlabel('test2','Top');
gl.ylabel('test3','Left');
gl.ylabel('test3','Right');

% Test Variable & execute functions
gl.getExecuted('xb.fsize')
gl.getExecuted('xb.text','String')

% gl.executeOgs('C:\Dropbox (The University of Manchester)\Matlab-origin-talker\OgsScripts\PicAutoSize.ogs')
gl.executeOgs('C:\Dropbox (The University of Manchester)\Matlab-origin-talker\OgsScripts\PicAutoSize.ogs','Layer')
gl.executeOgs('C:\Dropbox (The University of Manchester)\Matlab-origin-talker\OgsScripts\PicAutoSize.ogs','Page')

clear