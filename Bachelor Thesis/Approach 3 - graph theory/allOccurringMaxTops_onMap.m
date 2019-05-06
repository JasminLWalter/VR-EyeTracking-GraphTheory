%--------------------allOccurringMaxTops_onMap-------------
% written by Jasmin Walter




clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\'

% list which houses you want to plot

sumFixNr = load('sumFixNr.mat');
sumFixNr = sumFixNr.sumFixNr;

sumFixDur = load('sumFixDur.mat');
sumFixDur = sumFixDur.sumFixDur;

sumDegree = load('sumDegree.mat');
sumDegree = sumDegree.sumDegree;

sumAll = table;
sumAll.Houses = sumFixNr.Houses;
sumAll.FixNr = sumFixNr.Occurence;
sumAll.FixDur = sumFixDur.Occurence;
sumAll.Degree = sumDegree.Occurence;


sumAll.All = sum(sumAll{:,2:end},2);

%listToPlot = {'008_0','033_0','004_0'};

% load map

map = imread ('D:\BA Backup\Data_after_Script\Map, CoordinateList\Map_Houses_transparent.png');

% load house list with coordinates

listname = 'D:\BA Backup\Data_after_Script\Map, CoordinateList\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};

% get coordinates of listed objects

isOnList = ismember(coordinateList.House, sumAll.Houses);

listCTable = coordinateList(isOnList,:);

x = listCTable.X;
y = listCTable.Y;

% display map
figure(1)
imshow(map);
hold on;

% mark houses


plotty = scatter(x,y,60,sumAll.All,'filled');

colormap jet
colorbar


dx = 20; 
dy = 20; % displacement so the text does not overlay the data points
text(x+dx, y+dy, listCTable.House,'Interpreter','none');


title({'number of occurence of houses as maximal element',' all 3 categories accumulated '});
    

saveas(gcf,strcat(savepath,'map_occuringMaxHouses.png'),'png');
  
%plot as pie

pieTable = sortrows(sumAll,5,'descend');

sumAll = sum(pieTable.All);

pieTable.Perc = pieTable.All / sumAll;

pieTable3 = head(pieTable,3);


figure(2)
pieplot = pie(pieTable3.Perc,pieTable3.Houses);
title({'distribution of occurences - maximum element houses ','   '});
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


