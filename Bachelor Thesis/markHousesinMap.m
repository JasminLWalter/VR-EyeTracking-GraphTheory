%-----------------------markHousesinMap-------------
% written by Jasmin Walter




clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\'

% list which houses you want to plot

listToPlot = {'008_0','033_0','004_0'};

% load map

map = imread ('D:\BA Backup\Data_after_Script\Map, CoordinateList\Map_Houses_transparent.png');

% load house list with coordinates

listname = 'D:\BA Backup\Data_after_Script\Map, CoordinateList\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};

% get coordinates of listed objects

isOnList = ismember(coordinateList.House, listToPlot);

listCTable = coordinateList(isOnList,:);

x = listCTable.X;
y = listCTable.Y;

% display map
figure(1)
imshow(map);
hold on;

% mark houses


plotty = scatter(x,y,60,'b','filled');

dx = 20; 
dy = 20; % displacement so the text does not overlay the data points

text(x+dx, y+dy, listCTable.House,'Interpreter','none');

title({'location of houses in Seahaven'});

    

saveas(gcf,strcat(savepath,'map_occuringMaxHouses.png'),'png');
  
