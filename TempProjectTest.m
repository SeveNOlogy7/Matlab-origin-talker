clear
clc

%% Open currently running origin session
opj = OriginProject.open()

% get active page
opj.gcp

% create new workbook
workbook1 = opj.createWorksheetPage('workbook1');
% set active page
opj.gcp(workbook1)

% test save function
opj.save()
opj.save([pwd,'\TempProjectTest.opj'])

clear