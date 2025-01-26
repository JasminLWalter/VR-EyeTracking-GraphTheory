%% ------------------ comp_graph_measures_C.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath40 = 'F:\Cyprus_project_overview\data\comparison2VR\40min\graphMeasuresHA\';
savepath10 = 'F:\Cyprus_project_overview\data\comparison2VR\10min\graphMeasuresHA\';


cd 'F:\Cyprus_project_overview\data\comparison2VR\40min\graphs_HA\';


PartList = {365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7264 7412 7842 8007 8469 8673 9472 9502 9586 9601};

saveAll = true;

% load overviews
overview40 = readtable(strcat(savepath40, 'overviewGraphMeasures.csv'));
overview10 = readtable(strcat(savepath10, 'overviewGraphMeasures.csv'));

overviewRW = table;


%load graph limassol
file = "F:\Cyprus_project_overview\data\graphs\graph_limassol.mat";
graphy = load(file);
graphy= graphy.graphy;

% calculate graph measures
nrNodes = height(graphy.Nodes);
nrEdges = height(graphy.Edges);
maxEdges = (nrNodes * (nrNodes -1)) / 2;
density = height(graphy.Edges) / maxEdges;

% get diameter
distanceM = distances(graphy);
checkInf = isinf(distanceM);
distanceM(checkInf) = 0;
diameter = max(max(distanceM));
avgShortestPath = mean(distanceM, "all");


% add data to overview

index = 1;

overviewRW.nrViewedHouses(index) = nrNodes;
overviewRW.nrEdges(index) = nrEdges;
overviewRW.density(index) = density;
overviewRW.diameter(index) = diameter;
overviewRW.avgShortestPath(index) = avgShortestPath;

%% do the plotting

overview = overview40;

figure(1)
plotty = boxchart(overview.nrViewedHouses);
xlabel('participants');
ylabel('# viewed buildings');
title({'Graph - number viewed buildings', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW.nrViewedHouses,overviewRW.nrViewedHouses]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath40, 'nr_ViewedBuildings.png'),'Resolution',600)
end


% 
column = 3;
column2 = column-1;
figure(2)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('# edges');
title({'Graph - number edges', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath40, 'nr_edges.png'),'Resolution',600)
end

%% 
column = 4;
column2 = column-1;
figure(3)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('density');
title({'Graph - density', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath40, 'density.png'),'Resolution',600)
end



%% 
column = 5;
column2 = column-1;
figure(4)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('diameter');
title({'Graph - diameter', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath40, 'diameter.png'),'Resolution',600)
end


%%

column = 6;
column2 = column-1;
figure(5)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('avg shortest path');
title({'Graph - avg shortest path', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath40, 'avgShortestPath.png'),'Resolution',600)
end



overview = overview10;

figure(1)
plotty = boxchart(overview.nrViewedHouses);
xlabel('participants');
ylabel('# viewed buildings');
title({'Graph - number viewed buildings', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW.nrViewedHouses,overviewRW.nrViewedHouses]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath10, 'nr_ViewedBuildings.png'),'Resolution',600)
end


% 
column = 3;
column2 = column-1;
figure(2)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('# edges');
title({'Graph - number edges', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath10, 'nr_edges.png'),'Resolution',600)
end

%% 
column = 4;
column2 = column-1;
figure(3)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('density');
title({'Graph - density', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath10, 'density.png'),'Resolution',600)
end



%% 
column = 5;
column2 = column-1;
figure(4)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('diameter');
title({'Graph - diameter', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath10, 'diameter.png'),'Resolution',600)
end


%%

column = 6;
column2 = column-1;
figure(5)
plotty = boxchart(overview{:,column});
xlabel('participants');
ylabel('avg shortest path');
title({'Graph - avg shortest path', ' '});
% 
hold on
plot([0.5, 1.5], [overviewRW{:,column2},overviewRW{:,column2}]);
hold off


ax = gca;
if saveAll       
    exportgraphics(ax,strcat(savepath10, 'avgShortestPath.png'),'Resolution',600)
end