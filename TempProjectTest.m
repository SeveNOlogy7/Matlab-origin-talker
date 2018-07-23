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

clear