%% ------------------- node_degree_centrality_analysis.m-------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% Creates an image scale (pseudo 3D plot) color coding the node degree 
% centrality values for every house and every participant (Fig. 5c). Also 
% creates corresponding box plots with error bars: the individual mean node 
% degrees of all subjects (Fig. 5a) and the individual mean node degree of
% each house (Fig. 5e)

% Input: 
% Overview_NodeDegree.mat  =  table consisting of all node degree values
%                             for all participants
% Output: 
% nodeDegree_imageScale.png = pseudo 3D plot color coding the node degree 
%                             centrality values for every house and every 
%                             participant (Fig. 5c)
% nodeDegree_mean_std_allHouses.png = error bar plot of mean and std for 
%                                     all houses (Fig. 5e)
% nodeDegree_mean_std_allParticipants.png = error bar plot of mean and std
%                                           for each participant (Fig. 5b)


clear all;

%% adjust the following variables: savepath and current folder!-----------

savepath = 'E:\Cyprus_project_overview\data\analysis\exploration\eyeTracking\graph-analysis-pipeline\nodeDegree_landmarks\';

cd 'E:\Cyprus_project_overview\data\analysis\exploration\graphs\';


imagepath = 'E:\Cyprus_project_overview\data\maps\';


clistpath = 'E:\Cyprus_project_overview\data\buildings\';
colliderList = readtable(strcat(clistpath, "building_coordinate_list.csv"));
colliderList.buildingNames = cellstr(string(colliderList.buildingNames));
%--------------------------------------------------------------------------

houseNames = colliderList.buildingNames';


%load graph
graphy = load('graph_limassol.mat');
graphy= graphy.graphy;


overviewNodeDegree = table;
overviewNodeDegree.nodes = graphy.Nodes.Name;
overviewNodeDegree.nodeDegree = degree(graphy);

for index = 1: height(overviewNodeDegree)

    currentNode = overviewNodeDegree.nodes(index);
    loc = strcmp(colliderList.buildingNames, currentNode);

    overviewNodeDegree.Longitude(index) = colliderList.Longitude(loc);
    overviewNodeDegree.Latitude(index) = colliderList.Latitude(loc);

end

writetable(overviewNodeDegree, [savepath 'overviewNodeDegree.csv']);



%% calculate mean over houses and sort table according to ascending mean ND of each house

meanNDofHouses = mean(overviewNodeDegree.nodeDegree);
stdND = std(overviewNodeDegree.nodeDegree);

landmarkThreshold = meanNDofHouses + 2*stdND;

landmarkIndex = overviewNodeDegree.nodeDegree > landmarkThreshold;
landmarks = overviewNodeDegree(landmarkIndex,:);
writetable(landmarks, [savepath 'list_gaze_graph_defined_landmarks.csv']);

disp(['mean node degree centrality:_ ', num2str(meanNDofHouses)])
disp(['std node degree centrality:_ ', num2str(stdND)])
disp(['Landmark Threshold:_ ', num2str(landmarkThreshold)])
disp(['Nr of GGLandmarks:_ ', num2str(height(landmarks))])

% sort overview based on mean value of each house (sort columns)


sortedbyH = sortrows(overviewNodeDegree,'nodeDegree','ascend');


%% create image scale

fig = figure(1);
imagescaly = imagesc(sortedbyH.nodeDegree');
colorbar
title({'Image Scale Node Degree Centrality in Cyprus'});
ax = gca;
% ax.XTick = 0:10:245;
% ax.TickDir = 'out';
% ax.XMinorTick = 'on';
% ax.XAxis.MinorTickValues = 1:1:245;
% ax.XLabel.String = 'Houses';
% ax.YLabel.String = 'Participants';



% mean and std for each house
figure(2)

% Normalize data to the range [0, 1] for colormap scaling
data_normalized = (sortedbyH.nodeDegree / max(sortedbyH.nodeDegree));

% Get the colormap colors based on normalized values
cmap = parula(256); % Define the colormap (256 levels)
color_indices = round(data_normalized * 255) + 1; % Map normalized data to colormap indices
bar_colors = cmap(color_indices, :); % Assign colors to each bar

% Create the bar plot

hold on;
for i = 1:length(sortedbyH.nodeDegree)
    bar(i, sortedbyH.nodeDegree(i), 'FaceColor', bar_colors(i, :), 'EdgeColor', 'none', 'LineWidth',0.001);
end
yline(landmarkThreshold, 'k')
hold off;

% Customize the plot
% set(gca, 'XTick', 1:length(sortedbyH.nodeDegree), 'XTickLabel', categories); % Set x-axis labels
set(gca, 'XTick', [], 'YTick', []); % Disable both x and y ticks
xlabel('Buildings');
ylabel('Values');
title('Bar Plot with Parula Colormap');
colorbar; % Optional: Add colorbar to show the scale of the colormap
colormap(parula); % Match the colorbar with the bar colors
caxis([0, max(sortedbyH.nodeDegree)]); % Set color axis range to match data values


 
figure(4) 

plotty4 = boxplot(overviewNodeDegree.nodeDegree);


title('Node degree centrality values')
% xlabel('participants');
ylabel('node degree')

% set(gca,'TickLabelInterpreter','none');
% set(gca,'XTickLabel',landmarkNames);

% legend({'boxplot + median','mean'},'location','northeast')
% 
saveas(gcf,strcat(savepath,'Boxplot_nodeDegree'));
ax = gca;
exportgraphics(ax,strcat(savepath,'Boxplot_nodeDegree_600DPI.png'),'Resolution',600)




%% map with node degree colors

% load map


map = imread (strcat(imagepath,'map2.jpg'));


% pixel values map picture  8192x5051
dimMap = size(map);
pixel_width = dimMap(2);  % Width of the image in pixels
pixel_height = dimMap(1);   % Height of the image in pixels

% small map --> map 1
% % latitude and longitude of the edges of the map image 
% corner_lat_top =  34.6776114; % Latitude of the top edge of the map
% corner_lat_bottom = 34.6718491;  % Latitude of the bottom edge of the map
% corner_lon_left = 33.0379205;  % Longitude of the left edge of the map
% corner_lon_right = 33.0492816; % Longitude of the right edge of the map

% big map --> map 2 data
% latitude and longitude of the edges of the map image 
corner_lat_top =  34.677833; % Latitude of the top edge of the map
corner_lat_bottom = 34.6714944;  % Latitude of the bottom edge of the map
corner_lon_left = 33.0378529;  % Longitude of the left edge of the map
corner_lon_right = 33.0496599; % Longitude of the right edge of the map


% Calculate differences in latitude and longitude
delta_lat = corner_lat_top - corner_lat_bottom;
delta_lon = corner_lon_right - corner_lon_left;

% Calculate conversion ratio from degrees to pixels
lat_to_pixel = pixel_height / delta_lat;
lon_to_pixel = pixel_width / delta_lon;

% Assuming df contains 'latitude' and 'longitude' columns
% Convert GPS coordinates to pixel coordinates
overviewNodeDegree.Longitude= (overviewNodeDegree.Longitude - corner_lon_left) * lon_to_pixel;
overviewNodeDegree.Latitude = (corner_lat_top - overviewNodeDegree.Latitude) * lat_to_pixel;

colliderList.Longitude= (colliderList.Longitude - corner_lon_left) * lon_to_pixel;
colliderList.Latitude = (corner_lat_top - colliderList.Latitude) * lat_to_pixel;


 % display map
figure(8)

imshow(map);
alpha(0.7)
hold on;

edgeCell = graphy.Edges.EndNodes;


for ee = 1:length(edgeCell)

   
    [Xhouse,Xindex] = ismember(edgeCell(ee,1),colliderList.buildingNames);
    
    [Yhouse,Yindex] = ismember(edgeCell(ee,2),colliderList.buildingNames);
    
    x1 = colliderList.Longitude(Xindex);
    y1 = colliderList.Latitude(Xindex);
    
    x2 = colliderList.Longitude(Yindex);
    y2 = colliderList.Latitude(Yindex);
    
    line([x1,x2],[y1,y2],'Color','k','LineWidth',0.5); 
    
end
%---------comment code until here to only show nodes without edges--------




%% visualize nodes color coded according to the node degree values
overviewNodeDegree = sortrows(overviewNodeDegree,'nodeDegree', 'ascend');

node = ismember(colliderList.buildingNames,overviewNodeDegree.nodes);

%overviewNodeDegree.nodeDegree*1.2+13

plotty = scatter(overviewNodeDegree.Longitude, overviewNodeDegree.Latitude, overviewNodeDegree.nodeDegree+10, overviewNodeDegree.nodeDegree,'filled');

colorbar
climits = caxis;


saveas(gcf,strcat(savepath,'GraphVisualization_nodeDegree'));
ax = gca;
exportgraphics(ax,strcat(savepath,'GraphVisualization_nodeDegree_600dpi.png'),'Resolution',600)


% plot Histogram as well
figure(9)

histy = histogram(overviewNodeDegree.nodeDegree);
hold on
xline(landmarkThreshold, LineStyle="-", Color='k')

title('node degree')
xlabel('node degree centrality')
ylabel('frequency')

saveas(gcf,strcat(savepath,'Histogram_distribution_NodeDegree_of_each_building'));
ax = gca;
exportgraphics(ax,strcat(savepath,'Histogram_distribution_NodeDegree_of_each_building_600dpi.png'),'Resolution',600)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% plot the landmarks on map and boxplots

figure(10)

imshow(map);
alpha(0.7)
hold on;


thresh = overviewNodeDegree.nodeDegree > landmarkThreshold;
landmarkP = overviewNodeDegree(thresh,:);

plotty = scatter(landmarkP.Longitude, landmarkP.Latitude,landmarkP.nodeDegree+10,landmarkP.nodeDegree,'filled','MarkerEdgeColor', 'k');

txt = landmarkP.nodes;
% txt = strcat('\leftarrow',landmarks.houseNames);
text(landmarkP.Longitude+100,landmarkP.Latitude,txt,'Interpreter', 'none')

caxis(climits);
colorbar


% 
saveas(gcf,strcat(savepath,'GraphVisualizion_landmarks_withNames'));
ax = gca;
exportgraphics(ax,strcat(savepath,'GraphVisualization_landmarks_withNames_600dpi.png'),'Resolution',600)

% -----------------------

figure(11)

imshow(map);
alpha(0.7)
hold on;


thresh = overviewNodeDegree.nodeDegree > landmarkThreshold;
landmarkP = overviewNodeDegree(thresh,:);

plotty = scatter(landmarkP.Longitude, landmarkP.Latitude,landmarkP.nodeDegree+10,landmarkP.nodeDegree,'filled','MarkerEdgeColor', 'k');

caxis(climits);
colorbar


saveas(gcf,strcat(savepath,'GraphVisualizion_landmarks'));
ax = gca;
exportgraphics(ax,strcat(savepath,'GraphVisualization_landmarks_600dpi.png'),'Resolution',600)


% %% ----------------boxplot
% 
% landmarks_sorted = sortrows(landmarks,'meanOfHouses','ascend');
% 
% landmarks_inv = landmarks_sorted{:,2:27}';
% landmarkNames = landmarks_sorted{:,1}';
% landmarkMeans = landmarks_sorted{:,28}';
% 
% figure(5) 
% 
% plotty5 = boxchart(landmarks_inv);
% % plotty5.JitterOutliers = 'on';
% % plotty5.MarkerStyle = '.';
% hold on
% 
% plot(landmarkMeans, '-o')
% 
% title('landmark node degree stats')
% xlabel('landmarks');
% ylabel('node degree')
% 
% set(gca,'TickLabelInterpreter','none');
% set(gca,'XTickLabel',landmarkNames);
% 
% legend({'boxplot + median','mean'},'location','northeastoutside')
% 
% saveas(gcf,strcat(savepath,'Boxplot_landmarks'));
% ax = gca;
% exportgraphics(ax,strcat(savepath,'Boxplot_landmarks_600dpi.png'),'Resolution',600)
% hold off
% 
% 
% 
% 
