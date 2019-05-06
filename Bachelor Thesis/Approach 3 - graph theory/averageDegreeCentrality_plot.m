%-----------------------averageDegreeCentrality_Plot-------------
% written by Jasmin Walter




clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\degreeCentrality\'


overviewNodeDegree = load('Overview_NodeDegree.mat');
overviewNodeDegree = overviewNodeDegree.overviewNodeDegree;

meanDegree = mean(overviewNodeDegree{:,2:end},2)';

% load map

map = imread ('D:\BA Backup\Data_after_Script\Map, CoordinateList\Map_Houses_transparent.png');

% load house list with coordinates

listname = 'D:\BA Backup\Data_after_Script\Map, CoordinateList\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};


% display map
        figure(1)
        imshow(map);
        hold on;
        
        % mark houses
        x = coordinateList{:,2};
        y = coordinateList{:,3};

 
        
        plotty = scatter(x,y,60,meanDegree,'filled');
        colormap jet
        colorbar
        
        title({strcat('average degree centrality values - all participants - on map'),'    '});
    

 saveas(gcf,strcat(savepath,'average degree centrality values - all participants - on map.png'),'png');
  
 
 %% create boxplots
 
 overviewDegreeNaN = overviewNodeDegree;
 
 % replace all 0 with NaN
 isZeros = overviewDegreeNaN{:,2:end}==0;
 
 for index = 2:width(overviewDegreeNaN);
     
    rowZeros = isZeros(:,index-1);
     overviewDegreeNaN{rowZeros,index} = NaN;
     
         
 end
     
 
 % create boxplots
 
 plotArray = overviewDegreeNaN{:,2:end}';
 figure(2)
 
boxxy = boxplot(plotArray);
ax = gca;
ax.XAxis.TickLabel = overviewDegreeNaN{:,1};
ax.XAxis.TickLabelInterpreter = 'none';
ax.XAxis.FontSize = 4;
ax.XAxis.TickLabelRotation = 90;

ax.XLabel.String = 'Nodes / Houses';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'Degrees';
ax.YLabel.FontSize = 12;
title({'degree centrality values all participants','     '});

% save it
saveas(gcf,strcat(savepath,'degreeCentrality_boxplot_allParticipants1.png'),'png');


% % plot boxplot style compact
 figure(3)
 
boxxy2 = boxplot(plotArray,'PlotStyle','compact');
ax = gca;
ax.XAxis.TickValues = 1:1:213;
ax.XAxis.TickLabel = overviewDegreeNaN{:,1};
ax.XAxis.TickLabelInterpreter = 'none';
ax.XAxis.FontSize = 4;
ax.XAxis.TickLabelRotation = 90;

ax.XLabel.String = 'Nodes / Houses';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'Degrees';
ax.YLabel.FontSize = 12;
title({'degree centrality values all participants','     '});

% save it
saveas(gcf,strcat(savepath,'degreeCentrality_boxplot_allParticipants_2compact.png'),'png');

 plotArray = overviewDegreeNaN{:,2:end}';
 figure(4)
 
boxxy4 = boxplot(plotArray,'MedianStyle','target');
ax = gca;
ax.XAxis.TickLabel = overviewDegreeNaN{:,1};
ax.XAxis.TickLabelInterpreter = 'none';
ax.XAxis.FontSize = 4;
ax.XAxis.TickLabelRotation = 90;

ax.XLabel.String = 'Nodes / Houses';
ax.XLabel.FontSize = 12;
ax.YLabel.String = 'Degrees';
ax.YLabel.FontSize = 12;
title({'degree centrality values all participants','     '});


% save it
saveas(gcf,strcat(savepath,'degreeCentrality_boxplot_allParticipants3.png'),'png');

