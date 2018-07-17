function [ strGraph, strBook] = Oplot(X,Ys)

%OPLOT Summary of this function goes here
%   Detailed explanation goes here
% Obtain Origin COM Server object
% Connect to an existing instance of Origin
% or create a new one if none exists

opj = OriginProject.open('C:\Dropbox (The University of Manchester)\Matlab-origin-talker\OriginProjectTest.opj');

originObj = opj.get('originObj');

% Create a workbook
strBook = invoke(originObj, 'CreatePage', 2, 'test', 'Origin');

% Find the worksheet
wks = invoke(originObj, 'FindWorksheet', strBook);

% Rename the worksheet to "MySheet"
invoke(wks, 'Name', 'MySheet');

% Set columns numbers
invoke(wks, 'Cols', 1+size(Ys,2));

% Get column collection in the worksheet
cols = invoke(wks, 'Columns');

% Get x column
colx = invoke(cols, 'Item', uint8(0));
% Set x column type
invoke(colx, 'Type', 3);  % x column

for ii = 1:size(Ys,2)
    % Get y columns
    coly = invoke(cols, 'Item', uint8(ii));
    % Set y column type
    invoke(coly, 'Type', 0);  % y column
end

% Set data to the columns
invoke(wks, 'SetData', [X,Ys], 0, 0);

% Create a graph
strGraph = invoke(originObj, 'CreatePage', 3, '', 'Origin');
invoke(wks, 'Execute', ['plotxy iy:=(1,2:end) plot:=202 ogl:=[',strGraph,']1!;']);

% Find the graph layer
gl = invoke(originObj, 'FindGraphLayer', strGraph);

% Rescale the graph layer
invoke(gl, 'Execute', 'rescale;');

% Change the bottom x' title
invoke(gl, 'Execute', 'xb.text$ = "Channel";');
% Change the left y's title
invoke(gl, 'Execute', 'yl.text$ = "Amplitude";');

%show the top and right axes
invoke(gl, 'Execute', 'range ll = !;');
invoke(gl, 'Execute', 'll.x2.showAxes=3;');
invoke(gl, 'Execute', 'll.y2.showAxes=3;');

%set the x axis scale
invoke(gl, 'Execute', 'll.x.from=0;');
invoke(gl, 'Execute', 'll.x.to=3;');

%set the x axis Major tick increment.
invoke(gl, 'Execute', 'll.x.inc=10;');

%delete the legend
invoke(gl, 'Execute', 'label -r legend;');

opj.close_save();

end

