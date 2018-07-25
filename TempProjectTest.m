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
gl.xlabel('test1','bottom');
gl.xlabel('test2','top');
gl.ylabel('test3','left');
gl.ylabel('test3','right');

clear