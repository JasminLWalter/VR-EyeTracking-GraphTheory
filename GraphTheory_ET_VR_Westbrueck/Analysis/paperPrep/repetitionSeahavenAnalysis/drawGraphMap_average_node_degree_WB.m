%% ------------------- plot_average_node_degree_graph.m-------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Visualizes average node-degree centrality on the city map and identifies landmarks.
%          Plots per-building mean node degree as a colored scatter over the map, a histogram of means,
%          highlights buildings above mean+2*std threshold (landmarks) on the map, and makes boxplots.
%
% Usage:
% - Adjust: savepath, imagepath, clistpath, and input folder (cd).
% - Run the script in MATLAB.
%
% Inputs:
% - Overview_NodeDegree.mat (variable: overviewNodeDegree; table with houseNames and Part_<ID> columns)
% - additional_Files/building_collider_list.csv (building names and map coordinates)
% - additional_Files/map_natural_white_flipped.png (background map image)
%
% Outputs (to savepath):
% - GraphVisualization_averageNodeDegree.fig/.png
% - Histogram_distribution_meanNodeDegree_of_each_building.fig/.png
% - GraphVisualization_landmarks_withNames.fig/.png
% - GraphVisualization_landmarks.fig/.png
% - Boxplot_landmarks.fig/.png
% - list_gaze_graph_defined_landmarks.mat (table: landmarks)
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE

clear all;

%% adjust the following variables: savepath and current folder!-----------

savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\graph-theoretical-analysis\nodeDegreeCentrality\';

imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location


cd 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\graph-theoretical-analysis\nodeDegreeCentrality\'

%--------------------------------------------------------------------------

overviewDegree= load('Overview_NodeDegree.mat');

overviewDegree= overviewDegree.overviewNodeDegree;
%% calculate mean over houses and sort table according to ascending mean ND of each house

meanNDofHouses = mean(overviewDegree{:,2:end},2);

overviewDegree.meanOfHouses = meanNDofHouses;




% can be also adjusted to change the color map for the node degree
% visualization
nodecolor = parula; % colormap parula

%--------------------------------------------------------------------------




% load map

map = imread (strcat(imagepath,'map_natural_white_flipped.png'));

% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);

minND = min(meanNDofHouses);
maxND = max(meanNDofHouses);

 % display map
figure(1)
imshow(map);
alpha(0.2)
hold on;

markerND = meanNDofHouses;

% plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,meanNDofHouses*2 +16,meanNDofHouses,'filled');
plotty = scatter(houseList.transformed_collidercenter_x, houseList.transformed_collidercenter_y,meanNDofHouses*1.2+13,meanNDofHouses,'filled');

colorbar
set(gca,'xdir','normal','ydir','normal')

climits = caxis;

saveas(gcf,strcat(savepath,'GraphVisualization_averageNodeDegree'));
ax = gca;
exportgraphics(ax,strcat(savepath,'GraphVisualization_averageNodeDegree_600dpi.png'),'Resolution',600)

% plot Histogram as well
figure(2)

histy = histogram(meanNDofHouses);
title('Mean node degree of all participants')
xlabel('mean node degree centrality')
ylabel('frequency')

saveas(gcf,strcat(savepath,'Histogram_distribution_meanNodeDegree_of_each_building'));
ax = gca;
exportgraphics(ax,strcat(savepath,'Histogram_distribution_meanNodeDegree_of_each_building_600dpi.png'),'Resolution',600)


meanMean = mean(meanNDofHouses);
stdMean = std(meanNDofHouses);
disp({'Mean of mean node degree of houses: ', num2str(meanMean)});

disp({'Std of mean node degree of houses: ', num2str(stdMean)});

%% plot the landmarks on map and boxplots

threshold = meanMean + 2*stdMean;

landmarkIndex = overviewDegree.meanOfHouses>threshold;
landmarks = overviewDegree(landmarkIndex,:);
save([savepath 'list_gaze_graph_defined_landmarks.mat'],'landmarks');

figure(3)
imshow(map);
alpha(0.2)
hold on;


node = ismember(houseList.target_collider_name,landmarks.houseNames);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);
plotty = scatter(x, y,overviewDegree.meanOfHouses(landmarkIndex)*1.2+23,overviewDegree.meanOfHouses(landmarkIndex),'filled');

txt = landmarks.houseNames;
% txt = strcat('\leftarrow',landmarks.houseNames);
text(x+100,y,txt,'Interpreter', 'none')

caxis(climits);
colorbar
set(gca,'xdir','normal','ydir','normal')


saveas(gcf,strcat(savepath,'GraphVisualizion_landmarks_withNames'));
ax = gca;
exportgraphics(ax,strcat(savepath,'GraphVisualization_landmarks_withNames_600dpi.png'),'Resolution',600)

%-----------------------

figure(4)
imshow(map);
alpha(0.2)
hold on;


node = ismember(houseList.target_collider_name,landmarks.houseNames);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);
plotty = scatter(x, y,overviewDegree.meanOfHouses(landmarkIndex)*1.2+23,overviewDegree.meanOfHouses(landmarkIndex),'filled');

% text(x+100,y,landmarks.houseNames,'Interpreter', 'none')

caxis(climits);
colorbar
set(gca,'xdir','normal','ydir','normal')


saveas(gcf,strcat(savepath,'GraphVisualizion_landmarks'));
ax = gca;
exportgraphics(ax,strcat(savepath,'GraphVisualization_landmarks_600dpi.png'),'Resolution',600)


%% ----------------boxplot

landmarks_sorted = sortrows(landmarks,'meanOfHouses','ascend');

landmarks_inv = landmarks_sorted{:,2:27}';
landmarkNames = landmarks_sorted{:,1}';
landmarkMeans = landmarks_sorted{:,28}';

figure(5) 

plotty5 = boxchart(landmarks_inv);
% plotty5.JitterOutliers = 'on';
% plotty5.MarkerStyle = '.';
hold on

plot(landmarkMeans, '-o')

title('landmark node degree stats')
xlabel('landmarks');
ylabel('node degree')

set(gca,'TickLabelInterpreter','none');
set(gca,'XTickLabel',landmarkNames);

legend({'boxplot + median','mean'},'location','northeastoutside')

saveas(gcf,strcat(savepath,'Boxplot_landmarks'));
ax = gca;
exportgraphics(ax,strcat(savepath,'Boxplot_landmarks_600dpi.png'),'Resolution',600)
hold off



